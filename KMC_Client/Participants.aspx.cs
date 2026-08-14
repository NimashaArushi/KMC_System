using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace KMC_Client
{
    public partial class Participants : Page
    {
        private readonly string apiBaseUrl = "https://localhost:44332/api/";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEventsGrid();
            }
        }

        private void LoadEventsGrid()
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(apiBaseUrl);
                HttpResponseMessage response = client.GetAsync("events").Result;

                if (response.IsSuccessStatusCode)
                {
                    string json = response.Content.ReadAsStringAsync().Result;
                    var events = JsonConvert.DeserializeObject<List<EventModel>>(json);

                   
                    ViewState["AllEvents"] = events;

                    // Category DropDown 
                    if (ddlCategoryFilter.Items.Count <= 1)
                    {
                        var categories = events.Select(x => x.Category).Distinct().ToList();
                        foreach (var cat in categories)
                        {
                            if (!string.IsNullOrEmpty(cat) && ddlCategoryFilter.Items.FindByValue(cat) == null)
                            {
                                ddlCategoryFilter.Items.Add(new ListItem(cat, cat));
                            }
                        }
                    }

                    gvEvents.DataSource = events;
                    gvEvents.DataBind();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (ViewState["AllEvents"] != null)
            {
                var events = (List<EventModel>)ViewState["AllEvents"];

                // 1. Search 
                if (!string.IsNullOrEmpty(txtSearchName.Text.Trim()))
                {
                    events = events.Where(x => x.EventName != null &&
                             x.EventName.IndexOf(txtSearchName.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();
                }

                // 2. Category Filter 
                string selectedCategory = ddlCategoryFilter.SelectedValue;
                if (!string.IsNullOrEmpty(selectedCategory) && selectedCategory != "0" && selectedCategory != "-- All Categories --")
                {
                    events = events.Where(x => x.Category != null &&
                             x.Category.Equals(selectedCategory, StringComparison.OrdinalIgnoreCase)).ToList();
                }

                // 3. Location 
                if (!string.IsNullOrEmpty(txtLocationFilter.Text.Trim()))
                {
                    events = events.Where(x => x.Location != null &&
                             x.Location.IndexOf(txtLocationFilter.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();
                }

                // Filter
                gvEvents.DataSource = events;
                gvEvents.DataBind();
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearchName.Text = "";
            ddlCategoryFilter.SelectedIndex = 0;
            txtLocationFilter.Text = "";
            LoadEventsGrid();
        }

        protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RegisterEvent")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                string eventId = args[0];
                string eventName = args.Length > 1 ? args[1] : "";

                hfSelectedEventID.Value = eventId;
                txtSelectedEvent.Text = eventName + " (ID: " + eventId + ")";

                pnlRegisterForm.Visible = true;
                lblMessage.Text = "";
            }
        }

        protected void btnSubmitRegistration_Click(object sender, EventArgs e)
        {
            var participantData = new
            {
                FullName = txtFullName.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                Phone = txtPhone.Text.Trim(),
                EventID = Convert.ToInt32(hfSelectedEventID.Value)
            };

            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(apiBaseUrl);
                string json = JsonConvert.SerializeObject(participantData);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync("participants", content).Result;

                if (response.IsSuccessStatusCode)
                {
                    lblMessage.Text = "Registration Successful!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;

                    txtFullName.Text = "";
                    txtEmail.Text = "";
                    txtPhone.Text = "";
                }
                else
                {
                    lblMessage.Text = "Error in Registration. Please try again.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        [Serializable]
        public class EventModel
        {
            public int EventID { get; set; }
            public string EventName { get; set; }
            public string Category { get; set; }
            public DateTime EventDate { get; set; }
            public string Location { get; set; }
            public string ImageURL { get; set; }
        }
    }
}