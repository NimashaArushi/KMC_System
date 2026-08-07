using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Web.UI;
using System.Net.Http.Formatting;
using System.Web.UI.WebControls;
using KMC_API.Models;

namespace KMC_Client
{
    public partial class Events : Page
    {
       
        private string apiUrl = "https://localhost:44332/api/events/";

        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEvents();
            }
        }

   
        private void LoadEvents()
        {
            HttpClient httpClient = new HttpClient();
            using (HttpClient client = httpClient)
            {
                HttpResponseMessage response = client.GetAsync(apiUrl).Result;

                if (response.IsSuccessStatusCode)
                {
                    var events = response.Content.ReadAsAsync<List<Event>>().Result;

                    gvEvents.DataSource = events;
                    gvEvents.DataBind();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int eventId = Convert.ToInt32(hfEventID.Value);

            Event evt = new Event
            {
                EventID = eventId,
                EventName = txtEventName.Text,
                EventDate = Convert.ToDateTime(txtDate.Text), 
                Location = txtLocation.Text,
                Category = txtDescription.Text 
            };


            using (HttpClient client = new HttpClient())
            {
                if (eventId == 0)
                {
                    HttpResponseMessage response = client.PostAsJsonAsync(apiUrl, evt).Result;
                    lblMessage.Text = "Event Saved Successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    HttpResponseMessage response = client.PutAsJsonAsync(apiUrl + eventId, evt).Result;
                    lblMessage.Text = "Event Updated Successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
            }

            ClearForm();
            LoadEvents();
        }

        protected void gvEvents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRow")
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = client.GetAsync(apiUrl + id).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        var evt = response.Content.ReadAsAsync<Event>().Result;

                        hfEventID.Value = evt.EventID.ToString();
                        txtEventName.Text = evt.EventName;
                        txtDate.Text = evt.EventDate.ToString("yyyy-MM-ddTHH:mm");
                        txtLocation.Text = evt.Location;
                        txtDescription.Text = evt.Category;

                        btnSave.Text = "Update Event";
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = client.DeleteAsync(apiUrl + id).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        lblMessage.Text = "Event Deleted Successfully!";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
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
            hfEventID.Value = "0";
            txtEventName.Text = "";
            txtDate.Text = "";
            txtLocation.Text = "";
            txtDescription.Text = "";
            btnSave.Text = "Save Event";
        }
    }
}