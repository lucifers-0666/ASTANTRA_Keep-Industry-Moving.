<%@ Page Title="Roles & Permissions RBAC Architecture" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Roles.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.RBAC.Roles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">IDENTITY &amp; ACCESS CONTROL</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Role-Based Access Control (RBAC) Architecture</h1>
            <p class="text-xs text-[#64748B] m-0">Centralized privilege definitions, scope boundaries, and role assignments enforced by BasePage authorization gates.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-blue-50 text-blue-800 border border-blue-200">
                <i class="fa-solid fa-shield-halved text-blue-600"></i> SERVER-SIDE ENFORCEMENT
            </span>
        </div>
    </div>

    <!-- Live Roles Table -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-1">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-users-gear text-[#1769E0]"></i> Registered Security Roles &amp; Account Counts
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Active Roles: <asp:Label ID="lblRolesCount" runat="server" Text="4" CssClass="text-[#0F172A]"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" 
            DataKeyNames="RoleId,RoleName" OnRowCommand="gvRoles_RowCommand"
            EmptyDataText="No role definitions found.">
            <Columns>
                <asp:BoundField DataField="RoleId" HeaderText="Role #" HeaderStyle-CssClass="w-16 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-[#1769E0]" />
                
                <asp:TemplateField HeaderText="Role Identifier &amp; Scope">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("RoleName") %></span>
                            <span class="text-[11px] text-[#64748B]"><%# Eval("Description") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Total Accounts">
                    <ItemTemplate>
                        <span class="font-mono text-xs font-bold text-[#0F172A]">
                            <%# Eval("UserCount") %> Accounts
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Active Status">
                    <ItemTemplate>
                        <span class="status-pill status-pill-verified text-[10px] font-mono">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                            <%# Eval("ActiveCount") %> Active
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Enforcement Gate">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            BasePage.RequiredRole = <%# Eval("RoleId") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action" HeaderStyle-CssClass="text-right" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnInspectRole" runat="server" CommandName="InspectRole" CommandArgument="<%# Container.DataItemIndex %>" CssClass="btn-secondary text-xs py-1 px-2.5">
                            <i class="fa-solid fa-list-check mr-1"></i> Permissions
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Alert / Feedback Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded bg-emerald-50 border border-emerald-200 text-xs text-emerald-900 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-emerald-600 hover:text-emerald-800">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Granular Permission Assignment Panel -->
    <div class="surface-card p-5 shadow-xs mb-8 border border-[#CBD5E1] admin-animate-enter admin-stagger-2">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4 pb-3 border-b border-[#E2E8F0]">
            <div>
                <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase">GRANULAR RBAC PERMISSION CLEARANCES</span>
                <h3 class="text-sm font-bold text-[#0F172A] m-0 flex items-center gap-2">
                    <i class="fa-solid fa-key text-[#1769E0]"></i> Managing Clearances for: <span id="lblSelectedRoleTitle" runat="server" class="text-[#1769E0]">Administrator (Role #1)</span>
                </h3>
            </div>
            <asp:HiddenField ID="hdnSelectedRoleId" runat="server" Value="1" />
            <div class="text-xs font-mono text-[#64748B]">
                Assigned: <asp:Label ID="lblGrantedPermCount" runat="server" Text="0" CssClass="font-bold text-[#0F172A]"></asp:Label> / <asp:Label ID="lblTotalPermCount" runat="server" Text="0"></asp:Label> Clearances
            </div>
        </div>

        <asp:GridView ID="gvPermissions" runat="server" AutoGenerateColumns="False"
            CssClass="table-custom" GridLines="None"
            DataKeyNames="PermissionId,PermissionKey,DisplayName,IsGranted" OnRowCommand="gvPermissions_RowCommand"
            EmptyDataText="No permissions configured in the platform catalog.">
            <Columns>
                <asp:BoundField DataField="Module" HeaderText="Module Scope" HeaderStyle-CssClass="w-36 font-mono text-[11px]" ItemStyle-CssClass="font-mono text-xs font-bold text-[#334155]" />
                
                <asp:TemplateField HeaderText="Permission Clearance &amp; System Key">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("DisplayName") %></span>
                            <span class="text-[11px] font-mono text-[#64748B]"><%# Eval("PermissionKey") %></span>
                            <span class="text-[10px] text-[#94A3B8]"><%# Eval("Description") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Clearance State" HeaderStyle-CssClass="w-28 text-center" ItemStyle-CssClass="text-center">
                    <ItemTemplate>
                        <%# Convert.ToInt32(Eval("IsGranted")) == 1 
                            ? "<span class='status-pill status-pill-verified text-[10px] font-mono'><i class='fa-solid fa-check mr-1'></i> GRANTED</span>" 
                            : "<span class='status-pill text-[10px] font-mono bg-slate-100 text-slate-500 border border-slate-200'><i class='fa-solid fa-xmark mr-1'></i> REVOKED</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Authorization Toggle" HeaderStyle-CssClass="w-32 text-right" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnTogglePerm" runat="server" CommandName="TogglePerm" CommandArgument="<%# Container.DataItemIndex %>"
                            CssClass='<%# Convert.ToInt32(Eval("IsGranted")) == 1 ? "btn-secondary text-xs py-1 px-2.5 text-rose-700 hover:bg-rose-50" : "btn-primary text-xs py-1 px-2.5" %>'>
                            <%# Convert.ToInt32(Eval("IsGranted")) == 1 ? "<i class='fa-solid fa-lock mr-1'></i> Revoke" : "<i class='fa-solid fa-key mr-1'></i> Grant" %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Privilege Clearance Matrix -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 admin-animate-enter admin-stagger-2">
        <!-- Role 1: Administrator -->
        <div class="surface-card p-5 border-l-4 border-l-[#2563EB]">
            <div class="flex items-center justify-between mb-3 border-b border-[#E2E8F0] pb-2">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <h3 class="text-xs font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Role 1: Platform Administrator</h3>
                        <span class="text-[10px] font-mono text-[#64748B]">SUPERUSER GOVERNANCE PRIVILEGES</span>
                    </div>
                </div>
                <span class="status-pill status-pill-verified text-[10px]">ALL PRIVILEGES</span>
            </div>
            <ul class="text-xs text-[#334155] space-y-2 m-0 pl-4 list-disc">
                <li>Complete CRUD authority across all 19 relational database tables.</li>
                <li>Provision, modify, or deactivate user accounts for Factories, Suppliers, and Technicians.</li>
                <li>Inspect and verify GSTIN and commercial trade licenses for Stocking Suppliers.</li>
                <li>Triage emergency machinery breakdown alerts and dispatch field engineers.</li>
                <li>View tamper-evident immutable security audit trails with IP and timestamp telemetry.</li>
            </ul>
        </div>

        <!-- Role 2: Factory Buyer -->
        <div class="surface-card p-5 border-l-4 border-l-[#D97706]">
            <div class="flex items-center justify-between mb-3 border-b border-[#E2E8F0] pb-2">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-amber-50 text-[#D97706] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-industry"></i>
                    </div>
                    <div>
                        <h3 class="text-xs font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Role 2: Factory Plant Buyer</h3>
                        <span class="text-[10px] font-mono text-[#64748B]">PROCUREMENT &amp; BREAKDOWN BROADCAST</span>
                    </div>
                </div>
                <span class="spec-tag spec-tag-blue text-[10px]">TENANT ISOLATED</span>
            </div>
            <ul class="text-xs text-[#334155] space-y-2 m-0 pl-4 list-disc">
                <li>Create and broadcast Request for Quotations (RFQs) for industrial replacement parts.</li>
                <li>Compare competing supplier bids based on lead time, warranty, and unit pricing.</li>
                <li>Issue legally binding commercial purchase orders to verified stocking suppliers.</li>
                <li>Trigger emergency priority breakdown alerts with machine serial data for rapid dispatch.</li>
            </ul>
        </div>

        <!-- Role 3: Spare-Part Supplier -->
        <div class="surface-card p-5 border-l-4 border-l-[#059669]">
            <div class="flex items-center justify-between mb-3 border-b border-[#E2E8F0] pb-2">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-emerald-50 text-[#059669] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-warehouse"></i>
                    </div>
                    <div>
                        <h3 class="text-xs font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Role 3: Stocking Spare-Part Supplier</h3>
                        <span class="text-[10px] font-mono text-[#64748B]">INVENTORY &amp; BIDDING PRIVILEGES</span>
                    </div>
                </div>
                <span class="status-pill status-pill-pending text-[10px]">KYC REQUIRED</span>
            </div>
            <ul class="text-xs text-[#334155] space-y-2 m-0 pl-4 list-disc">
                <li>List certified industrial inventory mapped against OEM component part numbers.</li>
                <li>Review open plant RFQs and submit binding commercial quotation bids.</li>
                <li>Confirm order receipt, generate consignment waybills, and update shipping progress.</li>
                <li>Access is gated by Administrator GSTIN verification before bidding is authorized.</li>
            </ul>
        </div>

        <!-- Role 4: Service Technician -->
        <div class="surface-card p-5 border-l-4 border-l-[#0891B2]">
            <div class="flex items-center justify-between mb-3 border-b border-[#E2E8F0] pb-2">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-cyan-50 text-[#0891B2] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-user-wrench"></i>
                    </div>
                    <div>
                        <h3 class="text-xs font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Role 4: Field Service Technician</h3>
                        <span class="text-[10px] font-mono text-[#64748B]">ON-SITE DISPATCH &amp; REPAIR</span>
                    </div>
                </div>
                <span class="spec-tag spec-tag-blue text-[10px]">DUTY TOGGLE</span>
            </div>
            <ul class="text-xs text-[#334155] space-y-2 m-0 pl-4 list-disc">
                <li>Toggle duty status between Available (On-Duty) and Engaged (Off-Duty).</li>
                <li>Receive emergency breakdown assignments and view machine fault symptoms.</li>
                <li>Log work completion hours, technical diagnostic reports, and parts consumed.</li>
                <li>Hourly billing rate and technical skills managed under administrator oversight.</li>
            </ul>
        </div>
    </div>
</asp:Content>

