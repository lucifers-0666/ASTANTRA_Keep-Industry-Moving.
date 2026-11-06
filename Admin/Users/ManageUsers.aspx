<%@ Page Title="System User Directory & RBAC Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Users.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">ACCESS CONTROL &amp; RBAC GOVERNANCE</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Platform User Directory &amp; Role Segmentation</h1>
            <p class="text-xs text-[#64748B] m-0">Segmented user governance across Factory Buyers, Stocking Suppliers, Field Technicians, and System Administrators.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Register New User" OnClick="btnOpenAddModal_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded border text-xs flex items-center justify-between admin-animate-enter">
        <div class="flex items-center gap-2">
            <i id="iconAlert" runat="server" class="fa-solid fa-circle-check text-emerald-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Role Segmentation Telemetry Cards (Interactive Segment Switchers) -->
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3.5 mb-6 admin-animate-enter admin-stagger-1">
        <!-- 1. All Users -->
        <asp:LinkButton ID="btnSegmentAll" runat="server" OnClick="btnSegment_Click" CommandArgument="" CssClass="surface-card p-3.5 border-l-4 border-l-slate-700 hover:shadow-md transition-all text-left no-underline group block">
            <div class="flex items-center justify-between text-slate-500">
                <span class="text-[10px] font-mono uppercase font-bold text-[#64748B]">All Accounts</span>
                <i class="fa-solid fa-users text-xs text-slate-400 group-hover:text-slate-700"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblCountAll" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block">Total registered</span>
            </div>
        </asp:LinkButton>

        <!-- 2. Factory Buyers -->
        <asp:LinkButton ID="btnSegmentFactories" runat="server" OnClick="btnSegment_Click" CommandArgument="Factory" CssClass="surface-card p-3.5 border-l-4 border-l-amber-500 hover:shadow-md transition-all text-left no-underline group block">
            <div class="flex items-center justify-between text-slate-500">
                <span class="text-[10px] font-mono uppercase font-bold text-amber-700">Factory Buyers</span>
                <i class="fa-solid fa-industry text-xs text-amber-500 group-hover:text-amber-700"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblCountFactories" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block">Industrial plants</span>
            </div>
        </asp:LinkButton>

        <!-- 3. Stocking Suppliers -->
        <asp:LinkButton ID="btnSegmentSuppliers" runat="server" OnClick="btnSegment_Click" CommandArgument="Supplier" CssClass="surface-card p-3.5 border-l-4 border-l-emerald-500 hover:shadow-md transition-all text-left no-underline group block">
            <div class="flex items-center justify-between text-slate-500">
                <span class="text-[10px] font-mono uppercase font-bold text-emerald-700">Suppliers</span>
                <i class="fa-solid fa-warehouse text-xs text-emerald-500 group-hover:text-emerald-700"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblCountSuppliers" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block">Part stockists</span>
            </div>
        </asp:LinkButton>

        <!-- 4. Field Technicians / Repair Workers -->
        <asp:LinkButton ID="btnSegmentTechnicians" runat="server" OnClick="btnSegment_Click" CommandArgument="Technician" CssClass="surface-card p-3.5 border-l-4 border-l-cyan-500 hover:shadow-md transition-all text-left no-underline group block">
            <div class="flex items-center justify-between text-slate-500">
                <span class="text-[10px] font-mono uppercase font-bold text-cyan-700">Repair Workers</span>
                <i class="fa-solid fa-user-wrench text-xs text-cyan-500 group-hover:text-cyan-700"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblCountTechnicians" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block">Field technicians</span>
            </div>
        </asp:LinkButton>

        <!-- 5. System Administrators -->
        <asp:LinkButton ID="btnSegmentAdmins" runat="server" OnClick="btnSegment_Click" CommandArgument="Administrator" CssClass="surface-card p-3.5 border-l-4 border-l-blue-600 hover:shadow-md transition-all text-left no-underline group block">
            <div class="flex items-center justify-between text-slate-500">
                <span class="text-[10px] font-mono uppercase font-bold text-blue-700">Administrators</span>
                <i class="fa-solid fa-shield-halved text-xs text-blue-500 group-hover:text-blue-700"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblCountAdmins" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block">Console superadmins</span>
            </div>
        </asp:LinkButton>
    </div>

    <!-- Filter & Search Toolbar (Industrial High-Density Pattern) -->
    <div class="surface-card p-4 mb-6 admin-animate-enter admin-stagger-2">
        <div class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-center">
            <!-- Search Keyword Input -->
            <div class="sm:col-span-5 relative">
                <i class="fa-solid fa-magnifying-glass absolute left-3 top-3 text-slate-400 text-xs"></i>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by name, email, or telephone..." CssClass="form-input pl-8 text-xs py-2" />
            </div>

            <!-- Role Filter -->
            <div class="sm:col-span-3">
                <asp:DropDownList ID="ddlRoleFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2 font-semibold">
                    <asp:ListItem Value="" Text="All System Roles"></asp:ListItem>
                    <asp:ListItem Value="Administrator" Text="System Administrator (Role 1)"></asp:ListItem>
                    <asp:ListItem Value="Factory" Text="Factory Buyers (Role 2)"></asp:ListItem>
                    <asp:ListItem Value="Supplier" Text="Stocking Suppliers (Role 3)"></asp:ListItem>
                    <asp:ListItem Value="Technician" Text="Field Technicians / Repair Workers (Role 4)"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Status Filter -->
            <div class="sm:col-span-2">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2">
                    <asp:ListItem Value="" Text="All Account Statuses"></asp:ListItem>
                    <asp:ListItem Value="Active" Text="Active Accounts"></asp:ListItem>
                    <asp:ListItem Value="Inactive" Text="Deactivated Accounts"></asp:ListItem>
                    <asp:ListItem Value="Verified" Text="Verified Credentials"></asp:ListItem>
                    <asp:ListItem Value="Pending" Text="Unverified / Pending"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Search Action Buttons -->
            <div class="sm:col-span-2 flex items-center gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="btnSearch_Click" CssClass="btn-secondary flex-1 text-xs py-2 cursor-pointer" />
                <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-2.5 text-slate-500" ToolTip="Reset Search Filters">
                    <i class="fa-solid fa-rotate-left"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- Data Grid Container (Card Enclosed, Crisp High Density) -->
    <div class="table-container shadow-xs">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-users-gear text-[#1769E0]"></i> Platform Account Roster
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total Matching: <asp:Label ID="lblUsersCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label> accounts
            </span>
        </div>

        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="UserId,FullName,Email,PhoneNumber,RoleId,RoleName,IsActive,IsVerified" 
            OnRowCommand="gvUsers_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No registered user accounts match the selected criteria.">
            <Columns>
                <asp:BoundField DataField="UserId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                
                <asp:TemplateField HeaderText="Full Name / Entity">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("FullName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("PhoneNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("PhoneNumber").ToString()) ? Eval("PhoneNumber") : "No phone registered" %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Email" HeaderText="Email Address" ItemStyle-CssClass="font-mono text-xs text-[#1E293B]" />

                <asp:TemplateField HeaderText="Assigned Role">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono font-bold">
                            <%# Eval("RoleName") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Account Status">
                    <ItemTemplate>
                        <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-emergency text-[10px]" %>'>
                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "w-1.5 h-1.5 rounded-full bg-emerald-500" : "w-1.5 h-1.5 rounded-full bg-rose-500" %>'></span>
                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Deactivated" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Verification">
                    <ItemTemplate>
                        <span class='<%# Convert.ToBoolean(Eval("IsVerified")) ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            <%# Convert.ToBoolean(Eval("IsVerified")) ? "Verified" : "Pending" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CreatedAt" HeaderText="Date Joined" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" />

                <asp:TemplateField HeaderText="Governance Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-1.5">
                            <!-- Edit Button -->
                            <asp:LinkButton ID="btnEdit" runat="server" 
                                CommandName="EditUser" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                ToolTip="Edit Account Details">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </asp:LinkButton>

                            <!-- Toggle Status Button -->
                            <asp:LinkButton ID="btnToggle" runat="server" 
                                CommandName="ToggleActive" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "px-2 py-1 text-[11px] font-semibold rounded bg-amber-50 hover:bg-amber-100 text-amber-800 border border-amber-300" : "px-2 py-1 text-[11px] font-semibold rounded bg-emerald-50 hover:bg-emerald-100 text-emerald-800 border border-emerald-300" %>' 
                                ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate Account" : "Activate Account" %>'>
                                <i class='<%# Convert.ToBoolean(Eval("IsActive")) ? "fa-solid fa-ban" : "fa-solid fa-check" %>'></i>
                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>
                            </asp:LinkButton>

                            <!-- Delete Button -->
                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CommandName="DeleteUser" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                OnClientClick="return confirm('WARNING: Are you sure you want to permanently delete this user account? All associated role records and dependencies will be affected.');" 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                ToolTip="Permanently Delete Account">
                                <i class="fa-solid fa-trash-can"></i>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- MODAL 1: REGISTER NEW USER -->
    <asp:Panel ID="pnlAddModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-lg p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Register New Platform User</h3>
                </div>
                <asp:LinkButton ID="btnCloseAddModal" runat="server" OnClick="btnCloseAddModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3">
                <div>
                    <label class="form-label text-xs">Full Name / Entity Name <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtAddFullName" runat="server" CssClass="form-input text-xs py-2" placeholder="e.g. Ramesh Patel or Reliance Petrochem Ltd." />
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Email Address <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddEmail" runat="server" TextMode="Email" CssClass="form-input text-xs py-2 font-mono" placeholder="user@domain.com" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Phone Number</label>
                        <asp:TextBox ID="txtAddPhone" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="+91 98765 43210" />
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Initial Password <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddPassword" runat="server" TextMode="Password" CssClass="form-input text-xs py-2 font-mono" placeholder="Minimum 6 characters" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Assigned Role <span class="text-rose-500">*</span></label>
                        <asp:DropDownList ID="ddlAddRole" runat="server" CssClass="form-input text-xs py-2">
                            <asp:ListItem Value="1" Text="1 - Administrator"></asp:ListItem>
                            <asp:ListItem Value="2" Text="2 - Factory Buyer"></asp:ListItem>
                            <asp:ListItem Value="3" Text="3 - Spare-Part Supplier"></asp:ListItem>
                            <asp:ListItem Value="4" Text="4 - Field Technician"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="flex items-center gap-6 pt-1">
                    <label class="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
                        <asp:CheckBox ID="chkAddIsActive" runat="server" Checked="true" />
                        Account Active
                    </label>
                    <label class="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
                        <asp:CheckBox ID="chkAddIsVerified" runat="server" Checked="true" />
                        Identity Verified
                    </label>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" OnClick="btnCloseAddModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitAddUser" runat="server" Text="Save User Record" OnClick="btnSubmitAddUser_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>

    <!-- MODAL 2: EDIT USER RECORD -->
    <asp:Panel ID="pnlEditModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-lg p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <asp:HiddenField ID="hdnEditUserId" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-user-pen"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Edit User Account</h3>
                </div>
                <asp:LinkButton ID="btnCloseEditModal" runat="server" OnClick="btnCloseEditModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3">
                <div>
                    <label class="form-label text-xs">Full Name / Entity Name <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtEditFullName" runat="server" CssClass="form-input text-xs py-2" />
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Email Address <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtEditEmail" runat="server" TextMode="Email" CssClass="form-input text-xs py-2 font-mono" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Phone Number</label>
                        <asp:TextBox ID="txtEditPhone" runat="server" CssClass="form-input text-xs py-2 font-mono" />
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Role Assignment <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-input text-xs py-2">
                        <asp:ListItem Value="1" Text="1 - Administrator"></asp:ListItem>
                        <asp:ListItem Value="2" Text="2 - Factory Buyer"></asp:ListItem>
                        <asp:ListItem Value="3" Text="3 - Spare-Part Supplier"></asp:ListItem>
                        <asp:ListItem Value="4" Text="4 - Field Technician"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="flex items-center gap-6 pt-1">
                    <label class="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
                        <asp:CheckBox ID="chkEditIsActive" runat="server" />
                        Account Active
                    </label>
                    <label class="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
                        <asp:CheckBox ID="chkEditIsVerified" runat="server" />
                        Identity Verified
                    </label>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCloseEditModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitEditUser" runat="server" Text="Update Account" OnClick="btnSubmitEditUser_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
