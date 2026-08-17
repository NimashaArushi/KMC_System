using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace KMC_Client
{
    public partial class Events : Page
    {
        private readonly string apiBaseUrl = "https://localhost:44332/api/";

        public object DataTime { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEvents();
            }
        }

        private void LoadEvents()
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(apiBaseUrl);
                HttpResponseMessage response = client.GetAsync("events").Result;

                if (response.IsSuccessStatusCode)
                {
                    string json = response.Content.ReadAsStringAsync().Result;
                    var events = JsonConvert.DeserializeObject<List<EventModel>>(json);
                    gvEvents.DataSource = events;
                    gvEvents.DataBind();

                    UpdateDashboardCards(events);
                }
            }
        }

        private void UpdateDashboardCards(List<EventModel> events)
        {

            if (events != null) {
                lblTotalEvents.Text = events.Count.ToString();
                lblTotalParticipants.Text = "0";

                int upcomingCount = events.Count(e => e.EventDate >= DateTime.Now);
                lblUpcomingEvents.Text = upcomingCount.ToString();
                GetTotalParticipantsCount();
            }
            else
            {
                lblTotalEvents.Text = "0";
                lblTotalParticipants.Text = "0";
                lblUpcomingEvents.Text = "0";
            }
        


    }

        private void GetTotalParticipantsCount()
        {

            try {
                using (var client = new HttpClient()) {
                    client.BaseAddress = new Uri(apiBaseUrl);
                    HttpResponseMessage response = client.GetAsync("participants").Result;

                    if (response.IsSuccessStatusCode) {
                        string json = response.Content.ReadAsStringAsync().Result;
                        var registrationsList = JsonConvert.DeserializeObject<List<object>>(json);
                        lblTotalParticipants.Text = registrationsList != null ? registrationsList.Count.ToString() : "0";
                    }
                    else
                    {
                        lblTotalParticipants.Text = "0";
                    }
                }
            }
            catch
            {
                lblTotalParticipants.Text = "0";
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string imageUrl = "";

            // File Upload Logic
            if (fuEventImage.HasFile)
            {
                string fileName = Path.GetFileName(fuEventImage.FileName);
                string uniqueFileName = Guid.NewGuid().ToString() + "_" + fileName;
                string folderPath = Server.MapPath("~/Uploads/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string filePath = Path.Combine(folderPath, uniqueFileName);
                fuEventImage.SaveAs(filePath);

                imageUrl = "/Uploads/" + uniqueFileName;
            }

            var eventObj = new EventModel
            {
                EventName = txtEventName.Text.Trim(),
                EventDate = string.IsNullOrEmpty(txtDate.Text) ? DateTime.Now : Convert.ToDateTime(txtDate.Text),
                Location = txtLocation.Text.Trim(),
                Category = txtDescription.Text.Trim(),
                ImageURL = imageUrl,
                OrganizerName=string.IsNullOrWhiteSpace(txtOrganizerName.Text) ? "Kandy Municipal Council"
                        : txtOrganizerName.Text
           
        };

            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(apiBaseUrl);
                HttpResponseMessage response;

                if (string.IsNullOrEmpty(hfEventID.Value))
                {
                    string json = JsonConvert.SerializeObject(eventObj);
                    var content = new StringContent(json, Encoding.UTF8, "application/json");
                    response = client.PostAsync("events", content).Result;
                }
                else
                {
                    int id = Convert.ToInt32(hfEventID.Value);
                    eventObj.EventID = id;

                    var existingImageField = (HiddenField)FindControl("hfExistingImageURL");
                    if (!fuEventImage.HasFile && existingImageField != null && !string.IsNullOrEmpty(existingImageField.Value))
                    {
                        eventObj.ImageURL = existingImageField.Value;
                    }

                    string json = JsonConvert.SerializeObject(eventObj);
                    var content = new StringContent(json, Encoding.UTF8, "application/json");
                    response = client.PutAsync("events/" + id, content).Result;
                }

                if (response.IsSuccessStatusCode)
                {
                    lblMessage.Text = "Event saved successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    ClearForm();
                    LoadEvents();
                }
                else
                {
                    string errorDetails = response.Content.ReadAsStringAsync().Result;
                    lblMessage.Text = $"Error: {response.StatusCode} - {response.ReasonPhrase}. Details: {errorDetails}";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int eventId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditEvent")
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(apiBaseUrl);
                    HttpResponseMessage response = client.GetAsync("events/" + eventId).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string json = response.Content.ReadAsStringAsync().Result;
                        var ev = JsonConvert.DeserializeObject<EventModel>(json);

                        if (ev != null)
                        {
                            hfEventID.Value = ev.EventID.ToString();
                            txtEventName.Text = ev.EventName;
                            txtDate.Text = ev.EventDate.ToString("yyyy-MM-ddTHH:mm");
                            txtLocation.Text = ev.Location;
                            txtDescription.Text = ev.Category;

                        
                            var existingImageField = (HiddenField)FindControl("hfExistingImageURL");
                            if (existingImageField != null)
                            {
                                existingImageField.Value = ev.ImageURL;
                            }

                            btnSave.Text = "Update Event";
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteEvent")
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(apiBaseUrl);
                    HttpResponseMessage response = client.DeleteAsync("events/" + eventId).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        lblMessage.Text = "Event deleted successfully!";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        LoadEvents();
                    }
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfEventID.Value = "";
            txtEventName.Text = "";
            txtDate.Text = "";
            txtLocation.Text = "";
            txtDescription.Text = "";
            btnSave.Text = "Save Event";
            lblMessage.Text = "";

            var existingImageField = (HiddenField)FindControl("hfExistingImageURL");
            if (existingImageField != null)
            {
                existingImageField.Value = "";
            }
        }

        public class EventModel
        {
            public int EventID { get; set; }
            public string EventName { get; set; }
            public DateTime EventDate { get; set; }
            public string Location { get; set; }
            public string Category { get; set; }
            public string ImageURL { get; set; }
            public string OrganizerName { get; set; }
            public int EventsDate { get; internal set; }
        }
    }
}