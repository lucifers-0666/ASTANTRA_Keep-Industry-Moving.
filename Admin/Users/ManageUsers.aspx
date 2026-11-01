<%@ Page Title="User Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Users.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Governance portal for managing system users, role authorizations, and account status." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex-1 overflow-y-auto p-8">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
            <div>
                <span class="text-xs font-bold text-blue-600 uppercase tracking-wider">Access Control & Governance</span>
                <h1 class="text-2xl font-bold text-slate-900 tracking-tight m-0">Platform User Directory</h1>
                <p class="text-xs text-slate-500 m-0 mt-1">Review authenticated accounts, manage role permissions, and toggle access states.</p>
            </div>
            <div class="flex items-center gap-3">
                <asp:DropDownList ID="ddlRoleFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlRoleFilter_SelectedIndexChanged" CssClass="text-xs px-3 py-2 border border-slate-300 rounded-lg bg-white">
                    <asp:ListItem Value="" Text="All System Roles"></asp:ListItem>
                    <asp:ListItem Value="Factory" Text="Factory Buyers"></asp:ListItem>
                    <asp:ListItem Value="Supplier" Text="Spare-Part Suppliers"></asp:ListItem>
                    <asp:ListItem Value="Technician" Text="Field Technicians"></asp:ListItem>
                    <asp:ListItem Value="Administrator" Text="System Administrators"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <!-- Alert Notification -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-lg bg-emerald-50 border border-emerald-200 text-xs text-emerald-800 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-emerald-600"></i>
                <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Users Table -->
        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-4 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
                <h2 class="text-xs font-bold text-slate-700 uppercase tracking-wider m-0">
                    Registered Accounts (<asp:Label ID="lblUsersCount" runat="server" Text="0"></asp:Label>)
                </h2>
            </div>

            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" DataKeyNames="UserId,IsActive" OnRowCommand="gvUsers_RowCommand" CssClass="w-full text-left text-xs border-collapse">
                <HeaderStyle CssClass="bg-slate-100 text-slate-600 font-bold text-[11px] uppercase tracking-wider border-b border-slate-200 p-3" />
                <RowStyle CssClass="border-b border-slate-100 hover:bg-slate-50" />
                <Columns>
                    <asp:BoundField DataField="UserId" HeaderText="ID" ItemStyle-CssClass="p-3 font-mono text-slate-500" />
                    <asp:BoundField DataField="FullName" HeaderText="Full Name" ItemStyle-CssClass="p-3 font-semibold text-slate-900" />
                    <asp:BoundField DataField="Email" HeaderText="Email Address" ItemStyle-CssClass="p-3 font-mono text-slate-600" />
                    <asp:TemplateField HeaderText="Assigned Role" ItemStyle-CssClass="p-3">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-bold <%# Eval("RoleName").ToString() == "Administrator" ? "bg-purple-100 text-purple-800" : Eval("RoleName").ToString() == "Factory" ? "bg-blue-100 text-blue-800" : Eval("RoleName").ToString() == "Supplier" ? "bg-emerald-100 text-emerald-800" : "bg-cyan-100 text-cyan-800" %>">
                                <%# Eval("RoleName") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Account Status" ItemStyle-CssClass="p-3">
                        <ItemTemplate>
                            <span class="inline-flex items-center gap-1 text-[11px] font-semibold <%# Convert.ToBoolean(Eval("IsActive")) ? "text-emerald-700" : "text-rose-700" %>">
                                <span class="w-1.5 h-1.5 rounded-full <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-emerald-500" : "bg-rose-500" %>"></span>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Deactivated" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-CssClass="p-3 text-slate-500 text-[11px]" />
                    <asp:TemplateField HeaderText="Governance Action" ItemStyle-CssClass="p-3 text-right">
                        <ItemTemplate>
                            <asp:Button ID="btnToggleStatus" runat="server" 
                                Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>' 
                                CommandName="ToggleActive" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-rose-600 hover:text-rose-800 text-[11px] font-bold cursor-pointer bg-rose-50 px-2 py-1 rounded border border-rose-200" : "text-emerald-600 hover:text-emerald-800 text-[11px] font-bold cursor-pointer bg-emerald-50 px-2 py-1 rounded border border-emerald-200" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
