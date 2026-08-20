<%@ Page Title="Events" Language="C#" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="KMC_Client.Events" Async="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KMC Events Management</title>
    <style>
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background: url('https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1920&q=80') no-repeat center center fixed;
            background-size: cover;
            margin: 40px 0; 
            color: #1E293B;
        }

        .container { 
            max-width: 980px; 
            margin: auto; 
            background: #FFFFFF; 
            padding: 35px; 
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); 
        }

        .header-title { 
            color: #4A154B; 
            text-align: center; 
            margin-top: 0;
            margin-bottom: 25px; 
            font-weight: 800; 
            font-size: 28px;
            letter-spacing: -0.5px;
            border-bottom: 2px solid #E2E8F0;
            padding-bottom: 12px;
        }

        .section-title { 
            color: #4A154B; 
            margin-top: 35px; 
            margin-bottom: 20px;
            font-weight: 700; 
            text-align: center; 
            font-size: 22px;
        }

        .alert-message {
            display: block;
            margin: 15px 0 20px 0;
            padding: 12px 18px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
            background-color: #DEF7EC;
            color: #03543F;
            border: 1px solid #84E1BC;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .alert-message:empty {
            display: none;
        }

        .card-container {
            display: flex; 
            gap: 20px; 
            margin-bottom: 30px;
        }
        .card {
            flex: 1; 
            color: white; 
            padding: 22px; 
            border-radius: 12px; 
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover { 
            transform: translateY(-4px); 
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }
        .card h5 { 
            margin: 0; 
            font-size: 14px; 
            font-weight: 700; 
            text-transform: uppercase; 
            letter-spacing: 0.8px; 
            opacity: 0.9; 
        }
        .card h2 { 
            margin: 10px 0 0 0; 
            font-weight: 800; 
            font-size: 32px;
            color: #FFFFFF; 
            text-align: left; 
        }
        
        .card-events { background: linear-gradient(135deg, #4A154B 0%, #6B5B95 100%); }
        .card-participants { background: linear-gradient(135deg, #0083B0 0%, #00B4DB 100%); }
        .card-upcoming { background: linear-gradient(135deg, #F2994A 0%, #F2C94C 100%); }
        .card-upcoming h2, .card-upcoming h5 { color: #2C3E50; }

        .form-group { margin-bottom: 20px; }
        .form-group label { 
            display: block; 
            font-weight: 700; 
            margin-bottom: 8px; 
            color: #1E293B; 
            font-size: 14.5px;
        }
        .form-control { 
            width: 100%; 
            padding: 11px 14px; 
            box-sizing: border-box; 
            border: 1px solid #94A3B8; 
            background: #FFFFFF;
            border-radius: 8px; 
            font-size: 14px;
            color: #0F172A;
            font-weight: 500;
            outline: none;
            transition: all 0.2s ease;
        }
        .form-control:focus { 
            border-color: #4A154B; 
            box-shadow: 0 0 0 3px rgba(74, 21, 75, 0.15);
        }

        .btn { 
            padding: 9px 18px; 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-weight: 700; 
            font-size: 13.5px;
            transition: all 0.2s ease;
            display: inline-block;
        }
        .btn-save { background-color: #4A154B; padding: 12px 24px; font-size: 14px; border-radius: 8px; }
        .btn-save:hover { background-color: #350F36; transform: translateY(-1px); }
        .btn-clear { background-color: #64748B; padding: 12px 24px; font-size: 14px; border-radius: 8px; }
        .btn-clear:hover { background-color: #475569; transform: translateY(-1px); }

        .action-btn-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }

        .btn-edit { background-color: #2563EB; }
        .btn-edit:hover { background-color: #1D4ED8; transform: translateY(-1px); }
        .btn-delete { background-color: #DC2626; }
        .btn-delete:hover { background-color: #B91C1C; transform: translateY(-1px); }

        .grid-view { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 15px; 
            overflow: hidden; 
            border-radius: 10px; 
            background: #FFFFFF;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .grid-view th { background-color: #4A154B; color: white; padding: 14px; font-weight: 700; text-align: center; }
        .grid-view td { padding: 12px; border: 1px solid #E2E8F0; text-align: center; color: #1E293B; font-weight: 500; vertical-align: middle; }
        .grid-view tr:nth-child(even) { background-color: #F8FAFC; }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            width: 400px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        .modal-header { font-size: 18px; font-weight: 700; margin-bottom: 8px; color: #4A154B; }
        .modal-subtext { font-size: 13px; color: #64748B; margin-bottom: 20px; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            
            <h2 class="header-title">Manage Events 🤩 (Organizer Admin)</h2>
            
            <div class="card-container">
                <div class="card card-events">
                    <h5>📅 Total Events</h5>
                    <h2><asp:Label ID="lblTotalEvents" runat="server" Text="0"></asp:Label></h2>
                </div>

                <div class="card card-participants">
                    <h5>👥 Total Participants</h5>
                    <h2><asp:Label ID="lblTotalParticipants" runat="server" Text="0"></asp:Label></h2>
                </div>

                <div class="card card-upcoming">
                    <h5>⏳ Upcoming Events</h5>
                    <h2><asp:Label ID="lblUpcomingEvents" runat="server" Text="0"></asp:Label></h2>
                </div>
            </div>
            
            <asp:Label ID="lblMessage" runat="server" CssClass="alert-message"></asp:Label>

            <asp:HiddenField ID="hfEventID" runat="server" />
            <asp:HiddenField ID="hfExistingImageURL" runat="server" />
            <asp:HiddenField ID="hfOrganizerEmail" runat="server" />
            <asp:HiddenField ID="hfOrganizerPassword" runat="server" />

            <div class="form-group">
                <label>Event Name:</label>
                <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Event Date & Time:</label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Location:</label>
                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Organizer Name:</label>
                <asp:TextBox ID="txtOrganizerName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Event Image:</label>
                <asp:FileUpload ID="fuEventImage" runat="server" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label>Description / Category:</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Save Event" CssClass="btn btn-save" OnClick="btnSave_Click" OnClientClick="return handleSaveClick();" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-clear" OnClick="btnClear_Click" />

            <hr style="margin-top:35px; border: 0; border-top: 1px solid #E2E8F0;" />

            <h3 class="section-title">All Events List</h3>
            
            <asp:GridView ID="gvEvents" runat="server" AutoGenerateColumns="False" CssClass="grid-view" DataKeyNames="EventID" OnRowCommand="gvEvents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="EventID" HeaderText="ID" />
                    <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                    <asp:BoundField DataField="EventDate" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="N/A" />
                    <asp:BoundField DataField="Location" HeaderText="Location" />
                    <asp:BoundField DataField="OrganizerName" HeaderText="Organizer Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />

                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="imgEvent" runat="server" ImageUrl='<%# Eval("ImageURL") %>' Height="55px" Width="75px" Style="object-fit: cover; border-radius: 6px;" AlternateText="No Image" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="action-btn-container">
                                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditEvent" CommandArgument='<%# Eval("EventID") %>' CssClass="btn btn-edit" />
                                <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteEvent" CommandArgument='<%# Eval("EventID") %>' CssClass="btn btn-delete" OnClientClick="return confirm('Are you sure?');" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- Organizer Verification Modal -->
            <div id="verifyModal" class="modal-overlay">
                <div class="modal-box">
                    <div class="modal-header">Organizer Verification 🔒</div>
                    <div class="modal-subtext">Please enter your Organizer Email and Password to confirm these changes.</div>
                    
                    <div class="form-group">
                        <label>Organizer Email:</label>
                        <input type="email" id="modalEmail" class="form-control" placeholder="Enter Email" />
                    </div>

                    <div class="form-group">
                        <label>Password:</label>
                        <input type="password" id="modalPassword" class="form-control" placeholder="Enter Password" />
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-clear" onclick="closeModal()">Cancel</button>
                        <button type="button" class="btn btn-save" onclick="confirmUpdate()">Confirm & Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        let isVerified = false;

        function handleSaveClick() {
            var eventId = document.getElementById('<%= hfEventID.ClientID %>').value;

            // Allow direct save if creating a new event
            if (!eventId || eventId === "0" || eventId === "") {
                return true;
            }

            // Stop submission for updates until verified via Modal
            if (!isVerified) {
                openModal();
                return false;
            }

            return true;
        }

        function openModal() {
            document.getElementById('verifyModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('verifyModal').style.display = 'none';
            document.getElementById('modalEmail').value = '';
            document.getElementById('modalPassword').value = '';
        }

        function confirmUpdate() {
            var email = document.getElementById('modalEmail').value;
            var password = document.getElementById('modalPassword').value;

            if (!email || !password) {
                alert("Please enter both Email and Password!");
                return;
            }

            document.getElementById('<%= hfOrganizerEmail.ClientID %>').value = email;
            document.getElementById('<%= hfOrganizerPassword.ClientID %>').value = password;

            isVerified = true;
            closeModal();
            
            document.getElementById('<%= btnSave.ClientID %>').click();
        }
    </script>
</body>
</html>