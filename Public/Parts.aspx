<%@ Page Title="Industrial Spare Parts Catalog" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Parts.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Parts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Search indexed industrial spare parts by OEM part number, machine model, or category across regional verified suppliers." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. CATALOG HEADER                                                            -->
    <!-- Clean white surface banner with restrained typography                        -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">
                Catalog &amp; Inventory Index
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                Industrial Spare Parts
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                Search verified OEM mechanical, hydraulic, and electrical components with cross-referenced machine model compatibility.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- ============================================================================ -->
        <!-- 2. SEARCH & FILTER SURFACE                                                   -->
        <!-- Structured, clean white card without excessive padding or decorations        -->
        <!-- ============================================================================ -->
        <div class="surface-card p-5 sm:p-6 space-y-4">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3 text-slate-400 text-sm"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input pl-10" Placeholder="Search by part name, part # (e.g. 6210-2RS), or machine model..."></asp:TextBox>
                </div>

                <!-- Category Filter Dropdown -->
                <div class="w-full md:w-60">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-input font-medium">
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
                    <asp:Button ID="btnSearch" runat="server" Text="Filter Parts" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2 px-4" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-3" />
                </div>

            </div>

            <!-- Quick Filter Chips -->
            <div class="flex flex-wrap items-center gap-2 pt-3 border-t border-[#D9DEE5] text-xs text-[#5F6B7A]">
                <span class="font-semibold text-[#111827]">Quick Filter:</span>
                <asp:LinkButton ID="btnFilterHydraulics" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Hydraulics & Pneumatics" CssClass="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Hydraulics</asp:LinkButton>
                <asp:LinkButton ID="btnFilterMotors" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Motors & Drives" CssClass="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Motors &amp; Drives</asp:LinkButton>
                <asp:LinkButton ID="btnFilterBearings" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Bearings & Power Transmission" CssClass="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Bearings</asp:LinkButton>
                <asp:LinkButton ID="btnFilterElectrical" runat="server" OnClick="btnQuickFilter_Click" CommandArgument="Electrical & Automation" CssClass="px-2.5 py-1 rounded bg-[#E9ECEF] text-[#172033] hover:text-[#1769E0] transition-colors font-mono">Electrical &amp; PLC</asp:LinkButton>
            </div>
        </div>

        <!-- ============================================================================ -->
        <!-- 3. RESULTS STATUS BAR                                                        -->
        <!-- ============================================================================ -->
        <div class="flex justify-between items-center text-xs text-[#5F6B7A] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#111827] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-1.5 font-mono text-[11px]">
                <span class="w-2 h-2 rounded-full bg-[#18865B]"></span>
                <span>Live Repository Index</span>
            </div>
        </div>

        <!-- ============================================================================ -->
        <!-- 4. SPARE PARTS GRID                                                          -->
        <!-- 3 cols desktop, 2 cols tablet, 1 col mobile. Clean, non-overloaded cards    -->
        <!-- ============================================================================ -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <asp:Repeater ID="rptParts" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors text-left">
                        
                        <!-- Top Metadata -->
                        <div class="space-y-2.5">
                            <div class="flex justify-between items-start gap-2">
                                <span class="font-mono text-xs font-semibold px-2 py-0.5 rounded bg-blue-50 text-[#1769E0] border border-blue-200">
                                    <%# Eval("PartNumber") %>
                                </span>
                                <span class='<%# Eval("AvailabilityStatus").ToString() == "InStock" ? "px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-[#18865B] border border-emerald-200" : "px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-[#B45309] border border-amber-200" %>'>
                                    <i class='fa-solid <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "fa-circle-check text-[#18865B]" : "fa-clock text-[#B45309]" %> mr-1'></i>
                                    <%# Eval("AvailabilityStatus").ToString() == "InStock" ? "In Stock" : "Pre-Order" %>
                                </span>
                            </div>

                            <div>
                                <span class="text-[10px] font-bold text-[#5F6B7A] uppercase tracking-wider block font-mono"><%# Eval("CategoryName") %></span>
                                <h3 class="font-bold text-[#111827] text-base leading-snug m-0 mt-0.5"><%# Eval("PartName") %></h3>
                            </div>

                            <div class="text-xs text-[#5F6B7A]">
                                <span class="text-[11px] block font-mono">Compatible Machine:</span>
                                <strong class="text-[#111827] font-mono"><%# Eval("MachineName") %></strong>
                            </div>
                        </div>

                        <!-- Technical Specification Callout -->
                        <div class="bg-[#F8F9FA] p-3 rounded border border-[#E5E9EE] text-xs text-[#172033] space-y-1 font-mono">
                            <div class="text-[11px] text-[#5F6B7A]"><%# Eval("TechnicalSpecs") %></div>
                            <div class="text-[10px] text-[#5F6B7A]">Supplier: <strong class="text-[#111827]"><%# Eval("SupplierName") %></strong></div>
                        </div>

                        <!-- Card Footer -->
                        <div class="flex justify-between items-center pt-3 border-t border-[#D9DEE5]">
                            <div>
                                <span class="text-[10px] text-[#5F6B7A] block font-mono uppercase">Price</span>
                                <span class="text-sm font-bold text-[#111827] font-mono">
                                    <%# Eval("UnitPrice") != DBNull.Value && Eval("UnitPrice") != null && Convert.ToDecimal(Eval("UnitPrice")) > 0 
                                        ? "&#8377;" + Convert.ToDecimal(Eval("UnitPrice")).ToString("N0") 
                                        : "<span class='text-xs text-[#1769E0] font-semibold'>Quote on Request</span>" %>
                                </span>
                            </div>
                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Parts.aspx")) %>' class="btn-primary text-xs py-1.5 px-3">
                                Request Quote
                            </a>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- ============================================================================ -->
        <!-- 5. EMPTY STATE PANEL                                                         -->
        <!-- ============================================================================ -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-12 bg-white border border-[#D9DEE5] rounded-lg space-y-3">
            <div class="w-10 h-10 mx-auto rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-lg">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <h3 class="text-base font-bold text-[#111827] m-0">No matching spare parts found</h3>
            <p class="text-xs text-[#5F6B7A] max-w-sm mx-auto m-0 leading-relaxed">
                Check OEM part number spelling or clear filters to view all catalog parts.
            </p>
            <div class="pt-1">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Clear Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-1.5 px-4" />
            </div>
        </asp:Panel>

        <!-- ============================================================================ -->
        <!-- 6. EMERGENCY BREAKDOWN CALLOUT                                               -->
        <!-- ============================================================================ -->
        <div class="bg-white border border-[#D9DEE5] rounded-lg p-5 sm:p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div class="space-y-1 text-left">
                <div class="flex items-center gap-2">
                    <span class="text-xs font-mono font-bold text-[#E87519] uppercase tracking-wider">Emergency Breakdown Sourcing</span>
                </div>
                <h4 class="text-base font-bold text-[#111827] m-0">Can't locate your required component?</h4>
                <p class="text-xs text-[#5F6B7A] m-0">Broadcast priority breakdown requirements to alert regional verified stockists with matching inventory.</p>
            </div>
            <a href="~/Public/Emergency.aspx" runat="server" class="btn-emergency text-xs py-2 px-4 whitespace-nowrap shrink-0">
                <i class="fa-solid fa-bolt mr-1"></i> Broadcast Emergency RFQ
            </a>
        </div>

    </div>
</asp:Content>

