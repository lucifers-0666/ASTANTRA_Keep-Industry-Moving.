<%@ Page Title="Commercial Quotation Comparison" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Compare.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Quotations.Compare" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Compare supplier bids side-by-side, evaluate unit prices and lead times, and execute binding procurement orders." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header with Back Link -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <a href="~/Factory/Quotations/MyRequests.aspx" runat="server" class="text-xs text-[#1769E0] font-bold hover:underline mb-1 inline-block font-mono">
                    &larr; Back to My RFQ Ledger
                </a>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Commercial Quotation Comparison
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1">
                    Evaluate verified supplier bids, compare offered unit pricing and delivery SLA for 
                    <strong class="text-slate-800 font-mono">RFQ-<asp:Label ID="lblRfqIdHeader" runat="server"></asp:Label></strong>.
                </p>
            </div>
            <div class="flex items-center gap-2">
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200">
                    <i class="fa-solid fa-scale-balanced mr-1 text-[9px]"></i> Competitive Matrix
                </span>
            </div>
        </div>
    </div>

    <!-- RFQ Summary Card -->
    <div class="factory-card mb-6">
        <div class="p-4 bg-slate-50 border-b border-slate-200">
            <span class="text-xs font-mono font-bold uppercase text-slate-700">Requisition Parameters &amp; Requirements</span>
        </div>
        <div class="p-5 grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs">
            <div>
                <span class="block text-[10px] font-mono font-bold uppercase text-slate-400">Part Number</span>
                <span class="font-mono font-bold text-slate-900 text-sm" id="lblPartNumber" runat="server">-</span>
            </div>
            <div>
                <span class="block text-[10px] font-mono font-bold uppercase text-slate-400">Component Name</span>
                <span class="font-bold text-slate-900 text-sm" id="lblPartName" runat="server">-</span>
            </div>
            <div>
                <span class="block text-[10px] font-mono font-bold uppercase text-slate-400">Requested Quantity</span>
                <span class="font-mono font-bold text-[#1769E0] text-sm" id="lblQuantity" runat="server">-</span>
                <span class="text-slate-400 text-[10px]"> Units</span>
            </div>
            <div>
                <span class="block text-[10px] font-mono font-bold uppercase text-slate-400">Target Budget</span>
                <span class="font-mono font-bold text-slate-900 text-sm" id="lblTargetPrice" runat="server">-</span>
            </div>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-rose-50 border border-rose-300 text-xs text-rose-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-triangle-exclamation text-rose-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Supplier Bids Grid -->
    <div class="factory-card overflow-hidden">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
            <h2 class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 m-0">
                Received Supplier Quotations (<asp:Label ID="lblBidCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <span class="text-[11px] text-slate-500 font-mono">Accepting a quote atomically issues an official Purchase Order</span>
        </div>

        <div class="overflow-x-auto">
            <asp:GridView ID="gvBids" runat="server" AutoGenerateColumns="False" DataKeyNames="ResponseId,SupplierId,OfferedUnitPrice" OnRowCommand="gvBids_RowCommand" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Supplier / Vendor">
                        <ItemTemplate>
                            <strong class="text-slate-900 block font-medium"><%# Eval("SupplierCompany") %></strong>
                            <span class="text-slate-400 font-mono text-[11px]"><%# Eval("City") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Offered Unit Price" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]">
                        <ItemTemplate>
                            ₹<%# Convert.ToDecimal(Eval("OfferedUnitPrice")).ToString("N0") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delivery Lead Time" ItemStyle-CssClass="text-center font-mono">
                        <ItemTemplate>
                            <span class="font-bold text-slate-800"><%# Eval("OfferedLeadTimeDays") %> Days</span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total Order Value" ItemStyle-CssClass="font-mono font-bold text-slate-900">
                        <ItemTemplate>
                            ₹<%# (Convert.ToDecimal(Eval("OfferedUnitPrice")) * Convert.ToInt32(lblQuantity.InnerText)).ToString("N0") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Comments" HeaderText="Commercial Notes" ItemStyle-CssClass="text-[11px] text-slate-500 max-w-xs truncate" NullDisplayText="Standard commercial terms" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge-status <%# Eval("Status").ToString() == "Accepted" ? "badge-delivered" : (Eval("Status").ToString() == "Rejected" ? "badge-offline" : "badge-pending") %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Procurement Action" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <asp:Button ID="btnAcceptBid" runat="server" Text="Accept Bid &amp; Issue PO" CommandName="AcceptBid" CommandArgument='<%# Container.DataItemIndex %>' 
                                        Visible='<%# Eval("Status").ToString() == "Submitted" %>' 
                                        OnClientClick="return confirm('Are you sure you want to accept this quotation and generate an official purchase order? This action is binding.');"
                                        CssClass="btn-primary text-xs py-1.5 px-3.5" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-clock-rotate-left text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No supplier bids received for this RFQ yet.</p>
                        <span class="text-[11px] text-slate-400">Regional stocking distributors are reviewing the requested specifications.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
