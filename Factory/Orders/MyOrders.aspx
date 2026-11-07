<%@ Page Title="Purchase Orders &amp; Logistics" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Orders.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Track procurement purchase orders, logistics tracking numbers, and delivery statuses." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Command Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-boxes-packing mr-1"></i> Order Fulfillment Stream
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Procurement Purchase Orders
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Track confirmed spare-part purchase orders, regional supplier dispatches, itemized B2B invoices, and courier consignment waybills.
                </p>
            </div>
            <a href="~/Factory/SpareParts/Search.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-magnifying-glass mr-1"></i> Browse Parts Catalog &rarr;
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Quotation accepted and purchase order placed successfully!"></asp:Label>
        </div>
    </asp:Panel>

    <!-- Orders Filter & Table Card -->
    <div class="factory-card mb-6">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex flex-col sm:flex-row justify-between sm:items-center gap-3">
            <div class="flex items-center gap-3">
                <span class="text-xs font-mono font-bold uppercase text-slate-700">Purchase Order Log</span>
                <span class="text-xs text-slate-400 font-mono">Total: <strong id="lblOrdersCount" runat="server" class="text-slate-800">0</strong> orders</span>
            </div>
            <div class="flex items-center gap-2">
                <label class="text-xs text-slate-500 font-medium" for="<%= ddlStatusFilter.ClientID %>">Filter Status:</label>
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="form-select text-xs py-1.5 px-3">
                    <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                    <asp:ListItem Value="Placed" Text="Placed (Awaiting Dispatch)"></asp:ListItem>
                    <asp:ListItem Value="Processing" Text="Processing / Packing"></asp:ListItem>
                    <asp:ListItem Value="Shipped" Text="Shipped / In Transit"></asp:ListItem>
                    <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="overflow-x-auto">
            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" DataKeyNames="OrderId" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="OrderNumber" HeaderText="Order Number" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]" />
                    <asp:TemplateField HeaderText="Fulfilling Supplier">
                        <ItemTemplate>
                            <strong class="text-slate-900 block font-medium"><%# Eval("SupplierCompany") %></strong>
                            <span class="text-slate-400 font-mono text-[11px]"><%# Eval("City") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total Amount" ItemStyle-CssClass="font-mono font-bold text-slate-900">
                        <ItemTemplate>
                            ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N0") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Type">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-mono font-bold <%# Convert.ToBoolean(Eval("IsEmergency")) ? "bg-orange-100 text-orange-800 border border-orange-300" : "bg-slate-100 text-slate-700 border border-slate-200" %>">
                                <%# Convert.ToBoolean(Eval("IsEmergency")) ? "⚡ SOS Emergency" : "Standard RFQ" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tracking Number" ItemStyle-CssClass="font-mono text-[11px]">
                        <ItemTemplate>
                            <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString()) 
                                ? "<span class='text-blue-700 font-bold'><i class='fa-solid fa-truck-fast mr-1'></i>" + Eval("TrackingNumber") + "</span>" 
                                : "<span class='text-slate-400'>Pending Consignment</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge-status <%# Eval("OrderStatus").ToString() == "Delivered" ? "badge-delivered" : (Eval("OrderStatus").ToString() == "Shipped" ? "badge-shipped" : "badge-pending") %>'>
                                <%# Eval("OrderStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="text-slate-500 font-mono text-[11px]" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <a href='<%# ResolveUrl(string.Format("~/Factory/Orders/OrderDetails.aspx?orderId={0}", Eval("OrderId"))) %>' 
                               class="btn-secondary text-[11px] py-1 px-2.5 font-bold">
                                View PO &amp; Invoice &rarr;
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-truck-ramp-box text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No purchase orders found for this status.</p>
                        <span class="text-[11px] text-slate-400">When quotation bids are accepted, orders appear here with logistics tracking.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
