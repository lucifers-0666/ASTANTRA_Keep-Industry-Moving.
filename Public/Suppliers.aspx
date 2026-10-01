<%@ Page Title="Industrial Supplier Directory" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Suppliers.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Suppliers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Discover and compare verified industrial spare-part suppliers and distributors by location, parts inventory, and response time." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. DIRECTORY HEADER                                                          -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">
                Regional Supplier Directory
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                Verified Industrial Suppliers
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                Compare certified spare-part stockists and authorized distributors by geographic location, verified inventory count, and quotation turnaround.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- ============================================================================ -->
        <!-- 2. SEARCH & FILTER BAR                                                       -->
        <!-- ============================================================================ -->
        <div class="surface-card p-5 sm:p-6 space-y-4">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3 text-slate-400 text-sm"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input pl-10" Placeholder="Search by supplier name, city, or specialization..."></asp:TextBox>
                </div>

                <!-- City Filter -->
                <div class="w-full md:w-52">
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-input font-medium">
                        <asp:ListItem Value="" Text="All Locations"></asp:ListItem>
                        <asp:ListItem Value="Ahmedabad" Text="Ahmedabad, GJ"></asp:ListItem>
                        <asp:ListItem Value="Pune" Text="Pune, MH"></asp:ListItem>
                        <asp:ListItem Value="Mumbai" Text="Mumbai, MH"></asp:ListItem>
                        <asp:ListItem Value="Vadodara" Text="Vadodara, GJ"></asp:ListItem>
                        <asp:ListItem Value="Surat" Text="Surat, GJ"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Verification Status Filter -->
                <div class="w-full md:w-48">
                    <asp:DropDownList ID="ddlVerification" runat="server" CssClass="form-input font-medium">
                        <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                        <asp:ListItem Value="Verified" Text="Verified Suppliers"></asp:ListItem>
                        <asp:ListItem Value="Demo" Text="Demo Profiles"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Action Buttons -->
                <div class="flex items-center gap-2 shrink-0">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2 px-4" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-3" />
                </div>

            </div>
        </div>

        <!-- ============================================================================ -->
        <!-- 3. ROSTER STATUS BAR                                                         -->
        <!-- ============================================================================ -->
        <div class="flex justify-between items-center text-xs text-[#5F6B7A] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#111827] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-1.5 font-mono text-[11px]">
                <span class="w-2 h-2 rounded-full bg-[#18865B]"></span>
                <span>Regional Stockists Roster</span>
            </div>
        </div>

        <!-- ============================================================================ -->
        <!-- 4. SUPPLIER CARDS GRID                                                       -->
        <!-- 3 cols desktop, 2 cols tablet, 1 col mobile                                  -->
        <!-- ============================================================================ -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <asp:Repeater ID="rptSuppliers" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors text-left">
                        
                        <div class="space-y-3">
                            <div class="flex items-start justify-between gap-2">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-9 h-9 rounded bg-[#E9ECEF] text-[#172033] border border-[#D9DEE5] flex items-center justify-center font-bold text-sm shrink-0">
                                        <i class="fa-solid fa-warehouse"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-[#111827] text-base leading-snug m-0"><%# Eval("CompanyName") %></h3>
                                        <span class="text-xs text-[#5F6B7A] font-mono flex items-center gap-1 mt-0.5">
                                            <i class="fa-solid fa-location-dot text-slate-400"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Badges -->
                            <div class="flex items-center justify-between pt-1">
                                <span class='<%# Eval("VerificationStatus").ToString() == "Verified" ? "px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-[#18865B] border border-emerald-200" : "px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-[#B45309] border border-amber-200" %>'>
                                    <i class='fa-solid <%# Eval("VerificationStatus").ToString() == "Verified" ? "fa-shield-halved text-[#18865B]" : "fa-clock text-[#B45309]" %> mr-1'></i>
                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "Verified Supplier" : "Demo Profile" %>
                                </span>
                                <span class="text-xs font-mono font-semibold text-[#111827] flex items-center gap-1">
                                    <i class="fa-solid fa-star text-amber-500 text-[10px]"></i> <%# Eval("Rating") %>
                                </span>
                            </div>

                            <!-- Specialization -->
                            <div class="bg-[#F8F9FA] p-3 rounded border border-[#E5E9EE] text-xs text-[#5F6B7A] space-y-0.5 font-mono">
                                <span class="text-[10px] text-[#5F6B7A] uppercase block">Specialization:</span>
                                <strong class="text-[#111827] block"><%# Eval("Specialization") %></strong>
                            </div>
                        </div>

                        <!-- Metrics & RFQ Actions -->
                        <div class="space-y-3 pt-3 border-t border-[#D9DEE5]">
                            <div class="grid grid-cols-2 gap-2 text-xs text-[#5F6B7A] font-mono">
                                <div>
                                    <span class="text-[10px] block uppercase">Inventory:</span>
                                    <strong class="text-[#111827]"><%# Eval("InventoryCount") %> Parts</strong>
                                </div>
                                <div>
                                    <span class="text-[10px] block uppercase">Avg Response:</span>
                                    <strong class="text-[#1769E0]"><%# Eval("LeadTime") %></strong>
                                </div>
                            </div>

                            <div class="flex items-center gap-2 pt-1">
                                <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Suppliers.aspx")) %>' class="btn-primary text-xs py-2 px-3 flex-1 text-center justify-center">
                                    Request Quote
                                </a>
                                <a href="~/Public/Parts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 text-center justify-center">
                                    View Stock
                                </a>
                            </div>
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
                <i class="fa-solid fa-warehouse"></i>
            </div>
            <h3 class="text-base font-bold text-[#111827] m-0">No matching suppliers found</h3>
            <p class="text-xs text-[#5F6B7A] max-w-sm mx-auto m-0 leading-relaxed">
                Try selecting "All Locations" or clear keyword filters to display all registered suppliers.
            </p>
            <div class="pt-1">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-1.5 px-4" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>

