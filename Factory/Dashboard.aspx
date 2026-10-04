<%@ Page Title="Factory Buyer Dashboard" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Factory Buyer Procurement Console — Manage active RFQs, compare supplier quotations, track purchase orders, and monitor emergency breakdown requests." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- 1. Operational Workspace Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 sm:p-7 mb-6 shadow-xs text-left">
        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-5">
            <div class="space-y-1.5">
                <div class="flex items-center gap-2">
                    <span class="status-pill status-pill-verified text-[10px]">
                        <i class="fa-solid fa-industry text-[8px] mr-1"></i> PLANT OPERATIONS CONSOLE
                    </span>
                    <span class="font-mono text-xs text-[#5F6B7A]" id="lblPlantLocation" runat="server">Gujarat Industrial Zone</span>
                </div>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Welcome back, <span id="lblUserCompany" runat="server" class="text-[#1769E0]">Industrial Buyer</span>
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 max-w-2xl leading-relaxed">
                    Issue structured RFQs to regional verified stockists, compare binding commercial quotes, and monitor equipment breakdown triage.
                </p>
            </div>

            <div class="flex flex-wrap items-center gap-2.5 shrink-0">
                <asp:Button ID="btnToggleRfqForm" runat="server" Text="+ Issue New RFQ" OnClick="btnToggleRfqForm_Click" CssClass="btn-primary text-xs py-2.5 px-4 font-bold cursor-pointer" />
                <a href="~/Public/Parts.aspx" runat="server" class="btn-secondary text-xs py-2.5 px-4 font-bold">
                    <i class="fa-solid fa-magnifying-glass mr-1"></i> Browse Parts
                </a>
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2.5 px-4 font-bold">
                    <i class="fa-solid fa-bolt mr-1"></i> Emergency Alert
                </a>
            </div>
        </div>
    </div>

    <!-- 2. System Alerts / Notifications -->
    <asp:Panel ID="pnlAlertNotice" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <span id="lblAlertText" runat="server" class="font-medium">Action completed successfully.</span>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-[#5F6B7A] hover:text-[#17212F]">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- 3. Key Operational Metric Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">

        <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-mono font-bold uppercase text-[#5F6B7A]">Active RFQs</span>
                <i class="fa-solid fa-file-invoice text-[#1769E0] text-xs"></i>
            </div>
            <span class="text-2xl font-black text-[#17212F] font-mono block" id="lblMetricRfqs" runat="server">0</span>
            <span class="text-[11px] text-[#5F6B7A] font-mono block">Procurement Inquiries</span>
        </div>

        <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-mono font-bold uppercase text-[#5F6B7A]">Quotes Received</span>
                <i class="fa-solid fa-scale-balanced text-[#18865B] text-xs"></i>
            </div>
            <span class="text-2xl font-black text-[#18865B] font-mono block" id="lblMetricQuotes" runat="server">0</span>
            <span class="text-[11px] text-[#5F6B7A] font-mono block">Pending Comparison</span>
        </div>

        <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-mono font-bold uppercase text-[#5F6B7A]">Active Orders</span>
                <i class="fa-solid fa-truck-fast text-[#1769E0] text-xs"></i>
            </div>
            <span class="text-2xl font-black text-[#17212F] font-mono block" id="lblMetricOrders" runat="server">0</span>
            <span class="text-[11px] text-[#5F6B7A] font-mono block">In-Transit / Processing</span>
        </div>

        <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] space-y-1.5 text-left shadow-xs">
            <div class="flex items-center justify-between">
                <span class="text-[11px] font-mono font-bold uppercase text-[#5F6B7A]">Emergency Alerts</span>
                <i class="fa-solid fa-bolt text-[#E87519] text-xs"></i>
            </div>
            <span class="text-2xl font-black text-[#E87519] font-mono block" id="lblMetricEmergency" runat="server">0</span>
            <span class="text-[11px] text-[#E87519] font-mono font-bold block">Critical Machine Stoppages</span>
        </div>

    </div>

    <!-- 4. Issue New RFQ Collapsible Workspace -->
    <asp:Panel ID="pnlRfqForm" runat="server" Visible="false" CssClass="bg-white rounded-[3px] border border-[#D5DCE3] p-6 sm:p-7 mb-8 shadow-xs text-left">
        <div class="flex items-center justify-between border-b border-[#D5DCE3] pb-3 mb-5">
            <div>
                <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Issue Request for Quotation (RFQ)</h3>
                <span class="text-xs text-[#5F6B7A] font-mono">Broadcast commercial purchase specification to regional stocking suppliers</span>
            </div>
            <asp:LinkButton ID="btnCancelRfqTop" runat="server" OnClick="btnCancelRfq_Click" CssClass="text-[#5F6B7A] hover:text-[#17212F] text-xs font-mono">
                <i class="fa-solid fa-xmark mr-1"></i> Close
            </asp:LinkButton>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
            <div>
                <label class="form-label" for="<%= ddlRfqPart.ClientID %>">Select Spare Part Component <span class="text-red-500">*</span></label>
                <asp:DropDownList ID="ddlRfqPart" runat="server" CssClass="form-input font-medium"></asp:DropDownList>
            </div>

            <div>
                <label class="form-label" for="<%= txtRfqQty.ClientID %>">Required Quantity (Pieces) <span class="text-red-500">*</span></label>
                <asp:TextBox ID="txtRfqQty" runat="server" CssClass="form-input" TextMode="Number" Text="1"></asp:TextBox>
            </div>

            <div>
                <label class="form-label" for="<%= txtRfqTargetPrice.ClientID %>">Target Unit Budget (&#8377; Optional)</label>
                <asp:TextBox ID="txtRfqTargetPrice" runat="server" CssClass="form-input" Placeholder="e.g. 45000"></asp:TextBox>
            </div>

            <div>
                <label class="form-label" for="<%= txtRfqRequiredDate.ClientID %>">Required On-Site Date</label>
                <asp:TextBox ID="txtRfqRequiredDate" runat="server" CssClass="form-input" TextMode="Date"></asp:TextBox>
            </div>

            <div class="md:col-span-2">
                <label class="form-label" for="<%= txtRfqRemarks.ClientID %>">Technical Specifications &amp; Quality Requirements</label>
                <asp:TextBox ID="txtRfqRemarks" runat="server" CssClass="form-input" TextMode="MultiLine" Rows="2" Placeholder="Specify required tolerance, manufacturer brand preference, warranty expectations, or plant delivery instructions..."></asp:TextBox>
            </div>
        </div>

        <div class="flex items-center gap-3 pt-5 mt-4 border-t border-[#D5DCE3]">
            <asp:Button ID="btnSubmitRfq" runat="server" Text="Broadcast RFQ to Suppliers" OnClick="btnSubmitRfq_Click" CssClass="btn-primary text-xs py-2.5 px-6 font-bold cursor-pointer" />
            <asp:Button ID="btnCancelRfq" runat="server" Text="Cancel" OnClick="btnCancelRfq_Click" CssClass="btn-secondary text-xs py-2.5 px-4 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- 5. Active RFQs & Received Quotations Section -->
    <div class="space-y-4 mb-8 text-left">
        <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-2 border-b border-[#D5DCE3] pb-3">
            <div>
                <h2 class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Active Requests for Quotation (RFQs)</h2>
                <p class="text-xs text-[#5F6B7A] m-0 mt-0.5">Procurement requests issued to regional distributors with received competitive bids.</p>
            </div>
            <span class="text-xs font-mono text-[#5F6B7A]">Real-Time Ledger</span>
        </div>

        <div class="table-container shadow-xs">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th class="w-[12%]">RFQ Ref #</th>
                        <th class="w-[28%]">Component Specification</th>
                        <th class="w-[10%]">Quantity</th>
                        <th class="w-[14%]">Target Budget</th>
                        <th class="w-[12%]">Quotes Received</th>
                        <th class="w-[12%]">RFQ Status</th>
                        <th class="w-[12%] text-right">Created Date</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#D5DCE3] text-xs">
                    <asp:Repeater ID="rptRfqs" runat="server">
                        <ItemTemplate>
                            <tr class="hover:bg-[#F7F8FA] transition-colors">
                                <td class="py-3 px-4 font-mono font-bold text-[#1769E0]">
                                    RFQ-<%# Eval("RfqId") %>
                                </td>
                                <td class="py-3 px-4">
                                    <strong class="text-[#17212F] block font-medium"><%# Eval("PartName") %></strong>
                                    <span class="text-[#5F6B7A] font-mono text-[11px]"><%# Eval("PartNumber") %></span>
                                </td>
                                <td class="py-3 px-4 font-mono font-bold text-[#17212F]">
                                    <%# Eval("Quantity") %> Pcs
                                </td>
                                <td class="py-3 px-4 font-mono text-[#17212F]">
                                    <%# Eval("TargetPrice") != DBNull.Value && Eval("TargetPrice") != null
                                        ? "&#8377;" + Convert.ToDecimal(Eval("TargetPrice")).ToString("N0")
                                        : "<span class='text-[#5F6B7A]'>Open Market</span>" %>
                                </td>
                                <td class="py-3 px-4">
                                    <span class="font-mono font-bold text-xs <%# Convert.ToInt32(Eval("ResponseCount")) > 0 ? "text-[#18865B]" : "text-[#5F6B7A]" %>">
                                        <i class="fa-solid fa-tag mr-1 text-[10px]"></i> <%# Eval("ResponseCount") %> <%# Convert.ToInt32(Eval("ResponseCount")) == 1 ? "Bid" : "Bids" %>
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <span class='<%# Eval("Status").ToString() == "Quoted" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td class="py-3 px-4 text-right font-mono text-[#5F6B7A]">
                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM yyyy") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoRfqs" runat="server" Visible="false" CssClass="text-center py-8 bg-white border border-[#D5DCE3] rounded-[3px] text-xs text-[#5F6B7A] space-y-2">
            <p class="m-0 font-medium text-[#17212F]">No active quotation requests recorded for this facility.</p>
            <p class="m-0 text-[11px]">Select a replacement spare part from the catalog to issue your initial RFQ.</p>
        </asp:Panel>
    </div>

    <!-- 6. In-Transit Orders & Logistics Tracker -->
    <div class="space-y-4 mb-8 text-left">
        <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-2 border-b border-[#D5DCE3] pb-3">
            <div>
                <h2 class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Purchase Orders &amp; Logistics Tracking</h2>
                <p class="text-xs text-[#5F6B7A] m-0 mt-0.5">Confirmed purchase orders dispatched from stocking regional distributors.</p>
            </div>
            <span class="text-xs font-mono text-[#5F6B7A]">Fulfillment Stream</span>
        </div>

        <div class="table-container shadow-xs">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th class="w-[14%]">Order #</th>
                        <th class="w-[28%]">Fulfilling Supplier</th>
                        <th class="w-[14%]">Order Value</th>
                        <th class="w-[14%]">Tracking Number</th>
                        <th class="w-[14%]">Logistics Status</th>
                        <th class="w-[16%] text-right">Order Date</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#D5DCE3] text-xs">
                    <asp:Repeater ID="rptOrders" runat="server">
                        <ItemTemplate>
                            <tr class="hover:bg-[#F7F8FA] transition-colors">
                                <td class="py-3 px-4 font-mono font-bold text-[#17212F]">
                                    <%# Eval("OrderNumber") %>
                                    <%# Convert.ToBoolean(Eval("IsEmergency")) ? "<span class='text-[10px] text-[#E87519] font-bold block'>EMERGENCY</span>" : "" %>
                                </td>
                                <td class="py-3 px-4 font-medium text-[#17212F]">
                                    <%# Eval("SupplierName") %>
                                </td>
                                <td class="py-3 px-4 font-mono font-bold text-[#17212F]">
                                    &#8377;<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N0") %>
                                </td>
                                <td class="py-3 px-4 font-mono text-[#1769E0]">
                                    <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString())
                                        ? Eval("TrackingNumber")
                                        : "<span class='text-[#5F6B7A]'>Processing</span>" %>
                                </td>
                                <td class="py-3 px-4">
                                    <span class='<%# Eval("OrderStatus").ToString() == "Delivered" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                        <%# Eval("OrderStatus") %>
                                    </span>
                                </td>
                                <td class="py-3 px-4 text-right font-mono text-[#5F6B7A]">
                                    <%# Convert.ToDateTime(Eval("OrderDate")).ToString("dd MMM yyyy") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-8 bg-white border border-[#D5DCE3] rounded-[3px] text-xs text-[#5F6B7A] space-y-2">
            <p class="m-0 font-medium text-[#17212F]">No active purchase orders currently in transit.</p>
            <p class="m-0 text-[11px]">When quotes are approved, purchase orders will update here with real-time tracking.</p>
        </asp:Panel>
    </div>

    <!-- 7. Emergency Breakdown Protocol Status -->
    <div class="space-y-4 mb-8 text-left">
        <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-2 border-b border-[#D5DCE3] pb-3">
            <div>
                <h2 class="text-lg font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">Critical Breakdown Dispatches</h2>
                <p class="text-xs text-[#5F6B7A] m-0 mt-0.5">High-priority emergency alerts broadcasted to nearby verified stockists.</p>
            </div>
            <a href="~/Public/Emergency.aspx" runat="server" class="font-bold text-xs text-[#E87519] hover:underline flex items-center gap-1">
                <i class="fa-solid fa-plus text-[10px]"></i> New Breakdown Broadcast
            </a>
        </div>

        <div class="table-container shadow-xs">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th class="w-[12%]">Dispatch ID</th>
                        <th class="w-[24%]">Affected Machine</th>
                        <th class="w-[28%]">Component / Symptom</th>
                        <th class="w-[12%]">Priority Level</th>
                        <th class="w-[12%]">Desk Status</th>
                        <th class="w-[12%] text-right">Logged At</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#D5DCE3] text-xs">
                    <asp:Repeater ID="rptEmergency" runat="server">
                        <ItemTemplate>
                            <tr class="hover:bg-[#F7F8FA] transition-colors">
                                <td class="py-3 px-4 font-mono font-bold text-[#E87519]">
                                    EMG-<%# Eval("EmergencyRequestId") %>
                                </td>
                                <td class="py-3 px-4 font-bold text-[#17212F]">
                                    <%# Eval("MachineName") %>
                                    <span class="text-[11px] text-[#5F6B7A] block font-mono font-normal"><%# Eval("LocationCity") %></span>
                                </td>
                                <td class="py-3 px-4 text-[#17212F]">
                                    <span class="font-mono text-xs block text-[#1769E0]"><%# Eval("PartNumber") %></span>
                                    <span class="text-[11px] text-[#5F6B7A] line-clamp-1"><%# Eval("BreakdownDescription") %></span>
                                </td>
                                <td class="py-3 px-4">
                                    <span class="status-pill status-pill-emergency text-[11px]">
                                        <i class="fa-solid fa-triangle-exclamation mr-1 text-[9px]"></i> <%# Eval("PriorityLevel") %>
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <span class='<%# Eval("Status").ToString() == "Resolved" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td class="py-3 px-4 text-right font-mono text-[#5F6B7A]">
                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM HH:mm") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <asp:Panel ID="pnlNoEmergency" runat="server" Visible="false" CssClass="text-center py-8 bg-white border border-[#D5DCE3] rounded-[3px] text-xs text-[#5F6B7A] space-y-1">
            <p class="m-0 font-medium text-[#18865B]"><i class="fa-solid fa-circle-check mr-1"></i> No active machine breakdowns currently logged.</p>
            <p class="m-0 text-[11px]">All plant production lines operating under standard monitoring status.</p>
        </asp:Panel>
    </div>

</asp:Content>
