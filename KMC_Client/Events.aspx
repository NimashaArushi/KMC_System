<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="KMC_Client.Events" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KMC Events Management</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f4f9; margin: 30px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2, h3 { color: #5B2C6F; text-align: center; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-control { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn { padding: 9px 18px; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-right: 5px; }
        .btn-save { background-color: #8E44AD; }
        .btn-clear { background-color: #7F8C8D; }
        .btn-edit { background-color: #2980B9; }
        .btn-delete { background-color: #C0392B; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #8E44AD; color: white; padding: 10px; }
        .grid-view td { padding: 10px; border: 1px solid #ddd; text-align: center; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Manage Events (Organizer Admin)</h2>

            <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>
            <asp:HiddenField ID="hfEventID" runat="server" />

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
                <label>Description / Category:</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Save Event" CssClass="btn btn-save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-clear" OnClick="btnClear_Click" />

            <hr style="margin-top:30px;" />

            <h3>All Events List</h3>
            <asp:GridView ID="gvEvents" runat="server" AutoGenerateColumns="False" CssClass="grid-view" DataKeyNames="EventID" OnRowCommand="gvEvents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="EventID" HeaderText="ID" />
                    <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                    <asp:BoundField DataField="EventDate" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="Location" HeaderText="Location" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditEvent" CommandArgument='<%# Eval("EventID") %>' CssClass="btn btn-edit" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteEvent" CommandArgument='<%# Eval("EventID") %>' CssClass="btn btn-delete" OnClientClick="return confirm('Are you sure?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>
    </form>
</body>
</html>