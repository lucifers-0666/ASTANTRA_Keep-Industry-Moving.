<%@ Page Title="Field Technician Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Technicians.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Technicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Connect with certified industrial field service engineers for machine troubleshooting, PLC automation, and hydraulic repairs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ============================================================================ -->
    <!-- 1. DIRECTORY HEADER                                                          -->
    <!-- ============================================================================ -->
    <div class="bg-white border-b border-[#D9DEE5] py-8 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <span class="text-xs font-mono font-bold text-[#1769E0] uppercase tracking-wider block">
                Field Service Engineering
            </span>
            <h1 class="text-2xl sm:text-3xl font-bold text-[#111827] m-0">
                Certified Field Technicians
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-2xl leading-relaxed m-0">
                Mobilize certified field engineers for machine diagnostics, PLC troubleshooting, high-pressure hydraulics, and precision fitting.
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
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input pl-10" Placeholder="Search by engineer name, skill (e.g. PLC, Hydraulic), or city..."></asp:TextBox>
                </div>

                <!-- Skill Filter -->
                <div class="w-full md:w-52">
                    <asp:DropDownList ID="ddlSkill" runat="server" CssClass="form-input font-medium">
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
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-input font-medium">
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
                <span class="w-2 h-2 rounded-full bg-[#1769E0]"></span>
                <span>Certified Engineer Roster</span>
            </div>
        </div>

        <!-- ============================================================================ -->
        <!-- 4. TECHNICIAN CARDS GRID                                                     -->
        <!-- 3 cols desktop, 2 cols tablet, 1 col mobile                                  -->
        <!-- ============================================================================ -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <asp:Repeater ID="rptTechnicians" runat="server">
                <ItemTemplate>
                    <div class="surface-card p-5 flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors text-left">
                        
                        <div class="space-y-3">
                            <div class="flex items-start justify-between gap-2">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-9 h-9 rounded bg-[#E9ECEF] text-[#111827] border border-[#D9DEE5] flex items-center justify-center font-bold text-sm shrink-0">
                                        <i class="fa-solid fa-user-gear text-[#1769E0]"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold text-[#111827] text-base leading-snug m-0"><%# Eval("FullName") %></h3>
                                        <span class="text-xs text-[#5F6B7A] font-mono flex items-center gap-1 mt-0.5">
                                            <i class="fa-solid fa-location-dot text-slate-400"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Badges -->
                            <div class="flex items-center justify-between pt-1">
                                <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-[#18865B] border border-emerald-200" : "px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-[#B45309] border border-amber-200" %>'>
                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-circle-check text-[#18865B]" : "fa-clock text-[#B45309]" %> mr-1'></i>
                                    <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available" : "Engaged" %>
                                </span>
                                <span class="text-xs font-mono font-semibold text-[#1769E0]">
                                    <%# Eval("ExperienceYears") %>+ Yrs Exp
                                </span>
                            </div>

                            <!-- Skillset -->
                            <div class="bg-[#F8F9FA] p-3 rounded border border-[#E5E9EE] text-xs text-[#5F6B7A] space-y-0.5 font-mono">
                                <span class="text-[10px] text-[#5F6B7A] uppercase block">Specialization:</span>
                                <p class="m-0 leading-relaxed text-[#111827]"><%# Eval("SkillSummary") %></p>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="pt-3 border-t border-[#D9DEE5] space-y-3">
                            <div class="flex justify-between items-center text-xs">
                                <div>
                                    <span class="text-[10px] text-[#5F6B7A] block font-mono uppercase">Service Rate</span>
                                    <span class="text-base font-bold text-[#111827] font-mono">
                                        &#8377;<%# Convert.ToDecimal(Eval("HourlyRate")).ToString("N0") %>/hr
                                    </span>
                                </div>
                                <span class="text-[10px] font-mono font-semibold px-2 py-0.5 rounded bg-slate-100 text-[#5F6B7A] border border-[#D9DEE5]">
                                    <%# Eval("VerificationStatus").ToString() == "Verified" ? "VERIFIED" : "DEMO" %>
                                </span>
                            </div>

                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Technicians.aspx")) %>' class="btn-primary w-full justify-center text-xs py-2 font-semibold text-center block">
                                Request Service
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
                <i class="fa-solid fa-user-gear"></i>
            </div>
            <h3 class="text-base font-bold text-[#111827] m-0">No matching technicians found</h3>
            <p class="text-xs text-[#5F6B7A] max-w-sm mx-auto m-0 leading-relaxed">
                Try selecting "All Technical Skills" or clear location filters to browse all registered engineers.
            </p>
            <div class="pt-1">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-1.5 px-4" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>

