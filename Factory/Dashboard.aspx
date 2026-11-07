<%@ Page Title="Factory Procurement Command Center" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .chart-container-card {
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
        .chart-canvas-box {
            position: relative;
            flex: 1;
            height: 240px;
            min-height: 240px;
            width: 100%;
        }
        .empty-chart-box {
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
    <!-- Hidden field with JSON telemetry for Chart.js -->
    <asp:HiddenField ID="hdnFactoryCharts" runat="server" Value="{}" />

    <!-- 1. Executive Plant Command Bar -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs">
        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-5">
            <div class="space-y-1">
                <div class="flex items-center gap-2">
                    <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200">
                        <i class="fa-solid fa-industry mr-1 text-[9px]"></i> Plant Procurement Workspace
                    </span>
                    <span class="font-mono text-xs text-slate-500" id="lblPlantLocation" runat="server">Industrial Facility</span>
                </div>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    <span id="lblUserCompany" runat="server" class="text-[#1769E0]">Industrial Plant</span>
                </h1>
                <p class="text-xs text-slate-500 m-0 max-w-2xl">
                    Commercial spare parts procurement, supplier bid evaluation, equipment fleet tracking, and priority breakdown triage.
                </p>
            </div>

            <!-- Quick Action Toolbar -->
            <div class="flex flex-wrap items-center gap-2.5 shrink-0">
                <asp:LinkButton ID="btnToggleRfqForm" runat="server" OnClick="btnToggleRfqForm_Click" CssClass="btn-primary text-xs py-2 px-3.5">
                    <i class="fa-solid fa-plus"></i>
                    <span>Issue New RFQ</span>
                </asp:LinkButton>
                <a href="~/Factory/SpareParts/Search.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>Find Spares</span>
                </a>
                <a href="~/Factory/Machines/MyMachinery.aspx" runat="server" class="btn-secondary text-xs py-2 px-3.5">
                    <i class="fa-solid fa-gears"></i>
                    <span>My Machinery</span>
                </a>
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2 px-3.5">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>Log Breakdown SOS</span>
                </a>
            </div>
        </div>
    </div>

    <!-- 2. System Alerts / Flash Feedback -->
    <asp:Panel ID="pnlAlertNotice" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2.5">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <span id="lblAlertText" runat="server" class="font-medium">Action completed successfully.</span>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-700">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- 3. Key Operational Metric Cards (5 Cards) -->
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3.5 mb-6">
        <!-- Active RFQs -->
        <div class="kpi-card">
            <div>
                <span class="kpi-val block" id="lblMetricRfqs" runat="server">0</span>
                <span class="kpi-lbl block">Active RFQs</span>
            </div>
            <div class="kpi-icon-wrap bg-blue-50 text-[#1769E0]">
                <i class="fa-solid fa-file-invoice"></i>
            </div>
        </div>

        <!-- Quotes Received -->
        <div class="kpi-card">
            <div>
                <span class="kpi-val block text-emerald-600" id="lblMetricQuotes" runat="server">0</span>
                <span class="kpi-lbl block">Quotes Received</span>
            </div>
            <div class="kpi-icon-wrap bg-emerald-50 text-emerald-600">
                <i class="fa-solid fa-tag"></i>
            </div>
        </div>

        <!-- Active Orders -->
        <div class="kpi-card">
            <div>
                <span class="kpi-val block" id="lblMetricOrders" runat="server">0</span>
                <span class="kpi-lbl block">Active Orders</span>
            </div>
            <div class="kpi-icon-wrap bg-indigo-50 text-indigo-600">
                <i class="fa-solid fa-boxes-packing"></i>
            </div>
        </div>

        <!-- Plant Machinery -->
        <div class="kpi-card">
            <div>
                <span class="kpi-val block text-slate-800" id="lblMetricMachines" runat="server">0</span>
                <span class="kpi-lbl block">Plant Machinery</span>
            </div>
            <div class="kpi-icon-wrap bg-slate-100 text-slate-700">
                <i class="fa-solid fa-gears"></i>
            </div>
        </div>

        <!-- Emergency Breakdowns -->
        <div class="kpi-card col-span-2 sm:col-span-1">
            <div>
                <span class="kpi-val block text-orange-600" id="lblMetricEmergency" runat="server">0</span>
                <span class="kpi-lbl block">Breakdown SOS</span>
            </div>
            <div class="kpi-icon-wrap bg-orange-50 text-orange-600">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
        </div>
    </div>

    <!-- 4. Issue New RFQ Collapsible Workspace -->
    <asp:Panel ID="pnlRfqForm" runat="server" Visible="false" CssClass="factory-card mb-6">
        <div class="factory-card-header">
            <h3 class="factory-card-title">
                <i class="fa-solid fa-plus-circle text-[#1769E0]"></i>
                Issue Structured Request for Quotation (RFQ)
            </h3>
            <asp:LinkButton ID="btnCancelRfqTop" runat="server" OnClick="btnCancelRfq_Click" CssClass="text-slate-400 hover:text-slate-700 text-xs font-mono">
                <i class="fa-solid fa-xmark"></i> Close
            </asp:LinkButton>
        </div>

        <div class="factory-card-body space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
                <div>
                    <label class="form-label" for="<%= ddlRfqPart.ClientID %>">Select Spare Part Component <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlRfqPart" runat="server" CssClass="form-select font-medium"></asp:DropDownList>
                </div>

                <div>
                    <label class="form-label" for="<%= txtRfqQty.ClientID %>">Required Quantity (Units) <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtRfqQty" runat="server" CssClass="form-input" TextMode="Number" Text="1"></asp:TextBox>
                </div>

                <div>
                    <label class="form-label" for="<%= txtRfqTargetPrice.ClientID %>">Target Unit Budget (₹ INR, Optional)</label>
                    <asp:TextBox ID="txtRfqTargetPrice" runat="server" CssClass="form-input" Placeholder="e.g. 45000"></asp:TextBox>
                </div>

                <div>
                    <label class="form-label" for="<%= txtRfqRequiredDate.ClientID %>">Required Delivery Date</label>
                    <asp:TextBox ID="txtRfqRequiredDate" runat="server" CssClass="form-input" TextMode="Date"></asp:TextBox>
                </div>

                <div class="md:col-span-2">
                    <label class="form-label" for="<%= txtRfqRemarks.ClientID %>">Technical Specifications &amp; Quality Tolerance</label>
                    <asp:TextBox ID="txtRfqRemarks" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="2" Placeholder="Specify required tolerance, manufacturer brand preference, warranty expectations, or plant delivery instructions..."></asp:TextBox>
                </div>
            </div>

            <div class="flex items-center gap-3 pt-3 border-t border-slate-100">
                <asp:Button ID="btnSubmitRfq" runat="server" Text="Broadcast RFQ to Verified Suppliers" OnClick="btnSubmitRfq_Click" CssClass="btn-primary" />
                <asp:Button ID="btnCancelRfq" runat="server" Text="Cancel" OnClick="btnCancelRfq_Click" CssClass="btn-secondary" />
            </div>
        </div>
    </asp:Panel>

    <!-- 5. Interactive Visual Telemetry Suite (4 Charts in 2x2 Grid) -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-6">
        <!-- Chart 1: Monthly RFQ & Order Procurement Activity -->
        <div class="chart-container-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-chart-line text-[#1769E0]"></i>
                        Requisition &amp; Order Stream
                    </div>
                    <span class="text-xs text-slate-500">RFQs published vs. confirmed purchase orders.</span>
                </div>
            </div>
            <div class="chart-canvas-box" id="containerActivity">
                <canvas id="canvasFactoryActivity"></canvas>
                <div id="emptyActivity" class="empty-chart-box" style="display:none;">
                    <i class="fa-solid fa-chart-simple text-slate-300 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-600 m-0">No procurement records yet</p>
                    <span class="text-[11px] text-slate-400">Issue an RFQ to begin telemetry</span>
                </div>
            </div>
        </div>

        <!-- Chart 2: Purchase Order Fulfillment Status -->
        <div class="chart-container-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-boxes-packing text-emerald-600"></i>
                        Order Fulfillment Status
                    </div>
                    <span class="text-xs text-slate-500">Current stages of purchase orders.</span>
                </div>
            </div>
            <div class="chart-canvas-box" id="containerOrderStatus">
                <canvas id="canvasFactoryOrderStatus"></canvas>
                <div id="emptyOrderStatus" class="empty-chart-box" style="display:none;">
                    <i class="fa-solid fa-box-open text-slate-300 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-600 m-0">No purchase orders placed yet</p>
                </div>
            </div>
        </div>

        <!-- Chart 3: Machinery Asset Health Breakdown -->
        <div class="chart-container-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-gears text-purple-600"></i>
                        Equipment Asset Health
                    </div>
                    <span class="text-xs text-slate-500">Registered factory machinery operational states.</span>
                </div>
            </div>
            <div class="chart-canvas-box" id="containerMachineStatus">
                <canvas id="canvasFactoryMachineStatus"></canvas>
            </div>
        </div>

        <!-- Chart 4: Service Engineering Requests Breakdown -->
        <div class="chart-container-card">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                        <i class="fa-solid fa-user-gear text-indigo-600"></i>
                        Service Engineer Tickets
                    </div>
                    <span class="text-xs text-slate-500">Breakdown maintenance and scheduled service.</span>
                </div>
            </div>
            <div class="chart-canvas-box" id="containerServiceStatus">
                <canvas id="canvasFactoryServiceStatus"></canvas>
                <div id="emptyServiceStatus" class="empty-chart-box" style="display:none;">
                    <i class="fa-solid fa-circle-check text-emerald-400 text-3xl mb-2"></i>
                    <p class="text-xs font-semibold text-slate-600 m-0">Zero maintenance tickets</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 6. Active RFQs & Quotation Comparison Ledger -->
    <div class="factory-card mb-6">
        <div class="factory-card-header">
            <div>
                <h2 class="factory-card-title">
                    <i class="fa-solid fa-file-invoice text-[#1769E0]"></i>
                    Active Requests for Quotation (RFQs)
                </h2>
                <span class="text-xs text-slate-500">Recent commercial requisitions with received supplier bids.</span>
            </div>
            <a href="~/Factory/Quotations/MyRequests.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline font-mono">
                View All RFQs &rarr;
            </a>
        </div>

        <div class="overflow-x-auto">
            <table class="factory-table">
                <thead>
                    <tr>
                        <th class="w-[12%]">RFQ Ref #</th>
                        <th class="w-[28%]">Component Specification</th>
                        <th class="w-[10%]">Quantity</th>
                        <th class="w-[14%]">Target Budget</th>
                        <th class="w-[12%]">Bids Received</th>
                        <th class="w-[12%]">Status</th>
                        <th class="w-[12%] text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRfqs" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="font-mono font-bold text-[#1769E0]">
                                    RFQ-<%# Eval("RfqId") %>
                                </td>
                                <td>
                                    <strong class="text-slate-900 block font-medium"><%# Eval("PartName") %></strong>
                                    <span class="text-slate-500 font-mono text-[11px]"><%# Eval("PartNumber") %></span>
                                </td>
                                <td class="font-mono font-bold">
                                    <%# Eval("Quantity") %> Pcs
                                </td>
                                <td class="font-mono">
                                    <%# Eval("TargetPrice") != DBNull.Value && Eval("TargetPrice") != null
                                        ? "₹" + Convert.ToDecimal(Eval("TargetPrice")).ToString("N0")
                                        : "<span class='text-slate-400'>Open</span>" %>
                                </td>
                                <td>
                                    <span class="font-mono font-bold text-xs <%# Convert.ToInt32(Eval("BidCount")) > 0 ? "text-emerald-700" : "text-slate-400" %>">
                                        <i class="fa-solid fa-tag mr-1 text-[10px]"></i> <%# Eval("BidCount") %> <%# Convert.ToInt32(Eval("BidCount")) == 1 ? "Bid" : "Bids" %>
                                    </span>
                                </td>
                                <td>
                                    <span class='badge-status <%# Eval("Status").ToString() == "Quoted" ? "badge-quoted" : (Eval("Status").ToString() == "Closed" ? "badge-closed" : "badge-pending") %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td class="text-right">
                                    <a href='<%# ResolveUrl(string.Format("~/Factory/Quotations/Compare.aspx?rfqId={0}", Eval("RfqId"))) %>' 
                                       class="btn-secondary text-[11px] py-1 px-2.5 font-bold">
                                        <%# Convert.ToInt32(Eval("BidCount")) > 0 ? "Compare Quotes &rarr;" : "View RFQ" %>
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoRfqs" runat="server" Visible="false" CssClass="text-center py-8 text-xs text-slate-500">
            <p class="font-medium text-slate-800 m-0">No active quotation requests recorded for this facility.</p>
            <span class="text-slate-400 text-[11px]">Select a replacement spare part from the catalog to issue your initial RFQ.</span>
        </asp:Panel>
    </div>

    <!-- 7. Recent Purchase Orders & Logistics Tracker -->
    <div class="factory-card mb-6">
        <div class="factory-card-header">
            <div>
                <h2 class="factory-card-title">
                    <i class="fa-solid fa-boxes-packing text-emerald-600"></i>
                    Recent Purchase Orders &amp; Logistics Tracking
                </h2>
                <span class="text-xs text-slate-500">Purchase orders placed with verified stocking suppliers.</span>
            </div>
            <a href="~/Factory/Orders/MyOrders.aspx" runat="server" class="text-xs font-bold text-[#1769E0] hover:underline font-mono">
                View All Orders &rarr;
            </a>
        </div>

        <div class="overflow-x-auto">
            <table class="factory-table">
                <thead>
                    <tr>
                        <th class="w-[14%]">Order #</th>
                        <th class="w-[26%]">Fulfilling Supplier</th>
                        <th class="w-[14%]">Total Amount</th>
                        <th class="w-[16%]">Tracking Number</th>
                        <th class="w-[14%]">Fulfillment Status</th>
                        <th class="w-[16%] text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptOrders" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="font-mono font-bold text-slate-900">
                                    <%# Eval("OrderNumber") %>
                                    <%# Convert.ToBoolean(Eval("IsEmergency")) ? "<span class='text-[10px] text-orange-600 font-bold block'>EMERGENCY</span>" : "" %>
                                </td>
                                <td class="font-medium text-slate-800">
                                    <%# Eval("SupplierCompany") %>
                                    <span class="text-[11px] text-slate-400 block font-mono"><%# Eval("City") %></span>
                                </td>
                                <td class="font-mono font-bold text-slate-900">
                                    ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N0") %>
                                </td>
                                <td class="font-mono text-[#1769E0]">
                                    <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString())
                                        ? Eval("TrackingNumber")
                                        : "<span class='text-slate-400'>Awaiting Courier</span>" %>
                                </td>
                                <td>
                                    <span class='badge-status <%# Eval("OrderStatus").ToString() == "Delivered" ? "badge-delivered" : (Eval("OrderStatus").ToString() == "Shipped" ? "badge-shipped" : "badge-processing") %>'>
                                        <%# Eval("OrderStatus") %>
                                    </span>
                                </td>
                                <td class="text-right">
                                    <a href='<%# ResolveUrl(string.Format("~/Factory/Orders/OrderDetails.aspx?orderId={0}", Eval("OrderId"))) %>' 
                                       class="btn-secondary text-[11px] py-1 px-2.5 font-bold">
                                        View Invoice &rarr;
                                    </a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-8 text-xs text-slate-500">
            <p class="font-medium text-slate-800 m-0">No active purchase orders placed yet.</p>
            <span class="text-slate-400 text-[11px]">When quotes are approved, purchase orders will update here with real-time tracking.</span>
        </asp:Panel>
    </div>

    <!-- 8. Critical Breakdown Protocol Status -->
    <div class="factory-card mb-6">
        <div class="factory-card-header">
            <div>
                <h2 class="factory-card-title text-orange-800">
                    <i class="fa-solid fa-triangle-exclamation text-orange-600"></i>
                    Critical Breakdown Dispatches (Active Plant Incidents)
                </h2>
                <span class="text-xs text-slate-500">High-priority emergency alerts broadcasted to regional response engineers.</span>
            </div>
            <a href="~/Public/Emergency.aspx" runat="server" class="text-xs font-bold text-orange-600 hover:underline font-mono">
                + New Breakdown SOS &rarr;
            </a>
        </div>

        <div class="overflow-x-auto">
            <table class="factory-table">
                <thead>
                    <tr>
                        <th class="w-[12%]">Dispatch ID</th>
                        <th class="w-[24%]">Affected Machinery</th>
                        <th class="w-[32%]">Component / Breakdown Symptoms</th>
                        <th class="w-[12%]">Severity</th>
                        <th class="w-[10%]">Desk Status</th>
                        <th class="w-[10%] text-right">Logged Date</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptEmergency" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="font-mono font-bold text-orange-600">
                                    EMG-<%# Eval("EmergencyRequestId") %>
                                </td>
                                <td class="font-bold text-slate-900">
                                    <%# Eval("MachineName") %>
                                    <span class="text-[11px] text-slate-400 block font-mono font-normal"><%# Eval("LocationCity") %></span>
                                </td>
                                <td>
                                    <span class="text-[11px] text-slate-700 block line-clamp-1"><%# Eval("BreakdownDescription") %></span>
                                </td>
                                <td>
                                    <span class="badge-status badge-critical">
                                        <%# Eval("PriorityLevel") %>
                                    </span>
                                </td>
                                <td>
                                    <span class='badge-status <%# Eval("Status").ToString() == "Resolved" ? "badge-delivered" : "badge-pending" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td class="text-right font-mono text-slate-500">
                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM HH:mm") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoEmergency" runat="server" Visible="false" CssClass="text-center py-8 text-xs text-slate-500">
            <p class="font-medium text-emerald-700 m-0"><i class="fa-solid fa-circle-check mr-1 text-emerald-500"></i> All plant production lines operating normally.</p>
            <span class="text-slate-400 text-[11px]">No active machine stoppage tickets recorded for this plant.</span>
        </asp:Panel>
    </div>

    <!-- Client-Side Chart.js Telemetry Initialization Script -->
    <script>
        (function () {
            function initFactoryCharts() {
                var raw = document.getElementById('<%= hdnFactoryCharts.ClientID %>');
                if (!raw || !raw.value) return;

                var data = {};
                try {
                    data = JSON.parse(raw.value);
                } catch (e) {
                    console.error('Failed to parse factory chart JSON', e);
                    return;
                }

                if (!window.Chart) return;
                Chart.defaults.font.family = "'IBM Plex Sans', sans-serif";
                Chart.defaults.font.size = 11;
                Chart.defaults.color = '#475569';

                // 1. Activity Trend (Line/Bar)
                var actCanvas = document.getElementById('canvasFactoryActivity');
                var actEmpty = document.getElementById('emptyActivity');
                if (actCanvas && data.trend) {
                    var labels = [], rfqs = [], orders = [];
                    for (var i = 0; i < data.trend.length; i++) {
                        labels.push(data.trend[i].PeriodDate);
                        rfqs.push(data.trend[i].RfqCount);
                        orders.push(data.trend[i].OrderCount);
                    }
                    if (labels.length === 0) {
                        if (actEmpty) actEmpty.style.display = 'flex';
                    } else {
                        if (actEmpty) actEmpty.style.display = 'none';
                        new Chart(actCanvas.getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: labels,
                                datasets: [
                                    { label: 'Orders Placed', data: orders, backgroundColor: '#10B981', borderRadius: 4 },
                                    { label: 'RFQs Issued', data: rfqs, backgroundColor: '#1769E0', borderRadius: 4 }
                                ]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { position: 'top', labels: { boxWidth: 10 } } },
                                scales: {
                                    y: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#F1F5F9' } },
                                    x: { grid: { display: false } }
                                }
                            }
                        });
                    }
                }

                // 2. Order Status (Doughnut)
                var ordCanvas = document.getElementById('canvasFactoryOrderStatus');
                var ordEmpty = document.getElementById('emptyOrderStatus');
                if (ordCanvas && data.orderStatuses) {
                    var stLabels = [], stCounts = [];
                    for (var s = 0; s < data.orderStatuses.length; s++) {
                        stLabels.push(data.orderStatuses[s].OrderStatus);
                        stCounts.push(data.orderStatuses[s].StatusCount);
                    }
                    if (stLabels.length === 0) {
                        if (ordEmpty) ordEmpty.style.display = 'flex';
                    } else {
                        if (ordEmpty) ordEmpty.style.display = 'none';
                        new Chart(ordCanvas.getContext('2d'), {
                            type: 'doughnut',
                            data: {
                                labels: stLabels,
                                datasets: [{
                                    data: stCounts,
                                    backgroundColor: ['#6366F1', '#10B981', '#06B6D4', '#F59E0B', '#EF4444'],
                                    borderWidth: 2,
                                    borderColor: '#FFFFFF'
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, usePointStyle: true } } },
                                cutout: '65%'
                            }
                        });
                    }
                }

                // 3. Machinery Status (Bar)
                var macCanvas = document.getElementById('canvasFactoryMachineStatus');
                if (macCanvas && data.machinery) {
                    new Chart(macCanvas.getContext('2d'), {
                        type: 'bar',
                        data: {
                            labels: ['Operational', 'Under Maintenance', 'Offline'],
                            datasets: [{
                                label: 'Assets',
                                data: [data.machinery.operational, data.machinery.maintenance, data.machinery.offline],
                                backgroundColor: ['#059669', '#D97706', '#94A3B8'],
                                borderRadius: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: { legend: { display: false } },
                            scales: {
                                y: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#F1F5F9' } },
                                x: { grid: { display: false } }
                            }
                        }
                    });
                }

                // 4. Service Requests (Doughnut)
                var srvCanvas = document.getElementById('canvasFactoryServiceStatus');
                var srvEmpty = document.getElementById('emptyServiceStatus');
                if (srvCanvas && data.serviceStatuses) {
                    var srvLabels = [], srvCounts = [];
                    for (var sv = 0; sv < data.serviceStatuses.length; sv++) {
                        srvLabels.push(data.serviceStatuses[sv].ServiceStatus);
                        srvCounts.push(data.serviceStatuses[sv].StatusCount);
                    }
                    if (srvLabels.length === 0) {
                        if (srvEmpty) srvEmpty.style.display = 'flex';
                    } else {
                        if (srvEmpty) srvEmpty.style.display = 'none';
                        new Chart(srvCanvas.getContext('2d'), {
                            type: 'doughnut',
                            data: {
                                labels: srvLabels,
                                datasets: [{
                                    data: srvCounts,
                                    backgroundColor: ['#F59E0B', '#6366F1', '#10B981'],
                                    borderWidth: 2,
                                    borderColor: '#FFFFFF'
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, usePointStyle: true } } },
                                cutout: '65%'
                            }
                        });
                    }
                }
            }

            if (document.readyState === 'complete' || document.readyState === 'interactive') {
                setTimeout(initFactoryCharts, 50);
            } else {
                document.addEventListener('DOMContentLoaded', initFactoryCharts);
            }
        })();
    </script>
</asp:Content>
