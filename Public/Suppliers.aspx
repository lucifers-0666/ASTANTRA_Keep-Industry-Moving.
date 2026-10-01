<%@ Page Title="Industrial Supplier Directory" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Suppliers.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Suppliers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Discover and compare verified industrial spare-part suppliers and distributors by location, parts inventory, and response time." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-emerald">
                    <i class="fa-solid fa-warehouse"></i> VERIFIED DISTRIBUTOR ROSTER
                </span>
                <span class="spec-tag spec-tag-amber">
                    REGIONAL INVENTORY VERIFICATION
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                Compare Regional Spare-Part Suppliers
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                Evaluate certified suppliers and authorized distributors by geographic proximity, product specializations, ready shelf stock, and average RFQ turnaround time.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
        
        <!-- 2. Search & Filter Bar -->
        <div class="bg-white p-6 sm:p-7 rounded-2xl border border-[#CBD5E1] shadow-xs space-y-5">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-4 top-3.5 text-slate-400"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-11 pr-4 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" Placeholder="Search by Supplier Business Name, Category, or City..."></asp:TextBox>
                </div>

                <!-- City Filter -->
                <div class="w-full md:w-56">
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-xs sm:text-sm text-[#0F172A] focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium">
                        <asp:ListItem Value="" Text="All Industrial Zones"></asp:ListItem>
                        <asp:ListItem Value="Ahmedabad" Text="Ahmedabad, GJ"></asp:ListItem>
                        <asp:ListItem Value="Pune" Text="Pune, MH"></asp:ListItem>
                        <asp:ListItem Value="Mumbai" Text="Mumbai, MH"></asp:ListItem>
                        <asp:ListItem Value="Vadodara" Text="Vadodara, GJ"></asp:ListItem>
                        <asp:ListItem Value="Surat" Text="Surat, GJ"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Verification Status Filter -->
                <div class="w-full md:w-48">
                    <asp:DropDownList ID="ddlVerification" runat="server" CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-xs sm:text-sm text-[#0F172A] focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium">
                        <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                        <asp:ListItem Value="Verified" Text="Verified Suppliers"></asp:ListItem>
                        <asp:ListItem Value="Demo" Text="Demo Profiles"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Action Buttons -->
                <div class="flex items-center gap-2 shrink-0">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter Suppliers" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2.5 px-5 font-bold cursor-pointer" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2.5 px-4 font-bold cursor-pointer" />
                </div>

            </div>
        </div>

        <!-- 3. Roster Status Bar -->
        <div class="flex justify-between items-center text-xs text-[#64748B] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#0F172A] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                <span class="font-mono text-[11px]">Regional Audited Suppliers</span>
            </div>
        </div>

        <!-- 4. Supplier Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <asp:Repeater ID="rptSuppliers" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1D4ED8] transition-all">
                        
                        <div class="space-y-3">
                            <div class="flex justify-between items-start gap-2">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-lg bg-slate-100 text-[#1D4ED8] border border-[#CBD5E1] flex items-center justify-center font-bold text-base shrink-0">
                                        <i class="fa-solid fa-warehouse"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-[#0F172A] text-base leading-snug m-0"><%# Eval("CompanyName") %></h3>
                                        <span class="text-xs text-[#64748B] font-mono flex items-center gap-1 mt-0.5">
                                            <i class="fa-solid fa-location-dot text-slate-400"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Badges & Ratings -->
                            <div class="flex items-center justify-between pt-1">
                                <span class='<%# Eval("VerificationStatus").ToString() == "Verified" ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                    <i class='fa-solid <%# Eval("VerificationStatus").ToString() == "Verified" ? "fa-shield-halved text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "Verified Supplier" : "Demo Profile" %>
                                </span>
                                <span class="text-xs font-bold text-[#0F172A] flex items-center gap-1 font-mono">
                                    <i class="fa-solid fa-star text-amber-500"></i> <%# Eval("Rating") %>
                                </span>
                            </div>

                            <!-- Specialization -->
                            <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-xs text-[#475569] space-y-0.5 font-mono">
                                <span class="text-[10px] text-[#64748B] uppercase block">Specialization:</span>
                                <strong class="text-[#0F172A] block"><%# Eval("Specialization") %></strong>
                            </div>
                        </div>

                        <!-- Metrics & RFQ Actions -->
                        <div class="space-y-3 pt-3 border-t border-[#E2E8F0]">
                            <div class="grid grid-cols-2 gap-2 text-xs text-[#64748B] font-mono">
                                <div>
                                    <span class="text-[10px] block">Inventory Index:</span>
                                    <strong class="text-[#0F172A]"><%# Eval("InventoryCount") %> Parts</strong>
                                </div>
                                <div>
                                    <span class="text-[10px] block">Avg Response:</span>
                                    <strong class="text-[#1D4ED8]"><%# Eval("LeadTime") %></strong>
                                </div>
                            </div>

                            <div class="flex items-center gap-2 pt-1">
                                <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Suppliers.aspx")) %>' class="btn-primary text-xs py-2 px-3 font-bold flex-1 text-center justify-center">
                                    Request Quote
                                </a>
                                <a href="~/Public/Parts.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold text-center justify-center">
                                    View Stock
                                </a>
                            </div>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 5. Empty State Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-16 bg-white border border-[#CBD5E1] rounded-2xl space-y-4">
            <div class="w-12 h-12 mx-auto rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-xl">
                <i class="fa-solid fa-warehouse"></i>
            </div>
            <h3 class="text-base font-bold text-[#0F172A] m-0">No matching suppliers found</h3>
            <p class="text-xs text-[#64748B] max-w-md mx-auto m-0 leading-relaxed">
                Try selecting "All Industrial Zones" or clearing the keyword filter to view all verified stockists.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-5 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

        <!-- 6. Supplier Onboarding CTA -->
        <div class="bg-gradient-to-r from-blue-50/70 via-white to-blue-50/70 border border-blue-200 rounded-2xl p-6 sm:p-7 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5">
            <div class="space-y-1 text-left">
                <span class="spec-tag spec-tag-blue">SUPPLIER ONBOARDING</span>
                <h4 class="text-base font-bold text-[#0F172A] m-0">Are you an authorized industrial equipment or spare-parts distributor?</h4>
                <p class="text-xs text-[#475569] m-0">Register your business, list warehouse inventory, and receive RFQs from regional manufacturing plants.</p>
            </div>
            <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2.5 px-5 font-bold whitespace-nowrap shrink-0 shadow-xs">
                <i class="fa-solid fa-user-plus mr-1"></i> Register as Supplier
            </a>
        </div>

    </div>
</asp:Content>

