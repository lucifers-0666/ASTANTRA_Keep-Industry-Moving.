<%@ Page Title="Purchase Order Details &amp; Tax Invoice" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Orders.OrderDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="View comprehensive B2B purchase order specification, itemized bill of materials, logistics tracking, and printable tax invoice." />
    <style>
        @media print {
            body {
                background: white !important;
                color: #0f172a !important;
            }
            .no-print, header, nav, footer, .sidebar, #top-bar, .factory-sidebar {
                display: none !important;
            }
            .print-full {
                width: 100% !important;
                max-width: 100% !important;
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                margin: 0 !important;
            }
            .invoice-sheet {
                border: 1px solid #94a3b8 !important;
                box-shadow: none !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Command Toolbar (Hidden in Print) -->
    <div class="no-print bg-white rounded-lg border border-[#CBD5E1] p-4 mb-6 shadow-xs text-left">
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div class="flex items-center gap-3">
                <a href="MyOrders.aspx" class="inline-flex items-center gap-1.5 text-xs font-semibold text-slate-600 hover:text-slate-900 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded border border-slate-300">
                    <i class="fa-solid fa-arrow-left"></i> Back to Orders
                </a>
                <span class="text-slate-300">|</span>
                <span class="text-xs font-mono text-slate-500 font-medium">Order Inspection &amp; Tax Invoice</span>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="window.print();" class="btn-secondary text-xs py-1.5 px-3 flex items-center gap-1.5">
                    <i class="fa-solid fa-print"></i> Print Invoice (A4)
                </button>
            </div>
        </div>
    </div>

    <!-- Alert / Success Notification -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="no-print p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Purchase Order generated successfully."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Error / Not Found Panel -->
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="factory-card p-12 text-center">
        <i class="fa-solid fa-file-circle-xmark text-4xl text-rose-400 mb-3 block"></i>
        <h2 class="text-base font-bold text-slate-800 m-0">Purchase Order Not Found or Access Restricted</h2>
        <p class="text-xs text-slate-500 mt-1 max-w-md mx-auto">
            The requested order ID does not exist, or does not belong to your manufacturing plant tenant account.
        </p>
        <div class="mt-4">
            <a href="MyOrders.aspx" class="btn-primary text-xs px-4 py-2 inline-block">Return to My Orders</a>
        </div>
    </asp:Panel>

    <!-- Printable Invoice Container -->
    <asp:Panel ID="pnlOrderInvoice" runat="server" Visible="true" CssClass="print-full">
        <div class="factory-card invoice-sheet p-6 sm:p-8 mb-6 bg-white border border-slate-300 rounded-lg shadow-sm">
            <!-- Invoice Header -->
            <div class="flex flex-col sm:flex-row justify-between items-start pb-6 border-b border-slate-200 gap-4">
                <div>
                    <div class="flex items-center gap-2 mb-1">
                        <span class="w-6 h-6 rounded bg-[#1769E0] text-white flex items-center justify-center font-black text-xs font-['Archivo']">A</span>
                        <span class="text-lg font-black tracking-tight font-['Archivo'] text-slate-900">ASTANTRA</span>
                        <span class="text-[10px] font-mono uppercase bg-slate-100 text-slate-700 px-1.5 py-0.5 rounded border border-slate-200">B2B Procurement</span>
                    </div>
                    <p class="text-[11px] text-slate-500 m-0">Industrial Spare Parts &amp; Critical Maintenance Network</p>
                    <p class="text-[11px] text-slate-400 font-mono m-0 mt-0.5">GST Reg: 24AAACA0000A1Z5 &middot; CIN: U29253GJ2024PTC000000</p>
                </div>
                <div class="text-left sm:text-right">
                    <span class="text-[10px] font-mono uppercase text-slate-400 font-bold block">Purchase Order &amp; Proforma Invoice</span>
                    <h1 class="text-xl sm:text-2xl font-black font-mono text-[#1769E0] m-0" id="lblOrderNumber" runat="server">
                        PO-00000
                    </h1>
                    <div class="mt-1 space-y-0.5 text-xs">
                        <p class="text-slate-600 m-0"><strong>Order Date:</strong> <span id="lblOrderDate" runat="server">-</span></p>
                        <p class="text-slate-600 m-0"><strong>Fulfillment Status:</strong> <span id="lblOrderStatusBadge" runat="server" class="badge-status badge-pending">Pending</span></p>
                    </div>
                </div>
            </div>

            <!-- Entities: Buyer & Supplier Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 my-6 pt-2">
                <!-- Buyer Plant -->
                <div class="p-4 rounded border border-slate-200 bg-slate-50">
                    <span class="text-[10px] font-mono uppercase font-bold text-slate-500 block mb-1">
                        <i class="fa-solid fa-building mr-1 text-slate-400"></i> Consignee / Buyer Plant
                    </span>
                    <h3 class="text-sm font-bold text-slate-900 m-0" id="lblFactoryName" runat="server">-</h3>
                    <p class="text-xs text-slate-600 mt-1 mb-2" id="lblFactoryAddress" runat="server">-</p>
                    <div class="text-[11px] font-mono text-slate-600 space-y-0.5 border-t border-slate-200 pt-2">
                        <div><strong>GSTIN:</strong> <span id="lblFactoryGstin" runat="server">-</span></div>
                        <div><strong>Contact Officer:</strong> <span id="lblFactoryContact" runat="server">-</span></div>
                        <div><strong>Phone:</strong> <span id="lblFactoryPhone" runat="server">-</span></div>
                    </div>
                </div>

                <!-- Supplier Vendor -->
                <div class="p-4 rounded border border-slate-200 bg-slate-50">
                    <span class="text-[10px] font-mono uppercase font-bold text-slate-500 block mb-1">
                        <i class="fa-solid fa-truck-ramp-box mr-1 text-slate-400"></i> Contracted Spare-Part Supplier
                    </span>
                    <h3 class="text-sm font-bold text-slate-900 m-0" id="lblSupplierName" runat="server">-</h3>
                    <p class="text-xs text-slate-600 mt-1 mb-2" id="lblSupplierAddress" runat="server">-</p>
                    <div class="text-[11px] font-mono text-slate-600 space-y-0.5 border-t border-slate-200 pt-2">
                        <div><strong>GSTIN:</strong> <span id="lblSupplierGstin" runat="server">-</span></div>
                        <div><strong>Key Account Rep:</strong> <span id="lblSupplierContact" runat="server">-</span></div>
                        <div><strong>Email:</strong> <span id="lblSupplierEmail" runat="server">-</span></div>
                    </div>
                </div>
            </div>

            <!-- Itemized Line Items Table -->
            <div class="mb-6">
                <div class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 mb-2">
                    Itemized Bill of Materials &amp; Procurement Line Items
                </div>

                <div class="overflow-x-auto border border-slate-200 rounded">
                    <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False" CssClass="factory-table" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="#" ItemStyle-CssClass="font-mono text-slate-500 text-xs w-12 text-center">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Part Number" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]">
                                <ItemTemplate>
                                    <%# Eval("PartNumber") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Description &amp; Specifications">
                                <ItemTemplate>
                                    <strong class="text-slate-900 block font-medium"><%# Eval("PartName") %></strong>
                                    <span class="text-slate-400 font-mono text-[11px]">
                                        Category: <%# Eval("CategoryName") %> &middot; Specs: <%# Eval("TechnicalSpecs") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-CssClass="font-mono text-center font-bold text-slate-800" />
                            <asp:TemplateField HeaderText="Unit Price (₹)" ItemStyle-CssClass="font-mono text-right text-slate-700">
                                <ItemTemplate>
                                    ₹<%# Convert.ToDecimal(Eval("UnitPrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Total (₹)" ItemStyle-CssClass="font-mono font-bold text-right text-slate-900">
                                <ItemTemplate>
                                    ₹<%# Convert.ToDecimal(Eval("TotalPrice")).ToString("N2") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Financial Calculation & Totals -->
            <div class="flex flex-col sm:flex-row justify-between items-start pt-4 border-t border-slate-200 gap-6">
                <!-- Shipping / Logistics Info -->
                <div class="flex-1 text-xs space-y-2">
                    <div class="p-3 bg-slate-50 border border-slate-200 rounded max-w-md">
                        <span class="text-[10px] font-mono uppercase font-bold text-slate-500 block mb-1">
                            <i class="fa-solid fa-location-dot mr-1 text-blue-600"></i> Registered Consignment Destination
                        </span>
                        <p class="text-slate-700 m-0" id="lblShippingAddress" runat="server">-</p>
                    </div>

                    <div class="p-3 bg-blue-50/60 border border-blue-200 rounded max-w-md flex items-center justify-between">
                        <div>
                            <span class="text-[10px] font-mono uppercase font-bold text-blue-800 block">Consignment Tracking Waybill</span>
                            <span class="font-mono font-bold text-xs text-slate-800" id="lblTrackingNumber" runat="server">
                                Awaiting Vendor Waybill
                            </span>
                        </div>
                        <i class="fa-solid fa-truck-fast text-blue-500 text-lg"></i>
                    </div>
                </div>

                <!-- Financial Ledger Box -->
                <div class="w-full sm:w-72 bg-slate-50 p-4 rounded border border-slate-200 text-xs">
                    <div class="flex justify-between py-1 border-b border-slate-200 text-slate-600">
                        <span>Net Taxable Value:</span>
                        <strong class="font-mono" id="lblSubTotal" runat="server">₹0.00</strong>
                    </div>
                    <div class="flex justify-between py-1 border-b border-slate-200 text-slate-600">
                        <span>GST / Taxes (18% B2B):</span>
                        <strong class="font-mono" id="lblTaxAmount" runat="server">₹0.00</strong>
                    </div>
                    <div class="flex justify-between py-2 text-sm font-black text-slate-900">
                        <span>Grand Total (INR):</span>
                        <span class="font-mono text-[#1769E0]" id="lblGrandTotal" runat="server">₹0.00</span>
                    </div>
                    <div class="text-[10px] text-slate-400 font-mono mt-1 text-right">
                        Prices inclusive of standard B2B freight &amp; handling.
                    </div>
                </div>
            </div>

            <!-- Legal & Certification Terms -->
            <div class="mt-8 pt-6 border-t border-slate-200 text-[11px] text-slate-400 leading-relaxed">
                <p class="m-0">
                    <strong>Standard ASTANTRA B2B Terms:</strong> Goods inspected and dispatched as per OEM technical specifications. Replacement warranty applies against manufacturing defects within 90 days of plant delivery receipt.
                </p>
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mt-4 pt-4 border-t border-dashed border-slate-200 text-[10px] font-mono">
                    <span>Generated automatically via ASTANTRA Industrial Core v2.4</span>
                    <span class="mt-1 sm:mt-0">Certified Digital Commercial PO Document</span>
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
