<%@ Page Title="Administrator Governance Dashboard" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header & Title Bar -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">COMMAND &amp; CONTROL TELEMETRY</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Platform Executive Overview</h1>
            <p class="text-xs text-[#64748B] m-0">Real-time governance telemetry, industrial emergency oversight, and ecosystem health metrics.</p>
        </div>
        <div class="flex items-center gap-2">
            <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="btn-primary text-xs py-2 px-3">
                <i class="fa-solid fa-user-plus mr-1.5"></i> Register User
            </a>
            <a href="~/Admin/SpareParts/ManageParts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3">
                <i class="fa-solid fa-plus mr-1.5"></i> New Part
            </a>
        </div>
    </div>

    <!-- Alert / Feedback Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded bg-rose-50 border border-rose-200 text-xs text-rose-900 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-triangle-exclamation text-rose-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-rose-600 hover:text-rose-800">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Executive KPI Grid (8 Cards, High Density 4x2) -->
    <div class="admin-kpi-grid admin-animate-enter admin-stagger-1">
        <!-- 1. Registered Users -->
        <div class="admin-kpi-card kpi-blue">
            <div class="admin-kpi-label">
                Total Users
                <div class="w-6 h-6 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-users"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblTotalUsers" runat="server">0</div>
            <div class="admin-kpi-sub">
                <i class="fa-solid fa-circle text-[8px] text-emerald-500"></i> Active ecosystem accounts
            </div>
        </div>

        <!-- 2. Verified Suppliers -->
        <div class="admin-kpi-card kpi-emerald">
            <div class="admin-kpi-label">
                Verified Suppliers
                <div class="w-6 h-6 rounded bg-emerald-50 text-[#059669] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-warehouse"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#059669]" id="lblVerifiedSuppliers" runat="server">0</div>
            <div class="admin-kpi-sub">GSTIN vetted vendors</div>
        </div>

        <!-- 3. Industrial Plants (Factories) -->
        <div class="admin-kpi-card kpi-amber">
            <div class="admin-kpi-label">
                Active Plants
                <div class="w-6 h-6 rounded bg-amber-50 text-[#D97706] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-industry"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblActiveFactories" runat="server">0</div>
            <div class="admin-kpi-sub">Procurement buyer units</div>
        </div>

        <!-- 4. Certified Technicians -->
        <div class="admin-kpi-card" style="border-left-color: #0891B2;">
            <div class="admin-kpi-label">
                Field Techs
                <div class="w-6 h-6 rounded bg-cyan-50 text-[#0891B2] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-user-wrench"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblActiveTechnicians" runat="server">0</div>
            <div class="admin-kpi-sub">Available service engineers</div>
        </div>

        <!-- 5. Active Emergency SOS -->
        <div class="admin-kpi-card kpi-rose">
            <div class="admin-kpi-label" style="color: #C2410C;">
                Emergency SOS
                <div class="w-6 h-6 rounded bg-orange-50 text-[#EA580C] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#EA580C]" id="lblActiveEmergency" runat="server">0</div>
            <div class="admin-kpi-sub text-[#EA580C]">Open machine breakdowns</div>
        </div>

        <!-- 6. Open RFQs -->
        <div class="admin-kpi-card kpi-purple">
            <div class="admin-kpi-label">
                Pending RFQs
                <div class="w-6 h-6 rounded bg-indigo-50 text-[#6366F1] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblOpenRfqs" runat="server">0</div>
            <div class="admin-kpi-sub">Quotations awaiting bids</div>
        </div>

        <!-- 7. Total Orders -->
        <div class="admin-kpi-card" style="border-left-color: #475569;">
            <div class="admin-kpi-label">
                Total Orders
                <div class="w-6 h-6 rounded bg-slate-100 text-[#475569] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-cart-flatbed"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblTotalOrders" runat="server">0</div>
            <div class="admin-kpi-sub">Purchase consignments</div>
        </div>

        <!-- 8. Platform GMV -->
        <div class="admin-kpi-card kpi-emerald">
            <div class="admin-kpi-label">
                Platform GMV
                <div class="w-6 h-6 rounded bg-emerald-50 text-[#10B981] flex items-center justify-center text-xs">
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
            </div>
            <div class="admin-kpi-val" id="lblTotalGmv" runat="server">₹0</div>
            <div class="admin-kpi-sub text-emerald-600 font-mono">Total transaction volume</div>
        </div>
    </div>

    <!-- Main Split Section: Live Emergency Alerts & System Roster -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 mb-6 admin-animate-enter admin-stagger-2 items-start">
        <!-- Live Emergency SOS Monitor & System Registrations (High Priority Left Column - Expanded to 8 Cols) -->
        <div class="lg:col-span-7 xl:col-span-8 space-y-6 min-w-0">
            <!-- Emergency SOS Table -->
            <div class="table-container shadow-xs">
                <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                    <div class="flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full bg-[#EA580C] animate-ping"></span>
                        <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                            Active Emergency Breakdown Tickets
                        </h2>
                    </div>
                    <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 font-mono">
                        View SOS Console →
                    </a>
                </div>
                
                <div class="overflow-x-auto w-full">
                    <asp:GridView ID="gvEmergencies" runat="server" AutoGenerateColumns="false" CssClass="table-custom min-w-[620px]" GridLines="None" EmptyDataText="No active emergency breakdown alerts at this time. All factory lines operational.">
                        <Columns>
                            <asp:BoundField DataField="EmergencyRequestId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                            <asp:BoundField DataField="FactoryCompany" HeaderText="Factory" ItemStyle-CssClass="font-semibold text-xs whitespace-nowrap" />
                            <asp:BoundField DataField="MachineName" HeaderText="Machine / Unit" ItemStyle-CssClass="text-xs font-mono whitespace-nowrap" />
                            <asp:TemplateField HeaderText="Priority">
                                <ItemTemplate>
                                    <span class='<%# Eval("PriorityLevel").ToString() == "Critical" ? "status-pill status-pill-emergency font-bold text-[10px]" : "status-pill status-pill-stock text-[10px]" %>'>
                                        <%# Eval("PriorityLevel") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="LocationCity" HeaderText="City" ItemStyle-CssClass="text-xs whitespace-nowrap" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="status-pill status-pill-pending text-[10px] font-mono">
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Platform Registered User Roster Table -->
            <div class="table-container shadow-xs">
                <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                    <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                        <i class="fa-solid fa-users text-[#1769E0]"></i> Recent Platform Registrations
                    </h2>
                    <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline font-mono">
                        Manage All Users →
                    </a>
                </div>
                
                <div class="overflow-x-auto w-full">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="table-custom min-w-[700px]" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="UserId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                            <asp:BoundField DataField="FullName" HeaderText="Full Name / Entity" ItemStyle-CssClass="font-bold text-xs text-[#0F172A] whitespace-nowrap" />
                            <asp:BoundField DataField="Email" HeaderText="Email Address" ItemStyle-CssClass="font-mono text-xs text-[#64748B] whitespace-nowrap" />
                            <asp:TemplateField HeaderText="Role" HeaderStyle-CssClass="w-28">
                                <ItemTemplate>
                                    <span class="spec-tag spec-tag-blue text-[10px] font-mono whitespace-nowrap">
                                        <%# Eval("RoleName") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Verification" HeaderStyle-CssClass="w-24">
                                <ItemTemplate>
                                    <span class='<%# Convert.ToBoolean(Eval("IsVerified")) ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-demo text-[10px]" %>'>
                                        <%# Convert.ToBoolean(Eval("IsVerified")) ? "Verified" : "Pending" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:dd MMM yyyy}" HeaderStyle-CssClass="w-28 text-right font-mono" ItemStyle-CssClass="font-mono text-xs text-[#64748B] text-right whitespace-nowrap pr-4" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- Right Side: Quick Governance Actions & ADO.NET Architecture Diagnostics (Compact 4 Cols) -->
        <div class="lg:col-span-5 xl:col-span-4 space-y-6 min-w-0">
            <!-- Governance Quick Launch Grid -->
            <div class="surface-card p-5 space-y-4">
                <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                    <h3 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                        <i class="fa-solid fa-bolt text-[#D97706]"></i> Quick Governance Actions
                    </h3>
                    <span class="text-[10px] font-mono text-[#64748B]">DIRECT ACCESS</span>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    <a href="~/Admin/Suppliers/Verification.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-emerald-400">
                        <i class="fa-solid fa-user-check text-[#059669] mr-2"></i> Verify Suppliers
                    </a>
                    <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-blue-400">
                        <i class="fa-solid fa-users-gear text-[#1769E0] mr-2"></i> Manage Users
                    </a>
                    <a href="~/Admin/Factories/ManageFactories.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-amber-400">
                        <i class="fa-solid fa-industry text-[#D97706] mr-2"></i> Factory Plants
                    </a>
                    <a href="~/Admin/Technicians/ManageTechnicians.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-cyan-400">
                        <i class="fa-solid fa-user-wrench text-[#0891B2] mr-2"></i> Tech Roster
                    </a>
                    <a href="~/Admin/Categories/ManageCategories.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-purple-400">
                        <i class="fa-solid fa-diagram-project text-[#7C3AED] mr-2"></i> Categories
                    </a>
                    <a href="~/Admin/SpareParts/ManageParts.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-orange-400">
                        <i class="fa-solid fa-boxes-stacked text-[#EA580C] mr-2"></i> Master Catalog
                    </a>
                    <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-rose-400">
                        <i class="fa-solid fa-truck-fast text-[#E11D48] mr-2"></i> Orders &amp; SOS
                    </a>
                    <a href="~/Admin/Audit/AuditLogs.aspx" runat="server" class="btn-secondary justify-start text-xs py-2 px-3 hover:border-slate-500">
                        <i class="fa-solid fa-clipboard-check text-slate-700 mr-2"></i> Audit Trail
                    </a>
                </div>
            </div>

            <!-- Platform Architecture & Runtime Diagnostics Card -->
            <div class="surface-card p-5 bg-[#0F172A] text-white border-slate-700 space-y-4">
                <div class="flex items-center justify-between border-b border-slate-800 pb-3">
                    <div class="flex items-center gap-2">
                        <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
                        <span class="text-xs font-bold font-mono text-emerald-400 tracking-wider">LOCALDB RUNTIME TELEMETRY</span>
                    </div>
                    <span class="spec-tag spec-tag-blue text-[9px]">3-TIER ADO.NET</span>
                </div>
                
                <p class="text-xs text-slate-300 m-0 leading-relaxed">
                    Industrial spare-part procurement kernel operating on SQL Server LocalDB via professor-structured BaseLogic method-based data access layer.
                </p>

                <div class="text-[11px] text-slate-300 font-mono space-y-1.5 bg-[#0B1120] p-3.5 rounded border border-slate-800">
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Framework:</span>
                        <span class="text-white font-semibold">.NET Framework 4.8</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Database Engine:</span>
                        <span class="text-emerald-400 font-semibold">(localdb)\MSSQLLocalDB</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Target Catalog:</span>
                        <span class="text-white">IndustrialSparePartDB</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Security Gate:</span>
                        <span class="text-cyan-400">BasePage Session RBAC</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Total System Tables:</span>
                        <span class="text-amber-400 font-semibold">19 Normal Forms</span>
                    </div>
                </div>

                <div class="pt-1 flex items-center justify-between text-[11px] text-slate-400">
                    <span>Active Session: <strong class="text-white" id="lblSessionUser" runat="server">Superadmin</strong></span>
                    <a href="~/Admin/Audit/AuditLogs.aspx" runat="server" class="text-[#38BDF8] hover:underline font-mono">Inspect Logs →</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
