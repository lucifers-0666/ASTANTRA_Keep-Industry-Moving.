<%@ Page Title="Procurement & Emergency SOS Oversight" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Oversight.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Orders.Oversight" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">CROSS-PLATFORM LOGISTICS &amp; INCIDENT TRIAGE</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Procurement Orders &amp; Emergency SOS Console</h1>
            <p class="text-xs text-[#64748B] m-0">System-wide surveillance of active machine breakdown tickets, commercial RFQ negotiation bids, and purchase consignments.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-orange-50 text-orange-800 border border-orange-200">
                <span class="w-2 h-2 rounded-full bg-[#EA580C] animate-pulse"></span> 24/7 RAPID DISPATCH KERNEL
            </span>
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

    <!-- SECTION 1: CRITICAL EMERGENCY BREAKDOWN SOS ALERTS -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-1">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-orange-50/40">
            <div class="flex items-center gap-2">
                <span class="w-2.5 h-2.5 rounded-full bg-[#EA580C] animate-ping"></span>
                <h2 class="text-xs font-bold text-[#EA580C] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i> Critical Breakdown SOS Triage Stream
                </h2>
            </div>
            <span class="text-xs font-mono font-bold text-[#EA580C]">
                Active Incidents: <asp:Label ID="lblEmergencyCount" runat="server" Text="0" CssClass="font-black"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvEmergency" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="EmergencyRequestId,MachineName,PriorityLevel,Status,FactoryCompany" 
            OnRowCommand="gvEmergency_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No active emergency breakdown alerts logged. All industrial plant machinery operating normally.">
            <Columns>
                <asp:BoundField DataField="EmergencyRequestId" HeaderText="SOS #" HeaderStyle-CssClass="w-14 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-[#EA580C]" />
                
                <asp:TemplateField HeaderText="Reporting Facility">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("FactoryCompany") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><i class="fa-solid fa-location-dot mr-1"></i><%# Eval("LocationCity") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Affected Equipment &amp; Symptoms">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-semibold text-xs text-[#0F172A]"><%# Eval("MachineName") %></span>
                            <span class="text-[11px] text-[#475569] max-w-sm truncate"><%# Eval("BreakdownDescription") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Urgency Priority">
                    <ItemTemplate>
                        <span class='<%# Eval("PriorityLevel").ToString() == "Critical" ? "status-pill status-pill-emergency font-bold text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            ⚡ <%# Eval("PriorityLevel") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Triage Status">
                    <ItemTemplate>
                        <span class='<%# Eval("Status").ToString() == "Resolved" ? "status-pill status-pill-verified text-[10px]" : Eval("Status").ToString() == "Dispatched" ? "status-pill status-pill-stock text-[10px]" : "status-pill status-pill-emergency text-[10px]" %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CreatedAt" HeaderText="Logged Time" DataFormatString="{0:dd MMM HH:mm}" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" />

                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnTriage" runat="server" 
                            CommandName="TriageSos" 
                            CommandArgument='<%# Container.DataItemIndex %>' 
                            CssClass="px-2.5 py-1 text-[11px] font-semibold rounded bg-orange-100 hover:bg-orange-200 text-orange-900 border border-orange-300" 
                            ToolTip="Update Triage Status">
                            <i class="fa-solid fa-sliders"></i> Triage
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- SECTION 2: COMMERCIAL RFQ NEGOTIATION MONITOR -->
    <div class="table-container shadow-xs mb-8">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-file-invoice-dollar text-[#1769E0]"></i>
                <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                    Commercial Quotation RFQs &amp; Supplier Bids
                </h2>
            </div>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Active Quotations: <asp:Label ID="lblRfqCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvQuotations" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No active commercial quotation requests logged.">
            <Columns>
                <asp:BoundField DataField="RfqId" HeaderText="RFQ #" HeaderStyle-CssClass="w-14 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-[#1769E0]" />
                <asp:BoundField DataField="FactoryCompany" HeaderText="Buyer Plant" ItemStyle-CssClass="font-bold text-xs" />
                
                <asp:TemplateField HeaderText="Component Requested">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-mono text-xs text-[#1769E0] font-bold"><%# Eval("PartNumber") %></span>
                            <span class="text-[11px] text-[#0F172A]"><%# Eval("PartName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Quantity" HeaderText="Qty" HeaderStyle-CssClass="text-center font-mono" ItemStyle-CssClass="font-mono text-xs text-center font-bold" />
                
                <asp:TemplateField HeaderText="Target Price">
                    <ItemTemplate>
                        <span class="font-mono text-xs text-slate-700">
                            <%# Eval("TargetPrice") != DBNull.Value ? string.Format("₹{0:N0}", Eval("TargetPrice")) : "Open Bid" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Bids Received">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            <%# Eval("ResponseCount") %> Bids Submitted
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="RFQ Status">
                    <ItemTemplate>
                        <span class='<%# Eval("Status").ToString() == "Closed" ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="CreatedAt" HeaderText="Date Issued" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" />
            </Columns>
        </asp:GridView>
    </div>

    <!-- SECTION 3: PURCHASE ORDERS & CONSIGNMENT FULFILLMENT -->
    <div class="table-container shadow-xs">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-truck-fast text-[#059669]"></i>
                <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0">
                    Purchase Consignments &amp; Waybill Tracking
                </h2>
            </div>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total Orders: <asp:Label ID="lblOrdersCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="OrderId,OrderNumber,FactoryCompany,SupplierCompany,TotalAmount,OrderStatus,TrackingNumber" 
            OnRowCommand="gvOrders_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No purchase orders found in the platform.">
            <Columns>
                <asp:BoundField DataField="OrderNumber" HeaderText="Order Number" HeaderStyle-CssClass="font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-[#1769E0]" />
                <asp:BoundField DataField="FactoryCompany" HeaderText="Buyer Plant" ItemStyle-CssClass="font-semibold text-xs text-[#0F172A]" />
                <asp:BoundField DataField="SupplierCompany" HeaderText="Fulfilling Supplier" ItemStyle-CssClass="text-xs text-[#475569]" />
                
                <asp:TemplateField HeaderText="Total Value (₹)">
                    <ItemTemplate>
                        <span class="font-mono font-bold text-xs text-[#059669]">
                            ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Fulfillment Status">
                    <ItemTemplate>
                        <span class='<%# Eval("OrderStatus").ToString() == "Delivered" ? "status-pill status-pill-verified text-[10px]" : Eval("OrderStatus").ToString() == "Shipped" ? "status-pill status-pill-stock text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            <%# Eval("OrderStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Waybill Consignment #">
                    <ItemTemplate>
                        <span class="font-mono text-xs text-[#1E293B]">
                            <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString()) ? Eval("TrackingNumber") : "Not Dispatched" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" />

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEditOrder" runat="server" 
                            CommandName="EditOrder" 
                            CommandArgument='<%# Container.DataItemIndex %>' 
                            CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                            ToolTip="Update Consignment &amp; Waybill">
                            <i class="fa-solid fa-pen-to-square"></i> Status
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- MODAL 1: EMERGENCY SOS TRIAGE STATUS -->
    <asp:Panel ID="pnlSosModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-md p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <asp:HiddenField ID="hdnSosRequestId" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-orange-50 text-[#EA580C] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Triage Emergency Incident</h3>
                </div>
                <asp:LinkButton ID="btnCloseSosModal" runat="server" OnClick="btnCloseSosModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3 text-xs">
                <div class="bg-slate-50 p-3 rounded border border-slate-200 space-y-1">
                    <div>Facility: <strong class="text-[#0F172A]" id="lblSosPlant" runat="server">Plant</strong></div>
                    <div>Equipment: <strong class="text-[#0F172A]" id="lblSosMachine" runat="server">Machine</strong></div>
                    <div>Priority: <strong class="text-[#EA580C]" id="lblSosPriority" runat="server">Critical</strong></div>
                </div>

                <div>
                    <label class="form-label text-xs">Triage Dispatch Status <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlSosStatus" runat="server" CssClass="form-input text-xs py-2 font-semibold">
                        <asp:ListItem Value="Open" Text="Open (Awaiting Technician Response)"></asp:ListItem>
                        <asp:ListItem Value="Dispatched" Text="Dispatched (Technician En Route)"></asp:ListItem>
                        <asp:ListItem Value="InProgress" Text="In Progress (Repair Underway)"></asp:ListItem>
                        <asp:ListItem Value="Resolved" Text="Resolved (Line Restored)"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelSos" runat="server" Text="Cancel" OnClick="btnCloseSosModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSaveSosStatus" runat="server" Text="Update Incident Status" OnClick="btnSaveSosStatus_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>

    <!-- MODAL 2: ORDER STATUS & WAYBILL TRACKING -->
    <asp:Panel ID="pnlOrderModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-md p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <asp:HiddenField ID="hdnOrderId" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-blue-50 text-[#1769E0] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-truck-ramp-box"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Update Consignment Fulfillment</h3>
                </div>
                <asp:LinkButton ID="btnCloseOrderModal" runat="server" OnClick="btnCloseOrderModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3 text-xs">
                <div class="bg-slate-50 p-3 rounded border border-slate-200 space-y-1">
                    <div>Order: <strong class="text-[#1769E0] font-mono" id="lblModalOrderNo" runat="server">ORD-123</strong></div>
                    <div>Buyer: <span id="lblModalBuyer" runat="server">Plant</span></div>
                    <div>Supplier: <span id="lblModalSupplier" runat="server">Vendor</span></div>
                </div>

                <div>
                    <label class="form-label text-xs">Fulfillment Status <span class="text-rose-500">*</span></label>
                    <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="form-input text-xs py-2 font-semibold">
                        <asp:ListItem Value="Placed" Text="Placed (Confirmed by Buyer)"></asp:ListItem>
                        <asp:ListItem Value="Processing" Text="Processing (Stock Packed at Hub)"></asp:ListItem>
                        <asp:ListItem Value="Shipped" Text="Shipped (In Transit)"></asp:ListItem>
                        <asp:ListItem Value="Delivered" Text="Delivered (Received at Plant)"></asp:ListItem>
                        <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div>
                    <label class="form-label text-xs">Consignment Waybill / Tracking Number</label>
                    <asp:TextBox ID="txtTrackingNumber" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="e.g. BLUEDART-88992314" />
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelOrder" runat="server" Text="Cancel" OnClick="btnCloseOrderModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSaveOrderStatus" runat="server" Text="Update Fulfillment" OnClick="btnSaveOrderStatus_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
