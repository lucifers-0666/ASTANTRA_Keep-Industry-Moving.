<%@ Page Title="Supplier Purchase Orders" Language="C#" MasterPageFile="~/MasterPages/Supplier.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="IndustrialSparePartPortal.Supplier.Orders.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Manage and fulfill industrial purchase orders, consignment dispatches, and tracking waybills." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">CONSIGNMENT FULFILLMENT</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Purchase Orders Fulfillment Hub
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Manage accepted order commitments, dispatch spare parts, and assign courier tracking numbers.
                </p>
            </div>
            <a href="~/Supplier/Dashboard.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-arrow-left mr-1"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
        </div>
    </asp:Panel>

    <!-- Logistics Dispatch Update Panel -->
    <asp:Panel ID="pnlUpdateLogistics" runat="server" Visible="false" CssClass="bg-white rounded-[3px] border border-[#EA580C] p-6 mb-6 shadow-md text-left">
        <div class="flex justify-between items-center mb-4 pb-2 border-b border-[#E2E8F0]">
            <h2 class="text-sm font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Update Fulfillment Status &middot; Order <asp:Label ID="lblOrderNumberDisp" runat="server" Text=""></asp:Label>
            </h2>
            <span class="text-xs text-[#5F6B7A]">Factory: <strong id="lblBuyerCompany" runat="server" class="text-[#17212F]"></strong></span>
        </div>
        <asp:HiddenField ID="hfSelectedOrderId" runat="server" />

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Order Fulfillment Status *</label>
                <asp:DropDownList ID="ddlUpdateStatus" runat="server" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#EA580C]">
                    <asp:ListItem Value="Placed" Text="Placed (Received)"></asp:ListItem>
                    <asp:ListItem Value="Processing" Text="Processing / Packing"></asp:ListItem>
                    <asp:ListItem Value="Shipped" Text="Shipped / In Transit"></asp:ListItem>
                    <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Logistics / Courier Waybill Tracking #</label>
                <asp:TextBox ID="txtTrackingNumber" runat="server" placeholder="e.g. BLUEDART-8829103" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#EA580C] font-mono"></asp:TextBox>
            </div>
        </div>

        <div class="flex gap-2">
            <asp:Button ID="btnSaveLogistics" runat="server" Text="Update Fulfillment Record" OnClick="btnSaveLogistics_Click"
                CssClass="btn-primary text-xs py-2 px-4 font-bold bg-[#EA580C] hover:bg-[#C2410C] cursor-pointer" />
            <asp:Button ID="btnCancelLogistics" runat="server" Text="Cancel" OnClick="btnCancelLogistics_Click"
                CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- Orders Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden text-left">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Purchase Order Log (<asp:Label ID="lblOrdersCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="text-xs px-2.5 py-1.5 border border-[#D5DCE3] rounded-[3px]">
                <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                <asp:ListItem Value="Placed" Text="Placed"></asp:ListItem>
                <asp:ListItem Value="Processing" Text="Processing"></asp:ListItem>
                <asp:ListItem Value="Shipped" Text="Shipped"></asp:ListItem>
                <asp:ListItem Value="Delivered" Text="Delivered"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" DataKeyNames="OrderId,OrderNumber,FactoryName,OrderStatus,TrackingNumber" OnRowCommand="gvOrders_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="OrderNumber" HeaderText="Order Number" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]" />
                <asp:TemplateField HeaderText="Factory Customer" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <div class="font-semibold text-[#17212F]"><%# Eval("FactoryName") %></div>
                        <div class="text-[11px] text-[#5F6B7A]"><%# Eval("FactoryCity") %> &middot; Contact: <%# Eval("ContactPerson") %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total Amount" ItemStyle-CssClass="p-3 font-mono font-bold text-[#17212F]">
                    <ItemTemplate>
                        ₹<%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tracking #" ItemStyle-CssClass="p-3 font-mono text-[11px]">
                    <ItemTemplate>
                        <%# Eval("TrackingNumber") != DBNull.Value && !string.IsNullOrEmpty(Eval("TrackingNumber").ToString()) 
                            ? "<span class='text-blue-600 font-bold'>" + Eval("TrackingNumber") + "</span>" 
                            : "<span class='text-slate-400'>Not Dispatched</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("OrderStatus").ToString() == "Delivered" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("OrderStatus").ToString() == "Shipped" ? "bg-blue-100 text-blue-800 border-blue-300" : "bg-amber-100 text-amber-800 border-amber-300" %> text-[10px]">
                            <%# Eval("OrderStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Placed" ItemStyle-CssClass="p-3 font-mono text-[11px] text-[#5F6B7A]">
                    <ItemTemplate>
                        <%# Convert.ToDateTime(Eval("OrderDate")).ToString("yyyy-MM-dd") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <asp:Button ID="btnManage" runat="server" Text="Update Logistics" CommandName="UpdateOrder" CommandArgument="<%# Container.DataItemIndex %>"
                            CssClass="btn-secondary text-[10px] py-1 px-2.5 font-bold cursor-pointer text-[#1769E0] hover:text-[#1254B7]" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-truck-ramp-box text-3xl mb-2 text-[#CBD5E1]"></i>
                    <p class="text-xs font-semibold">No purchase orders assigned to your supplier account yet.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0">When buyers accept your bids, orders will appear here automatically.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

