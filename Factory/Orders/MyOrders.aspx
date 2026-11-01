<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Orders.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Track procurement purchase orders, logistics tracking numbers, and delivery statuses." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">PURCHASE ORDER FULFILLMENT</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Procurement Purchase Orders
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Track confirmed spare-part purchase orders, regional supplier dispatches, and courier consignment waybills.
                </p>
            </div>
            <a href="~/Factory/SpareParts/Search.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-magnifying-glass mr-1"></i> Browse More Parts
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Quotation accepted and purchase order placed successfully!"></asp:Label>
        </div>
    </asp:Panel>

    <!-- Orders Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Purchase Order Log (<asp:Label ID="lblOrdersCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="text-xs px-2.5 py-1.5 border border-[#D5DCE3] rounded-[3px]">
                <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                <asp:ListItem Value="Placed" Text="Placed (Awaiting Dispatch)"></asp:ListItem>
                <asp:ListItem Value="Processing" Text="Processing"></asp:ListItem>
                <asp:ListItem Value="Shipped" Text="Shipped / In Transit"></asp:ListItem>
                <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" DataKeyNames="OrderId" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="OrderNumber" HeaderText="Order Number" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]" />
                <asp:BoundField DataField="SupplierCompany" HeaderText="Supplier" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="City" HeaderText="Location" ItemStyle-CssClass="p-3 text-[#5F6B7A]" />
                <asp:TemplateField HeaderText="Total Amount" ItemStyle-CssClass="p-3 font-mono font-bold text-[#17212F]">
                    <ItemTemplate>
                        ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Type" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold <%# Convert.ToBoolean(Eval("IsEmergency")) ? "bg-amber-100 text-amber-900 border border-amber-300" : "bg-slate-100 text-slate-700" %>">
                            <%# Convert.ToBoolean(Eval("IsEmergency")) ? "⚡ Emergency" : "Standard RFQ" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tracking #" ItemStyle-CssClass="p-3 font-mono text-[11px]">
                    <ItemTemplate>
                        <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString()) 
                            ? "<span class='text-blue-600 font-bold'>" + Eval("TrackingNumber") + "</span>" 
                            : "<span class='text-slate-400'>Pending Consignment</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("OrderStatus").ToString() == "Delivered" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("OrderStatus").ToString() == "Shipped" ? "bg-blue-100 text-blue-800 border-blue-300" : "bg-amber-100 text-amber-800 border-amber-300" %> text-[10px]">
                            <%# Eval("OrderStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-CssClass="p-3 text-[#5F6B7A] text-[11px]" />
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-truck-ramp-box text-2xl text-[#94A3B8] mb-2 block"></i>
                    <p class="text-xs font-semibold m-0">No purchase orders found.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

