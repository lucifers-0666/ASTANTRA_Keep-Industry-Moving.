<%@ Page Title="Compare Quotations" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="Compare.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Quotations.Compare" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Compare supplier bids side-by-side, evaluate unit prices and lead times, and execute binding procurement orders." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header with Back Link -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <a href="~/Factory/Quotations/MyRequests.aspx" runat="server" class="text-xs text-[#1769E0] font-bold hover:underline mb-1 inline-block">
                    &larr; Back to My Requests
                </a>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Commercial Quotation Comparison
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Compare verified vendor pricing, lead times, and terms for RFQ-<asp:Label ID="lblRfqIdHeader" runat="server"></asp:Label>.
                </p>
            </div>
            <div class="flex items-center gap-2">
                <span class="status-pill status-pill-verified text-xs">
                    <i class="fa-solid fa-scale-balanced mr-1"></i> COMPETITIVE BID MATRIX
                </span>
            </div>
        </div>
    </div>

    <!-- RFQ Context Summary Card -->
    <div class="bg-[#F8FAFC] rounded-[3px] border border-[#D5DCE3] p-5 mb-6 text-xs">
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div>
                <span class="block text-[11px] font-bold text-[#5F6B7A] uppercase">Part Number</span>
                <span class="font-mono font-bold text-[#17212F] text-sm" id="lblPartNumber" runat="server">-</span>
            </div>
            <div>
                <span class="block text-[11px] font-bold text-[#5F6B7A] uppercase">Part Name</span>
                <span class="font-semibold text-[#17212F]" id="lblPartName" runat="server">-</span>
            </div>
            <div>
                <span class="block text-[11px] font-bold text-[#5F6B7A] uppercase">Requested Qty</span>
                <span class="font-bold text-[#17212F]" id="lblQuantity" runat="server">-</span>
            </div>
            <div>
                <span class="block text-[11px] font-bold text-[#5F6B7A] uppercase">Target Price</span>
                <span class="font-bold text-[#1769E0]" id="lblTargetPrice" runat="server">-</span>
            </div>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Supplier Bids Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Received Supplier Bids (<asp:Label ID="lblBidCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <span class="text-[11px] text-[#5F6B7A]">Review bids and click "Accept Bid" to generate purchase order</span>
        </div>

        <asp:GridView ID="gvBids" runat="server" AutoGenerateColumns="False" DataKeyNames="ResponseId,SupplierId,OfferedUnitPrice" OnRowCommand="gvBids_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="SupplierCompany" HeaderText="Supplier / Vendor" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="City" HeaderText="Location" ItemStyle-CssClass="p-3 text-[#5F6B7A]" />
                <asp:TemplateField HeaderText="Offered Unit Price" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]">
                    <ItemTemplate>
                        ₹<%# Convert.ToDecimal(Eval("OfferedUnitPrice")).ToString("N2") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Lead Time" ItemStyle-CssClass="p-3 text-center">
                    <ItemTemplate>
                        <span class="font-bold text-[#17212F]"><%# Eval("OfferedLeadTimeDays") %> Days</span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total Value" ItemStyle-CssClass="p-3 font-mono font-bold text-[#17212F]">
                    <ItemTemplate>
                        ₹<%# (Convert.ToDecimal(Eval("OfferedUnitPrice")) * Convert.ToInt32(lblQuantity.InnerText)).ToString("N2") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Comments" HeaderText="Vendor Remarks" ItemStyle-CssClass="p-3 text-[11px] text-[#5F6B7A] max-w-xs truncate" NullDisplayText="-" />
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("Status").ToString() == "Accepted" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("Status").ToString() == "Rejected" ? "bg-red-100 text-red-800 border-red-300" : "bg-blue-100 text-blue-800 border-blue-300" %> text-[10px]">
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="p-3 text-right">
                    <ItemTemplate>
                        <asp:Button ID="btnAcceptBid" runat="server" Text="Accept Bid & Order" CommandName="AcceptBid" CommandArgument='<%# Container.DataItemIndex %>' Visible='<%# Eval("Status").ToString() == "Submitted" %>' CssClass="btn-primary text-[11px] py-1.5 px-3 font-bold cursor-pointer" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-clock-rotate-left text-2xl text-[#94A3B8] mb-2 block"></i>
                    <p class="text-xs font-semibold m-0">No supplier bids received for this RFQ yet.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0 mt-1">Regional stocking suppliers are reviewing the request specifications.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

