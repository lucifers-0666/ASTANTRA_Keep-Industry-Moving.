<%@ Page Title="Incoming RFQ Quotation Requests" Language="C#" MasterPageFile="~/MasterPages/Supplier.Master" AutoEventWireup="true" CodeBehind="IncomingRequests.aspx.cs" Inherits="IndustrialSparePartPortal.Supplier.Quotations.IncomingRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Review open RFQs from manufacturing plants and submit competitive quotation bids." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">COMMERCIAL BIDDING &amp; RFQs</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Incoming Factory RFQ Broadcasts
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Review open equipment spare-part requests from verified manufacturing plants and submit binding quotation bids.
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

    <!-- Bid Submission Form Panel -->
    <asp:Panel ID="pnlSubmitBid" runat="server" Visible="false" CssClass="bg-white rounded-[3px] border border-[#1769E0] p-6 mb-6 shadow-md text-left">
        <div class="flex justify-between items-center mb-4 pb-2 border-b border-[#E2E8F0]">
            <h2 class="text-sm font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Submit Formal Quotation Bid &middot; RFQ #<asp:Label ID="lblBidRfqId" runat="server" Text=""></asp:Label>
            </h2>
            <span class="text-xs text-[#5F6B7A]">Part: <strong id="lblBidPartInfo" runat="server" class="text-[#17212F]"></strong></span>
        </div>
        <asp:HiddenField ID="hfSelectedRfqId" runat="server" />

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 mb-4">
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Offered Unit Price (₹) *</label>
                <asp:TextBox ID="txtOfferedPrice" runat="server" placeholder="e.g. 3850.00" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0] font-mono"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Dispatch Lead Time (Days) *</label>
                <asp:TextBox ID="txtBidLeadTime" runat="server" Text="3" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0] font-mono"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Offer Validity Date</label>
                <asp:TextBox ID="txtValidityDate" runat="server" TextMode="Date" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0] font-mono"></asp:TextBox>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Commercial Notes / Warranty</label>
                <asp:TextBox ID="txtBidComments" runat="server" placeholder="OEM 1-year replacement warranty..." CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0]"></asp:TextBox>
            </div>
        </div>

        <div class="flex gap-2">
            <asp:Button ID="btnSubmitBidAction" runat="server" Text="Confirm &amp; Transmit Quotation" OnClick="btnSubmitBidAction_Click"
                CssClass="btn-primary text-xs py-2 px-4 font-bold bg-[#1769E0] hover:bg-[#1254B7] cursor-pointer" />
            <asp:Button ID="btnCancelBid" runat="server" Text="Cancel" OnClick="btnCancelBid_Click"
                CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- RFQ Broadcasts Table -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden text-left">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Open Sourcing Broadcasts (<asp:Label ID="lblRfqCount" runat="server" Text="0"></asp:Label>)
            </h2>
        </div>

        <asp:GridView ID="gvRfqs" runat="server" AutoGenerateColumns="False" DataKeyNames="RfqId,PartNumber,PartName" OnRowCommand="gvRfqs_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="RfqId" HeaderText="RFQ #" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]" />
                <asp:TemplateField HeaderText="Requested Spare Part" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <div class="font-bold text-[#17212F]"><%# Eval("PartName") %></div>
                        <div class="font-mono text-[11px] text-[#5F6B7A]"><%# Eval("PartNumber") %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Quantity" HeaderText="Qty Needed" ItemStyle-CssClass="p-3 font-mono font-bold text-[#17212F]" />
                <asp:TemplateField HeaderText="Target Price" ItemStyle-CssClass="p-3 font-mono text-[#5F6B7A]">
                    <ItemTemplate>
                        <%# Eval("TargetPrice") != DBNull.Value && Eval("TargetPrice") != null 
                            ? "₹" + Convert.ToDecimal(Eval("TargetPrice")).ToString("N2") 
                            : "<span class='text-slate-400'>Open / Market</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Factory Plant" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <div class="font-semibold text-[#17212F]"><%# Eval("FactoryName") %></div>
                        <div class="text-[11px] text-[#5F6B7A]"><%# Eval("FactoryCity") %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Required By" ItemStyle-CssClass="p-3 font-mono text-[11px] text-[#5F6B7A]">
                    <ItemTemplate>
                        <%# Eval("RequiredByDate") != DBNull.Value ? Convert.ToDateTime(Eval("RequiredByDate")).ToString("yyyy-MM-dd") : "Immediate" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Your Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <%# Convert.ToInt32(Eval("HasQuoted")) > 0 
                            ? "<span class='status-pill bg-emerald-100 text-emerald-800 border-emerald-300 text-[10px]'><i class='fa-solid fa-check mr-1'></i> Bid Submitted</span>" 
                            : "<span class='status-pill bg-amber-100 text-amber-800 border-amber-300 text-[10px]'>Pending Quote</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <asp:Button ID="btnQuote" runat="server" Text="Submit Bid" CommandName="PrepareBid" CommandArgument="<%# Container.DataItemIndex %>"
                            CssClass="btn-primary text-[10px] py-1 px-3 font-bold bg-[#1769E0] hover:bg-[#1254B7] cursor-pointer" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-file-invoice text-3xl mb-2 text-[#CBD5E1]"></i>
                    <p class="text-xs font-semibold">No open RFQ broadcasts at this time.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0">When factories publish procurement requests, they will appear here automatically.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

