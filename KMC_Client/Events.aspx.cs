using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace KMC_Client
{
    public partial class Events : Page
    {
        private readonly string apiBaseUrl = "https://localhost:44332/api/Events";
        protected async void Page_Load(object sender, EventArgs e)
        {
           
            System.Net.ServicePointManager.ServerCertificateValidationCallback =
                delegate { return true; };

            if (!IsPostBack)
            {
                await LoadEventsAsync();
            }
        }
        private async Task LoadEventsAsync()
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = await client.GetAsync(apiBaseUrl);

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = await response.Content.ReadAsStringAsync();

                        var settings = new JsonSerializerSettings
                        {
                            NullValueHandling = NullValueHandling.Ignore,
                            MissingMemberHandling = MissingMemberHandling.Ignore
                        };

                        List<EventViewModel> events = JsonConvert.DeserializeObject<List<EventViewModel>>(jsonString, settings)
                                                     ?? new List<EventViewModel>();

                        gvEvents.DataSource = events;
                        gvEvents.DataBind();

                        lblTotalEvents.Text = events.Count.ToString();

                        int upcomingCount = events.Count(x => x.EventDate.HasValue && x.EventDate.Value >= DateTime.Now);
                        lblUpcomingEvents.Text = upcomingCount.ToString();
                    }
                    else
                    {
                        ShowAlert("Failed to load events from API.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading events: " + ex.Message, false);
            }
        }

        protected async void btnSave_Click(object sender, EventArgs e)
        {
            await SaveEventAsync();
        }

        private async Task SaveEventAsync()
        {
            try
            {
                // Validate Date Input safely
                if (string.IsNullOrWhiteSpace(txtDate.Text) || !DateTime.TryParse(txtDate.Text, out DateTime parsedDate))
                {
                    ShowAlert("Please select a valid Event Date & Time! 📅", false);
                    return;
                }

                string eventId = hfEventID.Value;
                string imageUrl = hfExistingImageURL.Value;

                if (fuEventImage.HasFile)
                {
                    string fileName = Path.GetFileName(fuEventImage.FileName);
                    string folderPath = Server.MapPath("~/Images/");

                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    string fullPath = Path.Combine(folderPath, fileName);
                    fuEventImage.SaveAs(fullPath);
                    imageUrl = "~/Images/" + fileName;
                }

                var eventData = new EventViewModel
                {
                    EventID = string.IsNullOrEmpty(eventId) ? 0 : Convert.ToInt32(eventId),
                    EventName = txtEventName.Text.Trim(),
                    EventDate = parsedDate,
                    Location = txtLocation.Text.Trim(),
                    OrganizerName = txtOrganizerName.Text.Trim(),
                    Category = txtDescription.Text.Trim(),
                    ImageURL = imageUrl
                };

                using (HttpClient client = new HttpClient())
                {
                    if (string.IsNullOrEmpty(eventId) || eventId == "0")
                    {
                        // POST (Create)
                        string jsonPayload = JsonConvert.SerializeObject(eventData);
                        HttpContent content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

                        HttpResponseMessage response = await client.PostAsync(apiBaseUrl, content);
                        if (response.IsSuccessStatusCode)
                        {
                            ShowAlert("Event created successfully! 🎉", true);
                            ClearForm();
                            await LoadEventsAsync();
                        }
                        else
                        {
                            ShowAlert("Failed to create event.", false);
                        }
                    }
                    else
                    {
                        // PUT (Update)
                        var updatePayload = new
                        {
                            Event = eventData,
                            Email = hfOrganizerEmail.Value.Trim(),
                            Password = hfOrganizerPassword.Value.Trim()
                        };

                        string jsonPayload = JsonConvert.SerializeObject(updatePayload);
                        HttpContent content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

                        HttpResponseMessage response = await client.PutAsync($"{apiBaseUrl}/{eventId}", content);

                        if (response.IsSuccessStatusCode)
                        {
                            ShowAlert("Event updated successfully! ✏️", true);
                            ClearForm();
                            await LoadEventsAsync();
                        }
                        else if (response.StatusCode == System.Net.HttpStatusCode.Unauthorized || response.StatusCode == System.Net.HttpStatusCode.Forbidden)
                        {
                            ShowAlert("Verification failed! Invalid organizer email or password. ❌", false);
                        }
                        else
                        {
                            ShowAlert("Failed to update event.", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, false);
            }
        }

        protected async void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int eventId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditEvent")
            {
                await PopulateFormForEditAsync(eventId);
            }
            else if (e.CommandName == "DeleteEvent")
            {
                await DeleteEventAsync(eventId);
            }
        }

        private async Task PopulateFormForEditAsync(int eventId)
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = await client.GetAsync($"{apiBaseUrl}/{eventId}");
                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = await response.Content.ReadAsStringAsync();
                        var selectedEvent = JsonConvert.DeserializeObject<EventViewModel>(jsonString);

                        if (selectedEvent != null)
                        {
                            hfEventID.Value = selectedEvent.EventID.ToString();
                            txtEventName.Text = selectedEvent.EventName;
                            txtLocation.Text = selectedEvent.Location;
                            txtOrganizerName.Text = selectedEvent.OrganizerName;
                            txtDescription.Text = selectedEvent.Category;
                            hfExistingImageURL.Value = selectedEvent.ImageURL;

                            if (selectedEvent.EventDate.HasValue)
                            {
                                txtDate.Text = selectedEvent.EventDate.Value.ToString("yyyy-MM-ddTHH:mm");
                            }

                            btnSave.Text = "Update Event";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error fetching details: " + ex.Message, false);
            }
        }

        private async Task DeleteEventAsync(int eventId)
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = await client.DeleteAsync($"{apiBaseUrl}/{eventId}");
                    if (response.IsSuccessStatusCode)
                    {
                        ShowAlert("Event deleted successfully! 🗑️", true);
                        await LoadEventsAsync();
                    }
                    else
                    {
                        ShowAlert("Failed to delete event.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting event: " + ex.Message, false);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfEventID.Value = "";
            hfExistingImageURL.Value = "";
            hfOrganizerEmail.Value = "";
            hfOrganizerPassword.Value = "";
            txtEventName.Text = "";
            txtDate.Text = "";
            txtLocation.Text = "";
            txtOrganizerName.Text = "";
            txtDescription.Text = "";
            btnSave.Text = "Save Event";
            lblMessage.Text = "";
            lblMessage.CssClass = "alert-message";
        }

        private void ShowAlert(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            if (isSuccess)
            {
                lblMessage.Style["background-color"] = "#DEF7EC";
                lblMessage.Style["color"] = "#03543F";
                lblMessage.Style["border"] = "1px solid #84E1BC";
            }
            else
            {
                lblMessage.Style["background-color"] = "#FDE8E8";
                lblMessage.Style["color"] = "#9B1C1C";
                lblMessage.Style["border"] = "1px solid #F8B4B4";
            }
        }
    }

    public class EventViewModel
    {
        public int EventID { get; set; }
        public string EventName { get; set; }
        public DateTime? EventDate { get; set; }
        public string Location { get; set; }
        public string OrganizerName { get; set; }
        public string Category { get; set; }
        public string ImageURL { get; set; }
    }
}