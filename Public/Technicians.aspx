<%@ Page Title="Field Technician Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Technicians.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Technicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Connect with certified industrial field service engineers for machine troubleshooting, PLC automation, and hydraulic repairs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-white border-b border-[#CBD5E1] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-3 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-orange">
                    <i class="fa-solid fa-wrench"></i> ON-CALL FIELD ENGINEERING
                </span>
                <span class="spec-tag spec-tag-blue">
                    SPECIALIZED INDUSTRIAL SKILLSETS
                </span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black text-[#0F172A] tracking-tight m-0">
                Discover Certified Field Technicians
            </h1>
            <p class="text-xs sm:text-sm text-[#475569] max-w-3xl leading-relaxed m-0">
                Mobilize certified field service engineers for machine diagnostics, PLC ladder automation troubleshooting, high-pressure hydraulic overhaul, and emergency breakdown repairs.
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
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-11 pr-4 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" Placeholder="Search by Specialist Name, Skill (e.g. PLC, Hydraulic, CNC), or City..."></asp:TextBox>
                </div>

                <!-- Skill Filter -->
                <div class="w-full md:w-56">
                    <asp:DropDownList ID="ddlSkill" runat="server" CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-xs sm:text-sm text-[#0F172A] focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium">
                        <asp:ListItem Value="" Text="All Technical Skills"></asp:ListItem>
                        <asp:ListItem Value="Hydraulic" Text="Hydraulic Systems"></asp:ListItem>
                        <asp:ListItem Value="CNC" Text="CNC Machinery"></asp:ListItem>
                        <asp:ListItem Value="PLC" Text="Electrical & PLC"></asp:ListItem>
                        <asp:ListItem Value="Mechanical" Text="Mechanical & Pumps"></asp:ListItem>
                        <asp:ListItem Value="Automation" Text="Industrial Automation"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- City Filter -->
                <div class="w-full md:w-48">
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-xs sm:text-sm text-[#0F172A] focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium">
                        <asp:ListItem Value="" Text="All Locations"></asp:ListItem>
                        <asp:ListItem Value="Ahmedabad" Text="Ahmedabad, GJ"></asp:ListItem>
                        <asp:ListItem Value="Pune" Text="Pune, MH"></asp:ListItem>
                        <asp:ListItem Value="Mumbai" Text="Mumbai, MH"></asp:ListItem>
                        <asp:ListItem Value="Vadodara" Text="Vadodara, GJ"></asp:ListItem>
                        <asp:ListItem Value="Rajkot" Text="Rajkot, GJ"></asp:ListItem>
                        <asp:ListItem Value="Surat" Text="Surat, GJ"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- Action Buttons -->
                <div class="flex items-center gap-2 shrink-0">
                    <asp:Button ID="btnSearch" runat="server" Text="Filter Technicians" OnClick="btnSearch_Click" CssClass="btn-primary text-xs py-2.5 px-5 font-bold cursor-pointer" />
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
                <span class="w-2 h-2 rounded-full bg-cyan-500"></span>
                <span class="font-mono text-[11px]">Field Service Directory</span>
            </div>
        </div>

        <!-- 4. Technician Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <asp:Repeater ID="rptTechnicians" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1D4ED8] transition-all">
                        
                        <div class="space-y-3">
                            <div class="flex items-start justify-between gap-2">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-lg bg-slate-100 text-[#0F172A] border border-[#CBD5E1] flex items-center justify-center font-bold text-base shrink-0">
                                        <i class="fa-solid fa-user-gear text-[#0284C7]"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-[#0F172A] text-base leading-snug m-0"><%# Eval("FullName") %></h3>
                                        <span class="text-xs text-[#64748B] font-mono flex items-center gap-1 mt-0.5">
                                            <i class="fa-solid fa-location-dot text-slate-400"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Badges -->
                            <div class="flex items-center justify-between pt-1">
                                <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-circle-check text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available for Dispatch" : "Engaged on Site" %>
                                </span>
                                <span class="text-xs font-mono font-bold text-[#1D4ED8]">
                                    <%# Eval("ExperienceYears") %>+ Yrs Exp
                                </span>
                            </div>

                            <!-- Skillset -->
                            <div class="bg-[#F8FAFC] p-3 rounded-lg border border-[#E2E8F0] text-xs text-[#475569] space-y-0.5 font-mono">
                                <span class="text-[10px] text-[#64748B] uppercase block">Core Specialization:</span>
                                <p class="m-0 leading-relaxed text-[#0F172A]"><%# Eval("SkillSummary") %></p>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="pt-3 border-t border-[#E2E8F0] space-y-3">
                            <div class="flex justify-between items-center text-xs">
                                <div>
                                    <span class="text-[10px] text-[#64748B] block font-mono">Service Charge</span>
                                    <span class="text-base font-black text-[#0F172A] font-mono">
                                        &#8377;<%# Convert.ToDecimal(Eval("HourlyRate")).ToString("N0") %>/hr
                                    </span>
                                </div>
                                <span class="spec-tag spec-tag-amber"><%# Eval("VerificationStatus").ToString() == "Verified" ? "VERIFIED TECH" : "DEMO PROFILE" %></span>
                            </div>

                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Technicians.aspx")) %>' class="btn-primary w-full justify-center text-xs py-2.5 font-bold text-center block">
                                <i class="fa-solid fa-calendar-check mr-1"></i> Request Service
                            </a>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 5. Empty State Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-16 bg-white border border-[#CBD5E1] rounded-2xl space-y-4">
            <div class="w-12 h-12 mx-auto rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-xl">
                <i class="fa-solid fa-wrench"></i>
            </div>
            <h3 class="text-base font-bold text-[#0F172A] m-0">No matching technicians found</h3>
            <p class="text-xs text-[#64748B] max-w-md mx-auto m-0 leading-relaxed">
                Try selecting "All Technical Skills" or clear location filters to browse all registered engineers.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-5 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

        <!-- 6. Technician Onboarding CTA -->
        <div class="bg-gradient-to-r from-cyan-50/70 via-white to-cyan-50/70 border border-cyan-200 rounded-2xl p-6 sm:p-7 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5">
            <div class="space-y-1 text-left">
                <span class="spec-tag spec-tag-blue">FIELD SERVICE ONBOARDING</span>
                <h4 class="text-base font-bold text-[#0F172A] m-0">Are you an independent industrial maintenance engineer?</h4>
                <p class="text-xs text-[#475569] m-0">Register your credentials, declare specialized machinery skills, and connect with manufacturing facilities requiring on-site repair.</p>
            </div>
            <a href="~/Account/Register.aspx" runat="server" class="btn-primary text-xs py-2.5 px-5 font-bold whitespace-nowrap shrink-0 shadow-xs">
                <i class="fa-solid fa-user-plus mr-1"></i> Register as Technician
            </a>
        </div>

    </div>
</asp:Content>

