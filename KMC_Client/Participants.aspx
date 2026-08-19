<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Participants.aspx.cs" Inherits="KMC_Client.Participants" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Public Events & Registration - KMC</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
         background :url('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1920&q=80') no-repeat center center fixed;
            background-attachment: fixed;
            margin: 0; 
            padding: 35px 15px; 
            min-height: 100vh;
        }

        .container { 
            max-width: 920px; 
            margin: auto; 
            background: rgba(255, 255, 255, 0.95); 
            backdrop-filter: blur(10px);
            padding: 25px 30px; 
            border-radius: 16px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15); 
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        h2 { color: #5B2C6F; text-align: center; margin-top: 5px; margin-bottom: 20px; font-weight: 700; }
        h3 { color: #5B2C6F; margin-top: 15px; margin-bottom: 12px; font-size: 1.2rem; }
        
        /* Search & Filter Bar Styling */
        .filter-card { 
            background: #F4ECF7; 
            padding: 12px 18px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            display: flex; 
            gap: 10px; 
            align-items: center; 
            justify-content: space-between; 
            flex-wrap: wrap; 
        }
        .filter-group { display: flex; gap: 8px; align-items: center; }
        
        /* Grid styling */
        .grid-view { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 10px; 
            margin-bottom: 20px; 
            overflow: hidden; 
            border-radius: 6px; 
            border: 1px solid #e1e4e8; 
        }
        .grid-view th { background-color: #8E44AD; color: white; padding: 10px; font-size: 0.95rem; }
        .grid-view td { padding: 8px 10px; border-bottom: 1px solid #eeeeee; text-align: center; font-size: 0.9rem; }
        .grid-view tr:hover { background-color: #f7f2fb; }
        
        /* Form Card */
        .card { 
            background: #ffffff; 
            padding: 20px; 
            border-radius: 10px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.03); 
            margin-top: 20px; 
            max-width: 650px; 
            margin-left: auto; 
            margin-right: auto; 
        }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 4px; font-size: 0.9rem; color: #333; }
        .form-control { padding: 8px 12px; box-sizing: border-box; border: 1px solid #cccccc; border-radius: 6px; font-size: 0.9rem; }
        .form-control-full { width: 100%; }
        .form-control:focus { border-color: #8E44AD; outline: none; }
        
        /* Buttons */
        .btn { padding: 8px 16px; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; font-size: 0.9rem; transition: background 0.2s; }
        .btn-search { background-color: #8E44AD; }
        .btn-search:hover { background-color: #763a91; }
        .btn-reset { background-color: #7F8C8D; }
        .btn-reset:hover { background-color: #6c7778; }
        .btn-register { background-color: #27AE60; font-size: 0.85rem; padding: 6px 12px; }
        .btn-register:hover { background-color: #219150; }
        .btn-submit { background-color: #8E44AD; width: 100%; padding: 10px; font-size: 1rem; margin-top: 10px; }
        .btn-submit:hover { background-color: #763a91; }



      .status-badge {
            display: inline-block;
            padding: 3px 8px;
            font-size: 0.75rem;
            font-weight: 700;
            border-radius: 12px;
            color: #ffffff;
            margin-left: 6px;
            text-transform: uppercase;
        }
        .badge-upcoming { background-color: #27AE60; } 
        .badge-today { background-color: #F39C12; }   
        .badge-past { background-color: #E74C3C; }     


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Kandy Municipal Council - Events</h2>

            <!-- 1. Search & Filter Section -->
            <div class="filter-card">
                <div class="filter-group">
                    <asp:TextBox ID="txtSearchName" runat="server" CssClass="form-control" Placeholder="Search Event Name..."></asp:TextBox>
                    
                    <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All Categories --" Value=""></asp:ListItem>
                    </asp:DropDownList>

                    <asp:TextBox ID="txtLocationFilter" runat="server" CssClass="form-control" Placeholder="Location..."></asp:TextBox>
                </div>

                <div class="filter-group">
                    <asp:Button ID="btnSearch" runat="server" Text="Search / Filter" CssClass="btn btn-search" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-reset" OnClick="btnReset_Click" />
                </div>
            </div>

            <!-- 2. View Events Table -->
            <h3>Available Events</h3>
            <p id="eventCounter" style="font-weight: 600; color: #5B2C6F; margin-top: -5px; margin-bottom: 10px; font-size: 0.95rem;">
                Showing 0 of 0 events
            </p>
            <asp:GridView ID="gvEvents" runat="server" AutoGenerateColumns="False" CssClass="grid-view" DataKeyNames="EventID" OnRowCommand="gvEvents_RowCommand" EmptyDataText="No events found matching your criteria.">
                
                <AlternatingRowStyle BackColor="#F9F9FB" />
                
                <Columns>
                    <asp:BoundField DataField="EventID" HeaderText="ID" />
                    <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="EventDate" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="Location" HeaderText="Location" />
                    
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="imgEvent" runat="server" ImageUrl='<%# Eval("ImageURL") %>' Height="50px" Width="70px" Style="object-fit: cover; border-radius: 4px;" AlternateText="No Image" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnRegisterNow" runat="server" Text="Register Now" CommandName="RegisterEvent" CommandArgument='<%# Eval("EventID") + "|" + Eval("EventName") %>' CssClass="btn btn-register" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- 3. Registration Form -->
            <asp:Panel ID="pnlRegisterForm" runat="server" Visible="false" CssClass="card">
                <h3 style="text-align: center; margin-top: 0;">Register for Event</h3>
                <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>

                <div class="form-group" style="margin-top: 10px;">
                    <label>Selected Event:</label>
                    <asp:TextBox ID="txtSelectedEvent" runat="server" CssClass="form-control form-control-full" ReadOnly="true" BackColor="#F2F4F7"></asp:TextBox>
                    <asp:HiddenField ID="hfSelectedEventID" runat="server" />
                </div>

                <div class="form-group">
                    <label>Full Name:</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-full"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Email Address:</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control form-control-full"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Phone Number:</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-full"></asp:TextBox>
                </div>

                <asp:Button ID="btnSubmitRegistration" runat="server" Text="Submit Registration" CssClass="btn btn-submit" OnClick="btnSubmitRegistration_Click" />
            </asp:Panel>

        </div>
    </form>

    <script type="text/javascript">
        document.addEventListener('keydown', function (e) {
            if (e.ctrlKey && e.shiftKey && (e.key === 'A' || e.key === 'a')) {
                e.preventDefault();
                let passCode = prompt("Enter Secret Admin Passcode : ");
                if (passCode === "1234") {
                    window.location.href = 'Events.aspx';
                }
                else if (passCode !== null) {
                    alert("Incorrect Passcode! Access Denied.");
                }
            }
        });

        function updateEventCounter() {
            var grid = document.getElementById('<%= gvEvents.ClientID %>');
            if (grid) {
                var rows = grid.getElementsByTagName('tr');
          
                var totalRows = rows.length > 0 ? rows.length - 1 : 0;

                var counter = document.getElementById('eventCounter');
                if (counter && totalRows > 0) {
                    counter.innerText = "Showing " + totalRows + " event(s)";
                } else if (counter) {
                    counter.innerText = "No events available";
                }
            }
        }

        function applyEventsStatusBadges() {
            var grid = document.getElementById('<%= gvEvents.ClientID %>');
            if (!grid) return;

            var rows = grid.getElementsByTagName('tr');
            var today = new Date();
            today.setHours(0, 0, 0, 0);

            for (var i = 1; i < rows.length; i++) { 
                var dateCell = rows[i].cells[3];   
                if (dateCell) {
                    var dateText = dateCell.innerText.trim();
                    if (dateText) {
                        var eventDate = new Date(dateText.replace(/-/g, '/'));
                        var eventDateOnly = new Date(eventDate.getFullYear(), eventDate.getMonth(), eventDate.getDate());

                        var badge = document.createElement('span');
                        badge.className = 'status-badge';

                        if (eventDateOnly > today) {
                            badge.innerText = 'Upcoming'; 
                            badge.classList.add('badge-upcoming');
                        }
                        else if (eventDateOnly.getTime() === today.getTime()) {
                            badge.innerText = 'Today';
                            badge.classList.add('badge-today'); 
                        }
                        else {
                            badge.innerText = 'Past';
                            badge.classList.add('badge-past');
                        }
                        dateCell.appendChild(badge);
                    }
                }
            }
        }


        window.addEventListener('DOMContentLoaded', function () {
            updateEventCounter();
            applyEventsStatusBadges();
        });
</script>