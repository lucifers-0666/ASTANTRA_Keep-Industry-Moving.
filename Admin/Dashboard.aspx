<%@ Page Title="Administrator Governance & Analytics Dashboard" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .analytics-grid-row-1 {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            width: 100%;
        }
        @media (min-width: 1024px) {
            .analytics-grid-row-1 {
                grid-template-columns: 2fr 1fr;
            }
        }
        .analytics-grid-row-2 {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            width: 100%;
        }
        @media (min-width: 640px) {
            .analytics-grid-row-2 {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (min-width: 1024px) {
            .analytics-grid-row-2 {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        .chart-card {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            padding: 1.25rem;
            position: relative;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }
        .chart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #F1F5F9;
        }
        .chart-title {
            font-size: 0.8125rem;
            font-weight: 700;
            color: #0F172A;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-family: 'IBM Plex Mono', monospace;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .chart-subtitle {
            font-size: 0.75rem;
            color: #64748B;
            font-family: 'IBM Plex Sans', sans-serif;
            margin-top: 0.125rem;
        }
        .chart-canvas-container {
            position: relative;
            flex: 1;
            height: 280px;
            min-height: 280px;
            width: 100%;
        }
        .timeframe-pill {
            font-size: 0.6875rem;
            font-weight: 600;
            font-family: 'IBM Plex Mono', monospace;
            padding: 0.375rem 0.75rem;
            border-radius: 4px;
            transition: all 0.15s ease-in-out;
            cursor: pointer;
            border: 1px solid #CBD5E1;
            background: #FFFFFF;
            color: #475569;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }
        .timeframe-pill:hover {
            background: #F8FAFC;
            color: #0F172A;
            border-color: #94A3B8;
        }
        .timeframe-pill.active {
            background: #0F172A;
            color: #FFFFFF;
            border-color: #0F172A;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.12);
        }
        .tnum {
            font-variant-numeric: tabular-nums;
        }
        .empty-chart-notice {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.94);
            border-radius: 6px;
            z-index: 10;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hidden field delivering safely serialized JSON chart telemetry -->
    <asp:HiddenField ID="hdnChartData" runat="server" Value="{}" />

    <!-- Top Command & Filter Bar -->
    <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <div class="flex items-center gap-2">
                <span class="text-[10px] font-mono uppercase font-bold text-[#64748B] tracking-wider px-2 py-0.5 rounded bg-slate-200/70 border border-slate-300">
                    EXECUTIVE COMMAND &amp; TELEMETRY
                </span>
                <span class="text-xs text-slate-500 font-mono">
                    <i class="fa-solid fa-clock text-slate-400 mr-1"></i>Last Refreshed: <strong id="lblLastRefreshed" runat="server" class="text-slate-700">Just now</strong>
                </span>
            </div>
            <h1 class="text-xl sm:text-2xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-1 m-0">
                Platform Governance &amp; Analytics Dashboard
            </h1>
            <p class="text-xs text-[#64748B] m-0 mt-0.5">
                Real-time transaction flow, SLA alerts, RFQ conversion funnel, and multi-tenant ecosystem intelligence.
            </p>
        </div>

        <!-- Filter & Action Controls -->
        <div class="flex flex-wrap items-center gap-2">
            <!-- Timeframe Filter Buttons -->
            <div class="inline-flex rounded-md shadow-xs bg-slate-100 p-0.5 border border-slate-200" role="group" aria-label="Timeframe selector">
                <asp:LinkButton ID="btnTimeframe7" runat="server" OnClick="btnTimeframe_Click" CommandArgument="7" CssClass="timeframe-pill" ToolTip="Filter last 7 days">
                    <span>7 Days</span>
                </asp:LinkButton>
                <asp:LinkButton ID="btnTimeframe30" runat="server" OnClick="btnTimeframe_Click" CommandArgument="30" CssClass="timeframe-pill" ToolTip="Filter last 30 days">
                    <span>30 Days</span>
                </asp:LinkButton>
                <asp:LinkButton ID="btnTimeframe90" runat="server" OnClick="btnTimeframe_Click" CommandArgument="90" CssClass="timeframe-pill" ToolTip="Filter last 90 days">
                    <span>90 Days</span>
                </asp:LinkButton>
                <asp:LinkButton ID="btnTimeframeAll" runat="server" OnClick="btnTimeframe_Click" CommandArgument="all" CssClass="timeframe-pill active" ToolTip="Show all-time records">
                    <span>All Time</span>
                </asp:LinkButton>
            </div>

            <!-- Refresh Button -->
            <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" CssClass="btn-secondary text-xs py-2 px-3 flex items-center gap-1.5" ToolTip="Force data refresh">
                <i class="fa-solid fa-arrows-rotate"></i>
                <span class="hidden sm:inline">Refresh</span>
            </asp:LinkButton>

            <!-- Direct Creation Actions -->
            <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="btn-primary text-xs py-2 px-3 flex items-center gap-1.5">
                <i class="fa-solid fa-user-plus"></i>
                <span>Register User</span>
            </a>
            <a href="~/Admin/SpareParts/ManageParts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 flex items-center gap-1.5">
                <i class="fa-solid fa-plus"></i>
                <span>New Part</span>
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

    <!-- SECTION 1: EXECUTIVE KPI TELEMETRY CARDS (10 Cards: High Density Responsive Grid) -->
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 mb-6 admin-animate-enter admin-stagger-1">
        <!-- 1. Gross Order Value (Non-Cancelled) -->
        <div class="admin-kpi-card" style="border-left-color: #10B981;">
            <div class="admin-kpi-label">
                Gross Order Value
                <div class="w-5 h-5 rounded bg-emerald-50 text-[#10B981] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-emerald-700 tnum" id="lblTotalGmv" runat="server">₹0</div>
            <div class="admin-kpi-sub">Total gross commitments</div>
        </div>

        <!-- 2. Realized Revenue (Delivered Orders) -->
        <div class="admin-kpi-card" style="border-left-color: #059669;">
            <div class="admin-kpi-label">
                Realized Revenue
                <div class="w-5 h-5 rounded bg-teal-50 text-[#059669] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-teal-800 tnum" id="lblRealizedRevenue" runat="server">₹0</div>
            <div class="admin-kpi-sub">Completed order turnover</div>
        </div>

        <!-- 3. Total Purchase Orders -->
        <div class="admin-kpi-card" style="border-left-color: #1769E0;">
            <div class="admin-kpi-label">
                Purchase Orders
                <div class="w-5 h-5 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-cart-flatbed"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#1769E0] tnum" id="lblTotalOrders" runat="server">0</div>
            <div class="admin-kpi-sub">Contracted consignments</div>
        </div>

        <!-- 4. Open Emergency SOS -->
        <div class="admin-kpi-card" style="border-left-color: #EA580C;">
            <div class="admin-kpi-label" style="color: #C2410C;">
                Emergency SOS
                <div class="w-5 h-5 rounded bg-orange-50 text-[#EA580C] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#EA580C] tnum" id="lblActiveEmergency" runat="server">0</div>
            <div class="admin-kpi-sub text-orange-700">Active machine stoppages</div>
        </div>

        <!-- 5. Delayed Orders SLA -->
        <div class="admin-kpi-card" style="border-left-color: #DC2626;">
            <div class="admin-kpi-label" style="color: #991B1B;">
                Delayed Orders
                <div class="w-5 h-5 rounded bg-rose-50 text-[#DC2626] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-clock-rotate-left"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-rose-700 tnum" id="lblDelayedOrders" runat="server">0</div>
            <div class="admin-kpi-sub text-rose-600">&gt; 3 days in pending SLA</div>
        </div>

        <!-- 6. Total Users Roster -->
        <div class="admin-kpi-card" style="border-left-color: #475569;">
            <div class="admin-kpi-label">
                Active Users
                <div class="w-5 h-5 rounded bg-slate-100 text-[#475569] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-users"></i>
                </div>
            </div>
            <div class="admin-kpi-val tnum" id="lblTotalUsers" runat="server">0</div>
            <div class="admin-kpi-sub">Ecosystem identity accounts</div>
        </div>

        <!-- 7. Verified Stocking Suppliers -->
        <div class="admin-kpi-card" style="border-left-color: #0891B2;">
            <div class="admin-kpi-label">
                Verified Suppliers
                <div class="w-5 h-5 rounded bg-cyan-50 text-[#0891B2] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-warehouse"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#0891B2] tnum" id="lblVerifiedSuppliers" runat="server">0</div>
            <div class="admin-kpi-sub">GSTIN compliant vendors</div>
        </div>

        <!-- 8. Industrial Plants -->
        <div class="admin-kpi-card" style="border-left-color: #D97706;">
            <div class="admin-kpi-label">
                Active Plants
                <div class="w-5 h-5 rounded bg-amber-50 text-[#D97706] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-industry"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#D97706] tnum" id="lblActiveFactories" runat="server">0</div>
            <div class="admin-kpi-sub">Procurement buyer plants</div>
        </div>

        <!-- 9. Certified Technicians -->
        <div class="admin-kpi-card" style="border-left-color: #7C3AED;">
            <div class="admin-kpi-label">
                Field Engineers
                <div class="w-5 h-5 rounded bg-purple-50 text-[#7C3AED] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-user-wrench"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#7C3AED] tnum" id="lblActiveTechnicians" runat="server">0</div>
            <div class="admin-kpi-sub">Available for emergency dispatch</div>
        </div>

        <!-- 10. RFQ Conversion Rate -->
        <div class="admin-kpi-card" style="border-left-color: #4F46E5;">
            <div class="admin-kpi-label">
                RFQ Conversion
                <div class="w-5 h-5 rounded bg-indigo-50 text-[#4F46E5] flex items-center justify-center text-[10px]">
                    <i class="fa-solid fa-filter-circle-dollar"></i>
                </div>
            </div>
            <div class="admin-kpi-val text-[#4F46E5] tnum" id="lblRfqConversionRate" runat="server">0.0%</div>
            <div class="admin-kpi-sub">
                <span id="lblOpenRfqs" runat="server" class="font-bold">0</span> open RFQs awaiting
            </div>
        </div>
    </div>

    <!-- SECTION 2: CRITICAL OPERATIONAL ALERTS & TRIAGE BANNER (If Any Alerts Exist) -->
    <div class="mb-6 admin-animate-enter admin-stagger-2">
        <asp:Repeater ID="rptOperationalAlerts" runat="server">
            <HeaderTemplate>
                <div class="p-3 bg-amber-50/80 border border-amber-300 rounded-lg shadow-xs">
                    <div class="flex items-center gap-2 mb-2 px-1">
                        <span class="w-2 h-2 rounded-full bg-amber-600 animate-pulse"></span>
                        <h2 class="text-xs font-bold font-mono text-amber-900 uppercase tracking-wider m-0">
                            Operational Attention Required
                        </h2>
                    </div>
                    <div class="space-y-1.5">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="bg-white p-2.5 rounded border border-amber-200 flex flex-col sm:flex-row sm:items-center justify-between gap-2 text-xs">
                    <div class="flex items-start sm:items-center gap-2.5">
                        <span class="px-1.5 py-0.5 rounded font-mono text-[10px] font-bold uppercase shrink-0 
                            <%# Eval("AlertType").ToString() == "CRITICAL_SOS" ? "bg-rose-100 text-rose-800 border border-rose-300" : "bg-blue-100 text-blue-800 border border-blue-300" %>">
                            <%# Eval("AlertTitle") %>
                        </span>
                        <span class="font-medium text-slate-800"><%# Eval("AlertDescription") %></span>
                    </div>
                    <div class="flex items-center gap-3 shrink-0 ml-auto sm:ml-0">
                        <span class="text-[11px] text-slate-400 font-mono"><%# Eval("AlertTimestamp", "{0:dd MMM HH:mm}") %></span>
                        <a href='<%# ResolveUrl(Eval("NavigationUrl").ToString()) %>' class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 font-mono">
                            Resolve <i class="fa-solid fa-arrow-right text-[10px]"></i>
                        </a>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                    </div>
                </div>
            </FooterTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoAlerts" runat="server" Visible="false">
            <!-- Alert panel hidden when all operational queues are clear -->
        </asp:Panel>
    </div>

    <!-- SECTION 3: INTERACTIVE ANALYTICS VISUALIZATION SUITE -->
    <!-- Row 1: Procurement Dual-Axis Trend (2/3 width) & Order Fulfillment Status (1/3 width) -->
    <div class="analytics-grid-row-1 admin-animate-enter admin-stagger-2">
        <!-- Chart 1: Procurement & Transaction Activity Trend -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-chart-line text-[#1769E0]"></i>
                        Procurement &amp; Transaction Activity Trend
                    </div>
                    <div class="chart-subtitle">Order volume counts (bars) vs. Gross committed value in ₹ INR (line).</div>
                </div>
                <div class="text-[11px] font-mono text-slate-400">
                    Dual-Axis Metric
                </div>
            </div>
            <div class="chart-canvas-container" id="containerActivityChart">
                <canvas id="canvasProcurementActivity" aria-label="Procurement activity trend chart" role="img"></canvas>
                <div id="emptyNoticeActivity" class="empty-chart-notice" style="display:none;">
                    <i class="fa-solid fa-chart-simple text-slate-300 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-600 m-0">No transaction records in this timeframe</p>
                    <span class="text-[11px] text-slate-400">Try selecting '90 Days' or 'All Time'</span>
                </div>
            </div>
            <!-- Accessible table fallback -->
            <details class="mt-3 pt-2 border-t border-slate-100 text-[11px] text-slate-500">
                <summary class="cursor-pointer hover:text-slate-800 font-mono text-[10px] uppercase">
                    View Tabular Telemetry Fallback
                </summary>
                <div class="overflow-x-auto mt-2">
                    <table class="w-full text-left font-mono text-[10px] border border-slate-200" id="fallbackTableActivity">
                        <thead class="bg-slate-50 border-b border-slate-200">
                            <tr>
                                <th class="p-1.5">Date Period</th>
                                <th class="p-1.5 text-right">Orders</th>
                                <th class="p-1.5 text-right">Gross Value (₹)</th>
                                <th class="p-1.5 text-right">Completed Revenue (₹)</th>
                            </tr>
                        </thead>
                        <tbody id="fallbackBodyActivity"></tbody>
                    </table>
                </div>
            </details>
        </div>

        <!-- Chart 2: Order Fulfillment Pipeline Status -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-boxes-packing text-emerald-600"></i>
                        Order Status Breakdown
                    </div>
                    <div class="chart-subtitle">Distribution across fulfillment stages.</div>
                </div>
            </div>
            <div class="chart-canvas-container" id="containerStatusChart">
                <canvas id="canvasOrderStatus" aria-label="Order status breakdown chart" role="img"></canvas>
                <div id="emptyNoticeStatus" class="empty-chart-notice" style="display:none;">
                    <i class="fa-solid fa-box-open text-slate-300 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-600 m-0">No order stage data found</p>
                </div>
            </div>
            <div class="mt-3 pt-2 border-t border-slate-100 text-[11px] flex justify-between items-center text-slate-500 font-mono">
                <span>Direct Oversight:</span>
                <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="font-bold text-[#1769E0] hover:underline">
                    View Orders Console →
                </a>
            </div>
        </div>
    </div>

    <!-- Row 2: Ecosystem Identity Share, Emergency Priority Triage & RFQ Pipeline Funnel (3 equal cols) -->
    <div class="analytics-grid-row-2 admin-animate-enter admin-stagger-2">
        <!-- Chart 3: Ecosystem Identity Distribution -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-id-card-clip text-purple-600"></i>
                        Ecosystem Role Share
                    </div>
                    <div class="chart-subtitle">Active accounts grouped by system role.</div>
                </div>
            </div>
            <div class="chart-canvas-container" id="containerRoleChart">
                <canvas id="canvasRoleDistribution" aria-label="User role distribution chart" role="img"></canvas>
            </div>
            <div class="mt-3 pt-2 border-t border-slate-100 text-[11px] flex justify-between items-center text-slate-500 font-mono">
                <span>Roster Control:</span>
                <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="font-bold text-[#1769E0] hover:underline">
                    Manage Accounts →
                </a>
            </div>
        </div>

        <!-- Chart 4: Emergency Severity Triage -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title text-orange-700">
                        <i class="fa-solid fa-triangle-exclamation text-[#EA580C]"></i>
                        Emergency Incident Priority
                    </div>
                    <div class="chart-subtitle">Breakdown tickets categorized by severity.</div>
                </div>
            </div>
            <div class="chart-canvas-container" id="containerEmergencyChart">
                <canvas id="canvasEmergencyPriority" aria-label="Emergency priority breakdown chart" role="img"></canvas>
                <div id="emptyNoticeEmergency" class="empty-chart-notice" style="display:none;">
                    <i class="fa-solid fa-circle-check text-emerald-400 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-700 m-0">Zero active breakdowns</p>
                    <span class="text-[11px] text-slate-400">All industrial plants operational</span>
                </div>
            </div>
            <div class="mt-3 pt-2 border-t border-slate-100 text-[11px] flex justify-between items-center text-slate-500 font-mono">
                <span>Emergency Desk:</span>
                <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="font-bold text-orange-600 hover:underline">
                    SOS Triage Console →
                </a>
            </div>
        </div>

        <!-- Chart 5: RFQ Conversion Pipeline Funnel -->
        <div class="chart-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-filter-circle-dollar text-indigo-600"></i>
                        RFQ Conversion Pipeline
                    </div>
                    <div class="chart-subtitle">Commercial requisitions to purchase orders.</div>
                </div>
            </div>
            <div class="chart-canvas-container" id="containerFunnelChart">
                <canvas id="canvasRfqFunnel" aria-label="RFQ conversion funnel chart" role="img"></canvas>
            </div>
            <div class="mt-3 pt-2 border-t border-slate-100 text-[11px] flex justify-between items-center text-slate-500 font-mono">
                <span>Quotation Monitor:</span>
                <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="font-bold text-indigo-600 hover:underline">
                    Review Quotations →
                </a>
            </div>
        </div>
    </div>

    <!-- SECTION 4 & 5: ACTIVE SOS BREAKDOWNS & RECENT REGISTRATIONS (Split 7 / 5 Grid) -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 mb-6 admin-animate-enter admin-stagger-3 items-start">
        <!-- Active Emergency SOS Monitor (Span 7 Cols) -->
        <div class="lg:col-span-7 space-y-6">
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

                <div class="overflow-x-auto">
                    <asp:GridView ID="gvEmergencies" runat="server" AutoGenerateColumns="False" CssClass="table-custom mb-0" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="EmergencyRequestId" HeaderText="ID" ItemStyle-CssClass="font-mono text-slate-400 font-bold" ItemStyle-Width="40px" />
                            <asp:TemplateField HeaderText="Factory &amp; Machine">
                                <ItemTemplate>
                                    <div class="font-bold text-[#0F172A]"><%# Eval("FactoryCompany") %></div>
                                    <div class="text-[11px] text-slate-500 flex items-center gap-1 font-mono">
                                        <i class="fa-solid fa-gears text-[10px]"></i> <%# Eval("MachineName") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Priority">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("PriorityLevel").ToString() == "Critical" ? "badge-danger" : (Eval("PriorityLevel").ToString() == "High" ? "badge-warning" : "badge-info") %>'>
                                        <%# Eval("PriorityLevel") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="LocationCity" HeaderText="City" ItemStyle-CssClass="text-slate-600 font-mono text-[11px]" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("Status").ToString() == "Open" ? "badge-warning" : "badge-info" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Panel ID="pnlNoEmergencies" runat="server" Visible="false" CssClass="p-8 text-center text-slate-400 bg-white">
                    <i class="fa-solid fa-circle-check text-emerald-500 text-3xl mb-2"></i>
                    <p class="text-xs font-bold text-slate-700 m-0">No Active Machine Emergencies</p>
                    <span class="text-[11px] text-slate-400">All registered factory manufacturing lines are operational.</span>
                </asp:Panel>
            </div>

            <!-- Recent Administrative Audit Activity -->
            <div class="table-container shadow-xs">
                <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                    <div class="flex items-center gap-2">
                        <i class="fa-solid fa-clock-rotate-left text-slate-400 text-xs"></i>
                        <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                            Recent Platform Audit Activity
                        </h2>
                    </div>
                    <a href="~/Admin/Audit/AuditLogs.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 font-mono">
                        View Audit Log →
                    </a>
                </div>

                <div class="p-3 bg-white divide-y divide-slate-100">
                    <asp:Repeater ID="rptAuditActivity" runat="server">
                        <ItemTemplate>
                            <div class="py-2.5 flex items-start justify-between gap-3 text-xs">
                                <div class="flex items-start gap-2.5">
                                    <div class="w-6 h-6 rounded bg-slate-100 text-slate-600 flex items-center justify-center text-[10px] shrink-0 mt-0.5 font-mono font-bold">
                                        <i class="fa-solid fa-shield"></i>
                                    </div>
                                    <div>
                                        <div class="font-bold text-slate-800">
                                            <%# Eval("ActionType") %>
                                            <span class="font-normal text-slate-500 font-mono text-[11px]">on <%# Eval("TargetEntity") %> #<%# Eval("EntityId") %></span>
                                        </div>
                                        <div class="text-[11px] text-slate-500 truncate max-w-sm">
                                            By <%# Eval("ActorEmail") ?? "System Kernel" %> (<%# Eval("IpAddress") ?? "127.0.0.1" %>)
                                        </div>
                                    </div>
                                </div>
                                <span class="text-[10px] font-mono text-slate-400 shrink-0">
                                    <%# Eval("CreatedAt", "{0:dd MMM HH:mm:ss}") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoAuditActivity" runat="server" Visible="false" CssClass="py-4 text-center text-slate-400">
                        <span class="text-xs">No recent administrative events logged.</span>
                    </asp:Panel>
                </div>
            </div>
        </div>

        <!-- Recent Registered Users & Quick Governance Actions (Span 5 Cols) -->
        <div class="lg:col-span-5 space-y-6">
            <!-- Recent Users Table (Database Top 8) -->
            <div class="table-container shadow-xs">
                <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
                    <div class="flex items-center gap-2">
                        <i class="fa-solid fa-user-clock text-[#1769E0] text-xs"></i>
                        <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                            Recent Registrations (Top 8)
                        </h2>
                    </div>
                    <a href="~/Admin/Users/ManageUsers.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline flex items-center gap-1 font-mono">
                        View Directory →
                    </a>
                </div>

                <div class="overflow-x-auto">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table-custom mb-0" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="User Account">
                                <ItemTemplate>
                                    <div class="font-bold text-[#0F172A] text-xs"><%# Eval("FullName") %></div>
                                    <div class="text-[11px] text-slate-500 font-mono truncate max-w-[160px]"><%# Eval("Email") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Role">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("RoleName").ToString() == "Administrator" ? "badge-primary" : (Eval("RoleName").ToString() == "Factory" ? "badge-warning" : (Eval("RoleName").ToString() == "Supplier" ? "badge-success" : "badge-info")) %>'>
                                        <%# Eval("RoleName") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# Convert.ToBoolean(Eval("IsActive")) ? "badge-success" : "badge-danger" %>'>
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Disabled" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <asp:Panel ID="pnlNoUsers" runat="server" Visible="false" CssClass="p-8 text-center text-slate-400 bg-white">
                    <span class="text-xs">No registered accounts located.</span>
                </asp:Panel>
            </div>

            <!-- Quick Governance Command Center -->
            <div class="card p-5 bg-white border border-[#CBD5E1] shadow-xs">
                <div class="flex items-center gap-2 mb-3 pb-2 border-b border-slate-100">
                    <i class="fa-solid fa-bolt text-amber-500 text-xs"></i>
                    <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                        Governance Fast Actions
                    </h2>
                </div>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                    <a href="~/Admin/Suppliers/Verification.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-emerald-400 hover:bg-emerald-50/50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-stamp text-emerald-600"></i>
                        <span>Audit Suppliers</span>
                    </a>
                    <a href="~/Admin/Orders/Oversight.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-orange-400 hover:bg-orange-50/50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-triangle-exclamation text-orange-600"></i>
                        <span>Triage SOS Tickets</span>
                    </a>
                    <a href="~/Admin/RBAC/Roles.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-indigo-400 hover:bg-indigo-50/50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-key text-indigo-600"></i>
                        <span>Security Clearances</span>
                    </a>
                    <a href="~/Admin/System/SystemHealth.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-blue-400 hover:bg-blue-50/50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-heart-pulse text-blue-600"></i>
                        <span>System Health</span>
                    </a>
                    <a href="~/Admin/System/DataIntegrity.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-teal-400 hover:bg-teal-50/50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-database text-teal-600"></i>
                        <span>Data Integrity</span>
                    </a>
                    <a href="~/Admin/Settings/PlatformSettings.aspx" runat="server" class="p-2.5 rounded border border-slate-200 hover:border-slate-400 hover:bg-slate-50 flex items-center gap-2 text-slate-700 font-medium transition-colors no-underline">
                        <i class="fa-solid fa-sliders text-slate-600"></i>
                        <span>Platform Settings</span>
                    </a>
                </div>
            </div>

            <!-- Platform Runtime & Architecture Footprint Card -->
            <div class="card p-5 bg-[#0F172A] text-slate-300 border border-[#1E293B] shadow-md">
                <div class="flex items-center justify-between mb-3 border-b border-[#1E293B] pb-2">
                    <span class="text-[10px] font-mono uppercase font-bold text-[#38BDF8] tracking-widest flex items-center gap-1.5">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span> ENGINE ACTIVE
                    </span>
                    <span class="text-[10px] font-mono text-slate-400">ASTANTRA KERNEL</span>
                </div>
                <div class="text-xs space-y-1.5 font-mono">
                    <div class="flex justify-between">
                        <span class="text-slate-400">Architecture:</span>
                        <span class="text-white">Three-Tier Web Forms</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-400">Framework:</span>
                        <span class="text-white">.NET Framework 4.8 (C# 7.3)</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-400">Data Access:</span>
                        <span class="text-white">Parameterized ADO.NET</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-400">Cryptography:</span>
                        <span class="text-emerald-400 font-bold">PBKDF2 HMAC-SHA256 (10k)</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-400">Session Operator:</span>
                        <span class="text-[#38BDF8]" id="lblSessionUser" runat="server">admin@sparepartportal.com</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <!-- Load stable local Chart.js library -->
    <script src="<%= ResolveUrl("~/Content/lib/chartjs/chart.umd.min.js") %>"></script>

    <script type="text/javascript">
        (function () {
            'use strict';

            var chartInstances = {};

            function destroyCharts() {
                for (var key in chartInstances) {
                    if (chartInstances.hasOwnProperty(key) && chartInstances[key]) {
                        try {
                            chartInstances[key].destroy();
                        } catch (e) {
                            console.error('Error destroying chart ' + key, e);
                        }
                    }
                }
                chartInstances = {};
            }

            function formatInr(val) {
                if (val === null || val === undefined) return '₹0';
                return '₹' + Number(val).toLocaleString('en-IN');
            }

            function initCharts() {
                destroyCharts();

                var rawDataInput = document.getElementById('<%= hdnChartData.ClientID %>');
                if (!rawDataInput || !rawDataInput.value) return;

                var data = {};
                try {
                    data = JSON.parse(rawDataInput.value);
                } catch (err) {
                    console.error('Failed to parse analytics payload', err);
                    return;
                }

                // Global Chart Defaults
                if (window.Chart) {
                    Chart.defaults.font.family = "'IBM Plex Sans', sans-serif";
                    Chart.defaults.font.size = 11;
                    Chart.defaults.color = '#475569';
                } else {
                    console.warn('Chart.js library not detected');
                    return;
                }

                // 1. Procurement Activity Line & Bar Chart (Dual Axis)
                var activityCanvas = document.getElementById('canvasProcurementActivity');
                var emptyActivity = document.getElementById('emptyNoticeActivity');
                var fallbackBody = document.getElementById('fallbackBodyActivity');

                if (activityCanvas && data.activity) {
                    var actLabels = [];
                    var actOrders = [];
                    var actGross = [];
                    var actCompleted = [];

                    if (fallbackBody) fallbackBody.innerHTML = '';

                    for (var i = 0; i < data.activity.length; i++) {
                        var row = data.activity[i];
                        actLabels.push(row.TimePeriod);
                        actOrders.push(row.TotalOrders);
                        actGross.push(row.GrossOrderValue);
                        actCompleted.push(row.CompletedRevenue);

                        if (fallbackBody) {
                            var tr = document.createElement('tr');
                            tr.className = 'border-b border-slate-100';
                            tr.innerHTML = '<td class="p-1.5">' + row.TimePeriod + '</td>' +
                                           '<td class="p-1.5 text-right font-bold">' + row.TotalOrders + '</td>' +
                                           '<td class="p-1.5 text-right text-emerald-700">' + formatInr(row.GrossOrderValue) + '</td>' +
                                           '<td class="p-1.5 text-right text-teal-700">' + formatInr(row.CompletedRevenue) + '</td>';
                            fallbackBody.appendChild(tr);
                        }
                    }

                    if (actLabels.length === 0) {
                        if (emptyActivity) emptyActivity.style.display = 'flex';
                    } else {
                        if (emptyActivity) emptyActivity.style.display = 'none';

                        chartInstances.activity = new Chart(activityCanvas.getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: actLabels,
                                datasets: [
                                    {
                                        type: 'line',
                                        label: 'Gross Value (₹)',
                                        data: actGross,
                                        borderColor: '#10B981',
                                        backgroundColor: 'rgba(16, 185, 129, 0.1)',
                                        borderWidth: 2.5,
                                        tension: 0.25,
                                        yAxisID: 'yGross',
                                        pointRadius: 4,
                                        pointBackgroundColor: '#10B981',
                                        fill: false
                                    },
                                    {
                                        type: 'line',
                                        label: 'Realized Revenue (₹)',
                                        data: actCompleted,
                                        borderColor: '#059669',
                                        borderWidth: 2,
                                        borderDash: [5, 5],
                                        yAxisID: 'yGross',
                                        pointRadius: 3,
                                        pointBackgroundColor: '#059669',
                                        fill: false
                                    },
                                    {
                                        type: 'bar',
                                        label: 'Orders Count',
                                        data: actOrders,
                                        backgroundColor: 'rgba(23, 105, 224, 0.75)',
                                        borderColor: '#1769E0',
                                        borderWidth: 1,
                                        borderRadius: 4,
                                        yAxisID: 'yOrders'
                                    }
                                ]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                interaction: { mode: 'index', intersect: false },
                                plugins: {
                                    legend: { position: 'top', labels: { boxWidth: 12, usePointStyle: true } },
                                    tooltip: {
                                        callbacks: {
                                            label: function (ctx) {
                                                if (ctx.dataset.yAxisID === 'yGross') {
                                                    return ctx.dataset.label + ': ' + formatInr(ctx.raw);
                                                }
                                                return ctx.dataset.label + ': ' + ctx.raw + ' consignments';
                                            }
                                        }
                                    }
                                },
                                scales: {
                                    x: { grid: { color: '#F1F5F9' }, ticks: { font: { family: "'IBM Plex Mono', monospace" } } },
                                    yGross: {
                                        type: 'linear',
                                        position: 'left',
                                        beginAtZero: true,
                                        ticks: {
                                            callback: function (val) {
                                                if (val >= 10000000) return '₹' + (val / 10000000).toFixed(1) + 'Cr';
                                                if (val >= 100000) return '₹' + (val / 100000).toFixed(1) + 'L';
                                                if (val >= 1000) return '₹' + (val / 1000).toFixed(0) + 'k';
                                                return '₹' + val;
                                            }
                                        },
                                        grid: { color: '#E2E8F0' }
                                    },
                                    yOrders: {
                                        type: 'linear',
                                        position: 'right',
                                        beginAtZero: true,
                                        grid: { drawOnChartArea: false },
                                        ticks: { precision: 0 }
                                    }
                                }
                            }
                        });
                    }
                }

                // 2. Order Fulfillment Status (Horizontal Bar)
                var statusCanvas = document.getElementById('canvasOrderStatus');
                var emptyStatus = document.getElementById('emptyNoticeStatus');
                if (statusCanvas && data.orderStatuses) {
                    var stLabels = [];
                    var stCounts = [];
                    var stColors = [];

                    var colorMap = {
                        'Pending': '#F59E0B',
                        'Processing': '#6366F1',
                        'Dispatched': '#06B6D4',
                        'Delivered': '#10B981',
                        'Cancelled': '#EF4444'
                    };

                    for (var s = 0; s < data.orderStatuses.length; s++) {
                        var stRow = data.orderStatuses[s];
                        stLabels.push(stRow.OrderStatus);
                        stCounts.push(stRow.TotalCount);
                        stColors.push(colorMap[stRow.OrderStatus] || '#94A3B8');
                    }

                    if (stLabels.length === 0) {
                        if (emptyStatus) emptyStatus.style.display = 'flex';
                    } else {
                        if (emptyStatus) emptyStatus.style.display = 'none';

                        chartInstances.orderStatus = new Chart(statusCanvas.getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: stLabels,
                                datasets: [{
                                    label: 'Orders',
                                    data: stCounts,
                                    backgroundColor: stColors,
                                    borderRadius: 4
                                }]
                            },
                            options: {
                                indexAxis: 'y',
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { display: false } },
                                scales: {
                                    x: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#F1F5F9' } },
                                    y: { grid: { display: false } }
                                }
                            }
                        });
                    }
                }

                // 3. User Role Doughnut Chart
                var roleCanvas = document.getElementById('canvasRoleDistribution');
                if (roleCanvas && data.roles) {
                    var rLabels = [];
                    var rCounts = [];
                    var rColors = ['#1769E0', '#059669', '#0891B2', '#475569', '#F59E0B'];

                    for (var r = 0; r < data.roles.length; r++) {
                        rLabels.push(data.roles[r].RoleName);
                        rCounts.push(data.roles[r].UserCount);
                    }

                    chartInstances.roles = new Chart(roleCanvas.getContext('2d'), {
                        type: 'doughnut',
                        data: {
                            labels: rLabels,
                            datasets: [{
                                data: rCounts,
                                backgroundColor: rColors,
                                borderWidth: 2,
                                borderColor: '#FFFFFF'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { position: 'bottom', labels: { boxWidth: 10, usePointStyle: true } }
                            },
                            cutout: '65%'
                        }
                    });
                }

                // 4. Emergency Priority Chart (Bar)
                var emergCanvas = document.getElementById('canvasEmergencyPriority');
                var emptyEmerg = document.getElementById('emptyNoticeEmergency');
                if (emergCanvas && data.emergencyPriorities) {
                    var priLabels = [];
                    var priCounts = [];
                    var priColors = [];

                    var priMap = {
                        'Critical': '#DC2626',
                        'High': '#EA580C',
                        'Medium': '#F59E0B',
                        'Low': '#3B82F6'
                    };

                    for (var eIdx = 0; eIdx < data.emergencyPriorities.length; eIdx++) {
                        var eRow = data.emergencyPriorities[eIdx];
                        priLabels.push(eRow.PriorityLevel + ' (' + eRow.Status + ')');
                        priCounts.push(eRow.IncidentCount);
                        priColors.push(priMap[eRow.PriorityLevel] || '#94A3B8');
                    }

                    if (priLabels.length === 0) {
                        if (emptyEmerg) emptyEmerg.style.display = 'flex';
                    } else {
                        if (emptyEmerg) emptyEmerg.style.display = 'none';

                        chartInstances.emergency = new Chart(emergCanvas.getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: priLabels,
                                datasets: [{
                                    label: 'Incident Tickets',
                                    data: priCounts,
                                    backgroundColor: priColors,
                                    borderRadius: 4
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { display: false } },
                                scales: {
                                    y: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#F1F5F9' } },
                                    x: { grid: { display: false }, ticks: { font: { size: 10 } } }
                                }
                            }
                        });
                    }
                }

                // 5. RFQ Funnel Pipeline (Horizontal Bar / Stages)
                var funnelCanvas = document.getElementById('canvasRfqFunnel');
                if (funnelCanvas && data.rfqFunnel) {
                    var stages = ['1. RFQs Created', '2. Bids Received', '3. Quotes Accepted', '4. Orders Placed'];
                    var stageCounts = [
                        data.rfqFunnel.TotalRfqsCreated || 0,
                        data.rfqFunnel.BidsReceived || 0,
                        data.rfqFunnel.BidsAccepted || 0,
                        data.rfqFunnel.OrdersCreated || 0
                    ];

                    chartInstances.funnel = new Chart(funnelCanvas.getContext('2d'), {
                        type: 'bar',
                        data: {
                            labels: stages,
                            datasets: [{
                                label: 'Pipeline Volume',
                                data: stageCounts,
                                backgroundColor: ['#6366F1', '#818CF8', '#10B981', '#059669'],
                                borderRadius: 4
                            }]
                        },
                        options: {
                            indexAxis: 'y',
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false },
                                tooltip: {
                                    callbacks: {
                                        afterLabel: function (context) {
                                            var total = stageCounts[0];
                                            if (total > 0 && context.dataIndex > 0) {
                                                var conv = ((context.raw / total) * 100).toFixed(1);
                                                return 'Overall Conversion: ' + conv + '%';
                                            }
                                            return '';
                                        }
                                    }
                                }
                            },
                            scales: {
                                x: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#F1F5F9' } },
                                y: { grid: { display: false } }
                            }
                        }
                    });
                }
            }

            // Bind to DOM ready
            if (document.readyState === 'complete' || document.readyState === 'interactive') {
                setTimeout(initCharts, 50);
            } else {
                document.addEventListener('DOMContentLoaded', initCharts);
            }

            // ASP.NET Web Forms Partial PostBack Handler
            if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_endRequest(function () {
                    setTimeout(initCharts, 50);
                });
            }
        })();
    </script>
</asp:Content>
