<%@ Page Title="Field Technician Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Technicians.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Technicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Connect with certified industrial field service engineers for machine troubleshooting, PLC automation, and hydraulic repairs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10 px-4 sm:px-6 lg:px-8">
        <div class="max-w-7xl mx-auto space-y-2 text-left">
            <div class="flex flex-wrap items-center gap-2">
                <span class="spec-tag spec-tag-blue font-mono text-xs">
                    <i class="fa-solid fa-wrench"></i> ON-CALL FIELD ENGINEERING
                </span>
                <span class="text-xs text-[#5F6B7A] font-mono">Specialized Machinery Diagnostics &amp; Installation Service</span>
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                Discover Certified Field Technicians
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                Mobilize certified field service engineers for machine diagnostics, PLC ladder logic troubleshooting, high-pressure hydraulic overhaul, and breakdown installation.
            </p>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- 2. Search & Filter Bar (Preserved Server Controls) -->
        <div class="bg-white p-5 sm:p-6 rounded-[3px] border border-[#D5DCE3] shadow-xs space-y-4">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3.5 text-[#7E8C9D] text-xs"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-9 pr-3 py-2.5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-xs sm:text-sm text-[#17212F] placeholder-[#7E8C9D] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium" Placeholder="Search by Specialist Name, Skill (e.g. PLC, Hydraulic, CNC), or City..."></asp:TextBox>
                </div>

                <!-- Skill Filter -->
                <div class="w-full md:w-56">
                    <asp:DropDownList ID="ddlSkill" runat="server" CssClass="w-full px-3 py-2.5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-xs sm:text-sm text-[#17212F] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium">
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
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="w-full px-3 py-2.5 bg-[#F1F3F5] border border-[#D5DCE3] rounded-[3px] text-xs sm:text-sm text-[#17212F] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium">
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
        <div class="flex justify-between items-center text-xs text-[#5F6B7A] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#17212F] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-[#18865B]"></span>
                <span class="font-mono text-[11px]">Certified Service Roster</span>
            </div>
        </div>

        <!-- 4. Technician Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            <asp:Repeater ID="rptTechnicians" runat="server">
                <ItemTemplate>
                    <div class="bg-white p-5 rounded-[3px] border border-[#D5DCE3] flex flex-col justify-between space-y-4 hover:border-[#1769E0] transition-colors shadow-xs text-left">
                        
                        <div class="space-y-3">
                            <div class="flex items-start justify-between gap-2">
                                <div class="flex items-center gap-3">
                                    <div class="w-9 h-9 rounded-[2px] bg-[#E7EBEF] text-[#1769E0] border border-[#D5DCE3] flex items-center justify-center font-bold text-sm shrink-0">
                                        <i class="fa-solid fa-user-gear"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold font-['Archivo',sans-serif] text-[#17212F] text-base leading-snug m-0"><%# Eval("FullName") %></h3>
                                        <span class="text-xs text-[#5F6B7A] font-mono flex items-center gap-1 mt-0.5">
                                            <i class="fa-solid fa-location-dot text-[#7E8C9D]"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Badges -->
                            <div class="flex items-center justify-between pt-1">
                                <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-pill status-pill-verified text-[11px]" : "status-pill status-pill-demo text-[11px]" %>'>
                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-circle-check text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Convert.ToBoolean(Eval("IsAvailable")) ? "On Duty / Available" : "On-Site Engaged" %>
                                </span>
                                <span class="text-xs font-mono font-bold text-[#1769E0]">
                                    <%# Eval("ExperienceYears") %>+ Yrs Exp
                                </span>
                            </div>

                            <!-- Skillset -->
                            <div class="bg-[#F1F3F5] p-3 rounded-[2px] border border-[#D5DCE3] text-xs text-[#2C394B] space-y-0.5 font-mono">
                                <span class="text-[10px] text-[#5F6B7A] uppercase block">Specialization:</span>
                                <strong class="text-[#17212F] block leading-snug"><%# Eval("SkillSummary") %></strong>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="pt-3 border-t border-[#D5DCE3] flex items-center justify-between text-xs font-mono">
                            <div>
                                <span class="text-[10px] text-[#5F6B7A] block">Hourly Rate</span>
                                <strong class="text-sm font-bold text-[#17212F]">&#8377;<%# Eval("HourlyRate") %>/hr</strong>
                            </div>
                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Technicians.aspx")) %>' class="btn-primary text-xs py-1.5 px-3 font-bold">
                                Book Service
                            </a>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 5. Empty State Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-12 bg-white border border-[#D5DCE3] rounded-[3px] space-y-3">
            <div class="w-10 h-10 mx-auto rounded-[3px] bg-[#E7EBEF] flex items-center justify-center text-[#5F6B7A] text-lg">
                <i class="fa-solid fa-user-gear"></i>
            </div>
            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#17212F] m-0">No matching technicians found</h3>
            <p class="text-xs text-[#5F6B7A] max-w-md mx-auto m-0 leading-relaxed">
                Try selecting a different specialization or city, or clear the search filters to display all registered technicians.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>

