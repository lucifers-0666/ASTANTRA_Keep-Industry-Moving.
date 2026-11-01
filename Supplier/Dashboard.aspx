<%@ Page Title="Supplier Operations Dashboard" Language="C#" MasterPageFile="~/MasterPages/Supplier.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Supplier.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Supplier Greeting & Alert Header -->
    <div class="surface-card bg-[#0F172A] text-white p-7 sm:p-9 mb-8 border-slate-700 shadow-lg text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
            <div class="space-y-1.5 text-left">
                <span class="spec-tag spec-tag-emerald text-[10px]">SUPPLIER INVENTORY &amp; BIDDING</span>
                <h1 class="text-2xl font-black text-white tracking-tight m-0">Welcome back, <span id="lblSupplierCompany" runat="server" class="text-emerald-400">Industrial Stockist</span></h1>
                <p class="text-xs text-slate-300 m-0 max-w-xl leading-relaxed">Update physical stock quantities, submit quotation responses, and fulfill emergency breakdown sourcing broadcasts.</p>
            </div>
            <div class="flex flex-wrap gap-2.5 shrink-0">
                <a href="~/Supplier/Inventory/ManageParts.aspx" runat="server" class="btn-primary text-xs py-2.5 px-4 font-bold bg-[#059669] hover:bg-[#047857]">
                    <i class="fa-solid fa-boxes-stacked"></i> Manage Inventory
                </a>
                <a href="~/Supplier/Quotations/IncomingRequests.aspx" runat="server" class="btn-primary text-xs py-2.5 px-4 font-bold bg-[#1769E0] hover:bg-[#1254B7]">
                    <i class="fa-solid fa-file-invoice-dollar"></i> Incoming RFQs
                </a>
                <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2.5 px-4 font-bold">
                    <i class="fa-solid fa-bell"></i> Emergency Alerts
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Stat Metrics -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8 text-left">
        <div class="surface-card p-5 border-l-4 border-l-[#059669] space-y-1">
            <span class="text-[11px] font-mono uppercase text-[#64748B] block">Listed Inventory Items</span>
            <span class="text-2xl font-black text-[#0F172A] font-mono block">
                <asp:Label ID="lblInventoryCount" runat="server" Text="0"></asp:Label>
            </span>
            <span class="text-[11px] text-[#059669] font-mono font-bold block">In Stock &amp; Active</span>
        </div>

        <div class="surface-card p-5 border-l-4 border-l-[#B45309] space-y-1">
            <span class="text-[11px] font-mono uppercase text-[#64748B] block">Incoming RFQs</span>
            <span class="text-2xl font-black text-[#0F172A] font-mono block">
                <asp:Label ID="lblIncomingRfqs" runat="server" Text="0"></asp:Label>
            </span>
            <span class="text-[11px] text-[#B45309] font-mono font-bold block">Open RFQs</span>
        </div>

        <div class="surface-card p-5 border-l-4 border-l-[#EA580C] space-y-1">
            <span class="text-[11px] font-mono uppercase text-[#64748B] block">Breakdown Alerts</span>
            <span class="text-2xl font-black text-[#EA580C] font-mono block">
                <asp:Label ID="lblBreakdownAlerts" runat="server" Text="0"></asp:Label>
            </span>
            <span class="text-[11px] text-[#EA580C] font-mono font-bold block">Critical SOS Alerts</span>
        </div>

        <div class="surface-card p-5 border-l-4 border-l-[#1D4ED8] space-y-1">
            <span class="text-[11px] font-mono uppercase text-[#64748B] block">Orders to Fulfill</span>
            <span class="text-2xl font-black text-[#0F172A] font-mono block">
                <asp:Label ID="lblOrdersToFulfill" runat="server" Text="0"></asp:Label>
            </span>
            <span class="text-[11px] text-[#1D4ED8] font-mono font-bold block">Awaiting Dispatch</span>
        </div>
    </div>

    <!-- Quick Navigation Hub -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8 text-left">
        <a href="~/Supplier/Inventory/ManageParts.aspx" runat="server" class="surface-card p-6 hover:border-[#059669] transition duration-150 block group">
            <div class="flex items-center gap-3 mb-3">
                <div class="w-10 h-10 rounded-[3px] bg-emerald-50 text-[#059669] flex items-center justify-center font-bold text-lg group-hover:bg-[#059669] group-hover:text-white transition">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-[#17212F] m-0">Inventory Catalog</h3>
                    <span class="text-[11px] text-[#5F6B7A]">Update unit prices, quantities &amp; lead times</span>
                </div>
            </div>
            <p class="text-xs text-[#5F6B7A] m-0">Ensure your parts have accurate stock counts and lead times to receive high buyer match ratings.</p>
        </a>

        <a href="~/Supplier/Quotations/IncomingRequests.aspx" runat="server" class="surface-card p-6 hover:border-[#1769E0] transition duration-150 block group">
            <div class="flex items-center gap-3 mb-3">
                <div class="w-10 h-10 rounded-[3px] bg-blue-50 text-[#1769E0] flex items-center justify-center font-bold text-lg group-hover:bg-[#1769E0] group-hover:text-white transition">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-[#17212F] m-0">Incoming RFQs</h3>
                    <span class="text-[11px] text-[#5F6B7A]">Submit quotation bids to factories</span>
                </div>
            </div>
            <p class="text-xs text-[#5F6B7A] m-0">Review open procurement requests from manufacturing plants and submit competitive commercial offers.</p>
        </a>

        <a href="~/Supplier/Orders/ManageOrders.aspx" runat="server" class="surface-card p-6 hover:border-[#EA580C] transition duration-150 block group">
            <div class="flex items-center gap-3 mb-3">
                <div class="w-10 h-10 rounded-[3px] bg-orange-50 text-[#EA580C] flex items-center justify-center font-bold text-lg group-hover:bg-[#EA580C] group-hover:text-white transition">
                    <i class="fa-solid fa-truck-fast"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-[#17212F] m-0">Purchase Orders</h3>
                    <span class="text-[11px] text-[#5F6B7A]">Logistics tracking &amp; fulfillment</span>
                </div>
            </div>
            <p class="text-xs text-[#5F6B7A] m-0">Track accepted quotations, dispatch consignments, and update courier tracking numbers.</p>
        </a>
    </div>
</asp:Content>

