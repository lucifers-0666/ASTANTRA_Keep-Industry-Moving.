<%@ Page Title="My Quotation Requests" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="MyRequests.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Quotations.MyRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="View and manage submitted RFQs, track supplier quotation progress, and compare incoming commercial bids." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Command Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-file-invoice mr-1"></i> Requisition Management
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    My Quotation Requests (RFQs)
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Monitor commercial RFQs broadcasted to verified suppliers, evaluate incoming competitive quotes, and award purchase orders.
                </p>
            </div>
            <a href="~/Factory/SpareParts/Search.aspx" runat="server" class="btn-primary text-xs py-2 px-3.5 font-bold">
                <i class="fa-solid fa-plus mr-1"></i> Issue New RFQ &rarr;
            </a>
        </div>
    </div>

    <!-- Filter & Toolbar -->
    <div class="factory-card mb-6">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex flex-col sm:flex-row justify-between sm:items-center gap-3">
            <div class="flex items-center gap-3">
                <span class="text-xs font-mono font-bold uppercase text-slate-700">Filter RFQ Ledger</span>
                <span class="text-xs text-slate-400 font-mono">Found: <strong id="lblRequestsCount" runat="server" class="text-slate-800">0</strong> requisitions</span>
            </div>
            <div class="flex items-center gap-2">
                <label class="text-xs text-slate-500 font-medium" for="<%= ddlStatusFilter.ClientID %>">Status:</label>
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="form-select text-xs py-1.5 px-3">
                    <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                    <asp:ListItem Value="Pending" Text="Pending (Broadcasting)"></asp:ListItem>
                    <asp:ListItem Value="Quoted" Text="Quoted (Bids Ready)"></asp:ListItem>
                    <asp:ListItem Value="Closed" Text="Closed / Awarded"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <!-- RFQs Data Table -->
        <div class="overflow-x-auto">
            <asp:GridView ID="gvRequests" runat="server" AutoGenerateColumns="False" DataKeyNames="RfqId" OnRowCommand="gvRequests_RowCommand" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="RFQ Ref #" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]">
                        <ItemTemplate>
                            RFQ-<%# Convert.ToInt32(Eval("RfqId")).ToString("D5") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PartNumber" HeaderText="Part Number" ItemStyle-CssClass="font-mono font-bold text-slate-800" />
                    <asp:BoundField DataField="PartName" HeaderText="Component Description" ItemStyle-CssClass="font-semibold text-slate-900" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-CssClass="font-mono font-bold text-center" />
                    <asp:TemplateField HeaderText="Target Budget">
                        <ItemTemplate>
                            <%# Eval("TargetPrice") != DBNull.Value && Eval("TargetPrice") != null
                                ? "₹" + Convert.ToDecimal(Eval("TargetPrice")).ToString("N0")
                                : "<span class='text-slate-400'>Open Market</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Supplier Bids">
                        <ItemTemplate>
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-mono font-bold <%# Convert.ToInt32(Eval("BidCount")) > 0 ? "bg-emerald-100 text-emerald-800 border border-emerald-300" : "bg-slate-100 text-slate-500 border border-slate-200" %>">
                                <i class="fa-solid fa-tag mr-1 text-[9px]"></i>
                                <%# Eval("BidCount") %> Quotes
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge-status <%# Eval("Status").ToString() == "Quoted" ? "badge-quoted" : (Eval("Status").ToString() == "Closed" ? "badge-closed" : "badge-pending") %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreatedAt" HeaderText="Issued Date" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="text-slate-500 font-mono text-[11px]" />
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                        <ItemTemplate>
                            <asp:Button ID="btnCompare" runat="server" Text="Compare Quotes &rarr;" CommandName="CompareBids" CommandArgument='<%# Eval("RfqId") %>' 
                                        Visible='<%# Convert.ToInt32(Eval("BidCount")) > 0 %>' CssClass="btn-primary text-xs py-1 px-3" />
                            <span class="text-[11px] text-slate-400 font-mono" style='<%# Convert.ToInt32(Eval("BidCount")) == 0 ? "" : "display:none;" %>'>Awaiting Bids</span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-file-invoice text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No quotation requests found for this filter.</p>
                        <span class="text-[11px] text-slate-400">Issue an RFQ from the catalog to receive competitive price offers.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
