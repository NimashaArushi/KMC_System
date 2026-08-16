<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Participants.aspx.cs" Inherits="KMC_Client.Participants" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Public Events & Registration - KMC</title>
    <style>
body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
   
    background: linear-gradient(135deg, rgba(251, 247, 252, 0.88) 0%, rgba(232, 213, 245, 0.85) 100%), 
                url('https://t4.ftcdn.net/jpg/03/55/15/09/240_F_355150915_NMxtxVViYCZ3kzzNLSLS2y98GySqcuVq.jpg') no-repeat center center fixed;
    
    background-size: cover; 
    margin: 0; 
    padding: 35px 15px; 
    min-height: 100vh;
}
    
    background-size: cover; 
    margin: 0; 
    padding: 35px 15px; 
    min-height: 100vh;
}
       .container { 
    max-width: 920px; 
    margin: auto; 
 
    background: rgba(255, 255, 255, 0.94); 
    backdrop-filter: blur(10px);
    padding: 25px 30px; 
    border-radius: 16px; 
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); 
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
                
                <%-- Alternating Row style to remove pure white dominance --%>
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
</body>
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

    </script>
</html>