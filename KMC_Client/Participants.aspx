<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Participants.aspx.cs" Inherits="KMC_Client.Participants" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Public Events & Registration - KMC</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f9; margin: 30px; }
        .container { max-width: 950px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2, h3 { color: #5B2C6F; text-align: center; }
        
        /* Search & Filter Bar Styling */
        .filter-card { background: #F4ECF7; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; gap: 10px; align-items: center; justify-content: space-between; flex-wrap: wrap; }
        .filter-group { display: flex; gap: 8px; align-items: center; }
        
        /* Grid styling */
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 15px; margin-bottom: 30px; }
        .grid-view th { background-color: #8E44AD; color: white; padding: 10px; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; text-align: center; }
        
        /* Form Card */
        .card { background: #f9f9f9; padding: 20px; border-radius: 8px; border: 1px solid #ddd; margin-top: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-control { padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .form-control-full { width: 100%; }
        
        /* Buttons */
        .btn { padding: 8px 16px; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-search { background-color: #8E44AD; }
        .btn-reset { background-color: #7F8C8D; }
        .btn-register { background-color: #27AE60; }
        .btn-register:hover { background-color: #219150; }
        .btn-submit { background-color: #8E44AD; width: 100%; padding: 10px; }
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
            <asp:GridView ID="gvEvents" runat="server" AutoGenerateColumns="False" CssClass="grid-view" DataKeyNames="EventID" OnRowCommand="gvEvents_RowCommand" EmptyDataText="No events found matching your criteria.">
                <Columns>
                    <asp:BoundField DataField="EventID" HeaderText="ID" />
                    <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="EventDate" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="Location" HeaderText="Location" />
                    
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnRegisterNow" runat="server" Text="Register Now" CommandName="RegisterEvent" CommandArgument='<%# Eval("EventID") + "|" + Eval("EventName") %>' CssClass="btn btn-register" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <!-- 3. Registration Form (Shows when 'Register Now' is clicked) -->
            <asp:Panel ID="pnlRegisterForm" runat="server" Visible="false" CssClass="card">
                <h3>Register for Event</h3>
                <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>
                <br /><br />

                <div class="form-group">
                    <label>Selected Event:</label>
                    <asp:TextBox ID="txtSelectedEvent" runat="server" CssClass="form-control form-control-full" ReadOnly="true" BackColor="#EAEAEA"></asp:TextBox>
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
</body>
</html>