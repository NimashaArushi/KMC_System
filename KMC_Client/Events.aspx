<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="KMC_Client.Events" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KMC-Events Managemnet</title>
  <style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
        background-image: url('https://i.pinimg.com/1200x/5f/ef/24/5fef24f9d255100c233a3f32cbb2d5ee.jpg');
        background-repeat: no-repeat;
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        color: #000000; 
    }


    .container {
        background-color: rgba(255, 255, 255, 0.92); 
        padding: 25px;
        border-radius: 8px;
        max-width: 900px;
        margin: 0 auto;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    }

    h2, h3 {
        text-align: center;
        color: #4c00b0; 
        margin-bottom: 20px;
    }

    .form-group {
        margin-bottom: 15px;
    }

      .form-group label {
          display: inline-block;
          width: 120px;
          font-weight: bold;
          color: #000000;
      }
   
    .btn {
        padding: 8px 18px;
        cursor: pointer;
        background-color: #ca5cdd; 
        color: #ffffff; 
        border: 1px solid #b100cd;
        font-weight: bold;
        border-radius: 4px;
    }

    .btn:hover {
        background-color: #be2ed6;
    }


    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #ffffff;
    }

    table, th, td {
        border: 1px solid #000000; 
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #ca5cdd; 
        color: #ffffff; 
    }

   
    tr:nth-child(even) {
        background-color: #e8bcf0;
    }
</style>
</head>
  

<body class="bg-light">
    <form id="form1" runat="server">
        <h2>KMC Events Management</h2>
        <asp:Label ID="lblMessage" runat="server" Font-Bold="true"></asp:Label>
        
        <asp:HiddenField ID="hfEventID" runat="server" Value="0" />

        <fieldset style="margin-top:15px;padding:15px;">
            <legend><b>Manage Event</b></legend>

            <div class="form-group">
                <label>Event Name </label>
                <asp:TextBox ID="txtEventName" runat="server"></asp:TextBox>
           </div>


              <div class="form-group">
                <label>Date </label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="DateTimeLocal"></asp:TextBox>
           </div>


              <div class="form-group">
                <label>Location</label>
                <asp:TextBox ID="txtLocation" runat="server"></asp:TextBox>
           </div>


              <div class="form-group">
                <label>Description </label>
                <asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
           </div>


            <div>
                <asp:Button ID="btnSave" runat="server" Text="Save Event" OnClick="btnSave_Click" CssClass="btn" />
                <asp:Button ID="btnclear" runat="server" Text="Clear" OnClick="btnClear_click"   CssClass="btn" />

            </div>
            <br /></fieldset>

         <h3>Events List</h3>
        <asp:GridView ID ="gvEvents" runat="server" AutoGenerateColumns="false" DataKeyNames="EventID"
            OnRowCommand="gvEvents_RowCommand">
            <Columns>
                <asp:BoundField DataField="EventID" HeaderText="ID" />
                <asp:BoundField DataField="EventName" HeaderText="Event Name" />
                <asp:BoundField DataField="Date" HeaderText="Date" />
                <asp:BoundField DataField="Location" HeaderText="Location" />
                <asp:BoundField DataField="Description" HeaderText="Description" />

                <asp:TemplateField HeaderText="Actions" >
<ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("EventID") %>' Text="Edit" />
                        <asp:Button ID="btnDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("EventID") %>' Text="Delete" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

    </form>
</body>
</html>