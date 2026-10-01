<%@ Page Title="Industrial Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Parts.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Parts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Search indexed industrial spare parts by OEM part number, machine model, or category across regional verified suppliers." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Technical Catalog Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-blue">
                    <i class="fa-solid fa-barcode"></i> COMPONENT DISCOVERY INDEX
                </span>
                <span class="spec-tag spec-tag-amber">
                    OFFICIAL OEM &amp; REPLACEMENT TOLERANCES
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                Industrial Spare Parts Catalog
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                Index of mechanical, hydraulic, and electrical components with cross-referenced machine model compatibility, ready stock indicators, and direct quotation requests.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
        
        <!-- 2. Integrated Search & Filter Workspace -->
        <div class="bg-white p-6 sm:p-7 rounded-2xl border border-[#CBD5E1] shadow-xs space-y-5">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-4 top-3.5 text-slate-400"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-11 pr-4 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" Placeholder="Search by Part No (e.g. 6210-2RS, PART-HYD-001), Machine Model, or Keyword..."></asp:TextBox>
                </div>

                <!-- Category Filter Dropdown -->
                <div class="w-full md:w-64">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-xs sm:text-sm text-[#0F172A] focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium">
                        <asp:ListItem Value="" Text="All Categories"></asp:ListItem>
                        <asp:ListItem Value="Hydraulics & Pneumatics" Text="Hydraulics & Pneumatics"></asp:ListItem>
                        <asp:ListItem Value="Motors & Drives" Text="Motors & Drives"></asp:ListItem>
                        <asp:ListItem Value="Bearings & Power Transmission" Text="Bearings & Transmission"></asp:ListItem>
                        <asp:ListItem Value="Electrical & Automation" Text="Electrical & Automation"></asp:ListItem>
                        <asp:ListItem Value="Pumps & Valves" Text="Pumps & Valves"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Filter Actions -->
                <div class="flex items-center gap-2 shrink-0">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter Catalog" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2.5 px-5 font-bold cursor-pointer" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2.5 px-4 font-bold cursor-pointer" />
                </div>

            </div>

            <!-- Quick Filter Chips -->
            <div class="flex flex-wrap items-center gap-2 pt-3 border-t border-[#E2E8F0] text-xs text-[#64748B]">
                <span class="font-bold text-[#0F172A]">Quick Classifications:</span>
                <asp:LinkButton ID="btnFilterHydraulics" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Hydraulics & Pneumatics" CssClass="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">Hydraulics &amp; Pneumatics</asp:LinkButton>
                <asp:LinkButton ID="btnFilterMotors" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Motors & Drives" CssClass="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">Motors &amp; Drives</asp:LinkButton>
                <asp:LinkButton ID="btnFilterBearings" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Bearings & Power Transmission" CssClass="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">Bearings</asp:LinkButton>
                <asp:LinkButton ID="btnFilterElectrical" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Electrical & Automation" CssClass="px-2.5 py-1 rounded-md bg-[#F1F5F9] border border-[#E2E8F0] text-[#334155] hover:border-[#1D4ED8] hover:text-[#1D4ED8] transition-colors font-mono">Electrical &amp; PLC</asp:LinkButton>
            </div>
        </div>

        <!-- 3. Roster Status Bar -->
        <div class="flex justify-between items-center text-xs text-[#64748B] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#0F172A] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                <span class="font-mono text-[11px]">ADO.NET Indexed Live Records</span>
            </div>
        </div>

        <!-- 4. Technical Component Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <asp:Repeater ID="rptParts" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1D4ED8] transition-all">
                        
                        <!-- Top Metadata -->
                        <div class="space-y-2.5">
                            <div class="flex justify-between items-start gap-2">
                                <span class="spec-tag spec-tag-blue"><%# Eval("PartNumber") %></span>
                                <span class='<%# Eval("AvailabilityStatus").ToString() == "InStock" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                    <i class='fa-solid <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "fa-circle-check text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "In Stock" : "Pre-Order" %>
                                </span>
                            </div>

                            <div>
                                <span class="text-[10px] font-bold text-[#1D4ED8] uppercase tracking-wider block font-mono"><%# Eval("CategoryName") %></span>
                                <h3 class="font-bold text-[#0F172A] text-base leading-snug m-0"><%# Eval("PartName") %></h3>
                            </div>

                            <div class="text-xs text-[#475569]">
                                <span class="text-[11px] text-[#64748B] block font-mono">Compatible Machine:</span>
                                <strong class="text-[#0F172A] font-mono"><%# Eval("MachineName") %></strong>
                            </div>
                        </div>

                        <!-- Technical Specification Callout -->
                        <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-xs text-[#334155] space-y-1 font-mono">
                            <div class="text-[11px]"><%# Eval("TechnicalSpecs") %></div>
                            <div class="text-[10px] text-[#64748B]">Supplier: <%# Eval("SupplierName") %></div>
                        </div>

                        <!-- Card Footer -->
                        <div class="flex justify-between items-center pt-3 border-t border-[#E2E8F0]">
                            <div>
                                <span class="text-[10px] text-[#64748B] block font-mono">
                                    <%# Eval("UnitPrice") != DBNull.Value && Eval("UnitPrice") != null && Convert.ToDecimal(Eval("UnitPrice")) > 0 ? "Indicative Unit Price" : "Pricing Schedule" %>
                                </span>
                                <span class="text-sm sm:text-base font-black text-[#0F172A] font-mono">
                                    <%# Eval("UnitPrice") != DBNull.Value && Eval("UnitPrice") != null && Convert.ToDecimal(Eval("UnitPrice")) > 0 
                                        ? "&#8377;" + Convert.ToDecimal(Eval("UnitPrice")).ToString("N0") 
                                        : "<span class='text-xs text-[#1D4ED8] font-bold'>Quote on Request</span>" %>
                                </span>
                            </div>
                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Parts.aspx")) %>' class="btn-primary text-xs py-2 px-3.5 font-bold">
                                Request Quote
                            </a>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 5. Empty State Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-16 bg-white border border-[#CBD5E1] rounded-2xl space-y-4">
            <div class="w-12 h-12 mx-auto rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-xl">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <h3 class="text-base font-bold text-[#0F172A] m-0">No matching spare parts in catalog</h3>
            <p class="text-xs text-[#64748B] max-w-md mx-auto m-0 leading-relaxed">
                Check OEM part number spelling, broaden search keywords, or reset filters to display the full indexed repository.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Clear Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-5 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

        <!-- 6. Emergency Breakdown Callout -->
        <div class="bg-gradient-to-r from-orange-50 via-white to-amber-50 border border-orange-200 rounded-2xl p-6 sm:p-7 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5">
            <div class="space-y-1 text-left">
                <div class="flex items-center gap-2">
                    <span class="spec-tag spec-tag-orange">CRITICAL BREAKDOWN SOURCING</span>
                    <span class="text-xs text-[#64748B] font-mono">UNSCHEDULED STOPPAGE</span>
                </div>
                <h4 class="text-base font-bold text-[#0F172A] m-0">Can't locate your exact replacement part?</h4>
                <p class="text-xs text-[#475569] m-0">Submit a priority breakdown broadcast to alert regional certified stockists possessing matching category stock.</p>
            </div>
            <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2.5 px-5 font-bold whitespace-nowrap shrink-0 shadow-xs">
                <i class="fa-solid fa-bolt mr-1"></i> Broadcast Emergency RFQ
            </a>
        </div>

    </div>
</asp:Content>

