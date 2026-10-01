<%@ Page Title="Industrial Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Parts.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Parts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Search indexed industrial spare parts by OEM part number, machine model, or category across regional verified suppliers." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Technical Catalog Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                OEM Parts &amp; Specifications
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                Industrial Spare Parts Catalog
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                Index of mechanical, hydraulic, and electrical replacement components with machine model compatibility, ready stock indicators, and direct quotation requests.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- 2. Integrated Search & Filter Workspace (Preserved Server Controls) -->
        <div class="panel-glass p-5 sm:p-6 rounded-[3px] border border-[#D7DDE4] space-y-4">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3.5 text-[#8792A0] text-xs"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-9 pr-3 py-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] text-xs sm:text-sm text-[#202833] placeholder-[#8792A0] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium" Placeholder="Search by Part # (e.g. 6210-2RS, PART-HYD-001), Machine Model, or Keyword..."></asp:TextBox>
                </div>

                <!-- Category Filter Dropdown -->
                <div class="w-full md:w-64">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="w-full px-3 py-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] text-xs sm:text-sm text-[#202833] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium">
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
            <div class="flex flex-wrap items-center gap-2 pt-3 border-t border-[#D7DDE4] text-xs text-[#667180]">
                <span class="font-bold text-[#202833] font-mono text-[11px]">CATEGORIES:</span>
                <asp:LinkButton ID="btnFilterHydraulics" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Hydraulics & Pneumatics" CssClass="px-2.5 py-1 rounded-[2px] bg-[#E7EBEF] border border-[#D7DDE4] text-[#202833] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors font-mono text-[11px]">Hydraulics &amp; Pneumatics</asp:LinkButton>
                <asp:LinkButton ID="btnFilterMotors" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Motors & Drives" CssClass="px-2.5 py-1 rounded-[2px] bg-[#E7EBEF] border border-[#D7DDE4] text-[#202833] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors font-mono text-[11px]">Motors &amp; Drives</asp:LinkButton>
                <asp:LinkButton ID="btnFilterBearings" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Bearings & Power Transmission" CssClass="px-2.5 py-1 rounded-[2px] bg-[#E7EBEF] border border-[#D7DDE4] text-[#202833] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors font-mono text-[11px]">Bearings</asp:LinkButton>
                <asp:LinkButton ID="btnFilterElectrical" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Electrical & Automation" CssClass="px-2.5 py-1 rounded-[2px] bg-[#E7EBEF] border border-[#D7DDE4] text-[#202833] hover:border-[#1769E0] hover:text-[#1769E0] transition-colors font-mono text-[11px]">Electrical &amp; PLC</asp:LinkButton>
            </div>
        </div>

        <!-- 3. Roster Status Bar -->
        <div class="flex justify-between items-center text-xs text-[#667180] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#202833] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-[#16845B]"></span>
                <span class="font-mono text-[11px]">Indexed Catalog Records</span>
            </div>
        </div>

        <!-- 4. Structured Technical Component Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <asp:Repeater ID="rptParts" runat="server">
                <ItemTemplate>
                    <div class="part-card bg-white p-5 rounded-[3px] border border-[#D7DDE4] flex flex-col justify-between space-y-4 text-left">
                        
                        <!-- Top Metadata -->
                        <div class="space-y-2">
                            <div class="flex justify-between items-start gap-2">
                                <span class="spec-tag spec-tag-blue font-mono font-bold text-xs"><%# Eval("PartNumber") %></span>
                                <span class='<%# Eval("AvailabilityStatus").ToString() == "InStock" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                    <i class='fa-solid <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "fa-circle-check text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "In Stock" : "Pre-Order" %>
                                </span>
                            </div>

                            <div>
                                <span class="text-[10px] font-bold text-[#1769E0] uppercase tracking-wider block font-mono"><%# Eval("CategoryName") %></span>
                                <h3 class="font-bold font-['Archivo',sans-serif] text-[#202833] text-base leading-snug m-0"><%# Eval("PartName") %></h3>
                            </div>

                            <div class="text-xs text-[#667180]">
                                <span class="text-[11px] text-[#8792A0] block font-mono">Compatible Machine:</span>
                                <strong class="text-[#202833] font-mono"><%# Eval("MachineName") %></strong>
                            </div>
                        </div>

                        <!-- Technical Specification Callout -->
                        <div class="bg-[#F7F8FA] p-3 rounded-[2px] border border-[#D7DDE4] text-xs text-[#202833] space-y-1 font-mono">
                            <div class="text-[11px] leading-relaxed"><%# Eval("TechnicalSpecs") %></div>
                            <div class="text-[10px] text-[#667180]">Supplier: <%# Eval("SupplierName") %></div>
                        </div>

                        <!-- Card Footer -->
                        <div class="flex justify-between items-center pt-3 border-t border-[#D7DDE4]">
                            <div>
                                <span class="text-[10px] text-[#667180] block font-mono">
                                    <%# Eval("UnitPrice") != DBNull.Value && Eval("UnitPrice") != null && Convert.ToDecimal(Eval("UnitPrice")) > 0 ? "Indicative Price" : "Pricing Schedule" %>
                                </span>
                                <span class="text-sm sm:text-base font-bold text-[#202833] font-mono">
                                    <%# Eval("UnitPrice") != DBNull.Value && Eval("UnitPrice") != null && Convert.ToDecimal(Eval("UnitPrice")) > 0 
                                        ? "&#8377;" + Convert.ToDecimal(Eval("UnitPrice")).ToString("N0") 
                                        : "<span class='text-xs text-[#1769E0] font-bold'>Quote on Request</span>" %>
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
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-12 bg-white border border-[#D7DDE4] rounded-[3px] space-y-3">
            <div class="w-10 h-10 mx-auto rounded-[3px] bg-[#E7EBEF] flex items-center justify-center text-[#667180] text-lg">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">No matching spare parts in catalog</h3>
            <p class="text-xs text-[#667180] max-w-md mx-auto m-0 leading-relaxed">
                Check OEM part number spelling, broaden search keywords, or reset filters to display the full indexed repository.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Clear Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

        <!-- 6. Emergency Breakdown Callout in Refined Industrial Gray -->
        <div class="bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] p-6 sm:p-7 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5 shadow-[0_2px_8px_-2px_rgba(20,35,55,0.04)]">
            <div class="space-y-1 text-left">
                <div class="flex items-center gap-2">
                    <span class="spec-tag spec-tag-orange">CRITICAL BREAKDOWN SOURCING</span>
                    <span class="text-xs text-[#8792A0] font-mono">UNSCHEDULED STOPPAGE</span>
                </div>
                <h4 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">Can't locate your exact replacement part?</h4>
                <p class="text-xs text-[#667180] m-0">Submit a priority breakdown broadcast to alert regional certified stockists possessing matching category stock.</p>
            </div>
            <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2.5 px-5 font-bold whitespace-nowrap shrink-0 shadow-xs">
                <i class="fa-solid fa-bolt mr-1"></i> Broadcast Emergency RFQ
            </a>
        </div>

    </div>
</asp:Content>

