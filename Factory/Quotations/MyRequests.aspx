<%@ Page Title="My Quotation Requests" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="MyRequests.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Quotations.MyRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="View and manage submitted RFQs, track supplier quotation progress, and compare incoming commercial bids." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">COMMERCIAL RFQ MANAGEMENT</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    My Quotation Requests
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Monitor issued RFQs, check regional supplier quote activity, and compare binding price offers.
                </p>
            </div>
            <a href="~/Factory/SpareParts/Search.aspx" runat="server" class="btn-primary text-xs py-2 px-4 font-bold">
                <i class="fa-solid fa-plus mr-1"></i> New Request (RFQ)
            </a>
        </div>
    </div>

    <!-- Requests Table -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden">
        <div class="p-4 border-b border-[#D5DCE3] flex justify-between items-center bg-[#FAFAFA]">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Active & Historical RFQs (<asp:Label ID="lblRequestsCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="text-xs px-2.5 py-1.5 border border-[#D5DCE3] rounded-[3px]">
                <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                <asp:ListItem Value="Quoted" Text="Quoted (Offers Available)"></asp:ListItem>
                <asp:ListItem Value="Accepted" Text="Accepted"></asp:ListItem>
                <asp:ListItem Value="Closed" Text="Closed"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:GridView ID="gvRequests" runat="server" AutoGenerateColumns="False" DataKeyNames="RfqId" OnRowCommand="gvRequests_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:TemplateField HeaderText="RFQ #" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]">
                    <ItemTemplate>
                        RFQ-<%# Convert.ToInt32(Eval("RfqId")).ToString("D5") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="p-3 font-mono text-[#17212F]" />
                <asp:BoundField DataField="PartName" HeaderText="Part Description" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-CssClass="p-3 text-center" />
                <asp:TemplateField HeaderText="Target Price" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <%# Eval("TargetPrice") != DBNull.Value ? "₹" + Convert.ToDecimal(Eval("TargetPrice")).ToString("N2") : "<span class='text-slate-400'>Open</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Supplier Bids" ItemStyle-CssClass="p-3 text-center">
                    <ItemTemplate>
                        <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-bold <%# Convert.ToInt32(Eval("BidCount")) > 0 ? "bg-blue-100 text-blue-800" : "bg-slate-100 text-slate-600" %>">
                            <%# Eval("BidCount") %> Quotes
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("Status").ToString() == "Pending" ? "bg-amber-100 text-amber-800 border-amber-300" : Eval("Status").ToString() == "Quoted" ? "bg-blue-100 text-blue-800 border-blue-300" : "bg-emerald-100 text-emerald-800 border-emerald-300" %> text-[10px]">
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Issued Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-CssClass="p-3 text-[#5F6B7A] text-[11px]" />
                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="p-3 text-right">
                    <ItemTemplate>
                        <asp:Button ID="btnCompare" runat="server" Text="Compare Quotes" CommandName="CompareBids" CommandArgument='<%# Eval("RfqId") %>' Visible='<%# Convert.ToInt32(Eval("BidCount")) > 0 %>' CssClass="btn-primary text-[11px] py-1 px-2.5 font-bold cursor-pointer" />
                        <span class="text-[11px] text-[#94A3B8]" style='<%# Convert.ToInt32(Eval("BidCount")) == 0 ? "" : "display:none;" %>'>Awaiting Bids</span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-file-invoice text-2xl text-[#94A3B8] mb-2 block"></i>
                    <p class="text-xs font-semibold m-0">No quotation requests found for this filter.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

