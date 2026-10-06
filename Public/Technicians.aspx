<%@ Page Title="Field Technician Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Technicians.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Technicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Connect with certified industrial field service engineers for machine troubleshooting, PLC automation, and hydraulic repairs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. Header Banner -->
    <div class="bg-[#F1F3F5] border-b border-[#D5DCE3] py-10">
        <div class="astantra-container space-y-2 text-left">
            <div class="text-xs font-mono font-bold text-[#5F6B7A] tracking-wider uppercase">
                Field Engineering &amp; Maintenance Services
            </div>
            <h1 class="text-2xl sm:text-3xl lg:text-4xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                Discover Certified Field Technicians
            </h1>
            <p class="text-xs sm:text-sm text-[#5F6B7A] max-w-3xl leading-relaxed m-0">
                Mobilize certified field service engineers for machine diagnostics, PLC ladder logic troubleshooting, high-pressure hydraulic overhaul, and breakdown installation.
            </p>
        </div>
    </div>

    <div class="astantra-container py-8 space-y-6">
        
        <!-- 2. Search & Filter Bar (Preserved Server Controls) -->
        <div class="bg-white p-5 sm:p-6 rounded-[3px] border border-[#D7DDE4] space-y-4 shadow-xs">
            <div class="flex flex-col md:flex-row items-stretch md:items-center gap-3">
                
                <!-- Search Box -->
                <div class="relative flex-1">
                    <i class="fa-solid fa-magnifying-glass absolute left-3.5 top-3.5 text-[#8792A0] text-xs"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="w-full pl-9 pr-3 py-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] text-xs sm:text-sm text-[#202833] placeholder-[#8792A0] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium" Placeholder="Search by Specialist Name, Skill (e.g. PLC, Hydraulic, CNC), or City..."></asp:TextBox>
                </div>

                <!-- Skill Filter -->
                <div class="w-full md:w-56">
                    <asp:DropDownList ID="ddlSkill" runat="server" CssClass="w-full px-3 py-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] text-xs sm:text-sm text-[#202833] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium">
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
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="w-full px-3 py-2.5 bg-[#F7F8FA] border border-[#D7DDE4] rounded-[3px] text-xs sm:text-sm text-[#202833] focus:bg-white focus:outline-none focus:border-[#1769E0] transition-colors font-medium">
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
        <div class="flex justify-between items-center text-xs text-[#667180] px-1">
            <div>
                <asp:Label ID="lblResultsCount" runat="server" CssClass="font-bold text-[#202833] font-mono"></asp:Label>
            </div>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-[#16845B]"></span>
                <span class="text-[11px] text-[#5F6B7A]">Field Engineering Directory</span>
            </div>
        </div>

        <!-- 4. Field Technician Directory (Responsive 2-Column Layout) -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <asp:Repeater ID="rptTechnicians" runat="server">
                <ItemTemplate>
                    <div class="technician-card bg-white p-5 sm:p-6 rounded-[3px] border border-[#D7DDE4] flex flex-col justify-between space-y-4 text-left shadow-xs">
                        
                        <div class="space-y-3">
                            <div class="flex justify-between items-start gap-3">
                                <div class="flex items-start gap-3">
                                    <div class="card-icon-box shrink-0 mt-0.5">
                                        <i class="fa-solid fa-user-gear"></i>
                                    </div>
                                    <div>
                                        <h3 class="font-bold font-['Archivo',sans-serif] text-[#202833] text-base leading-snug m-0"><%# Eval("FullName") %></h3>
                                        <span class="text-xs text-[#667180] flex items-center gap-1.5 mt-1">
                                            <i class="fa-solid fa-location-dot text-[#8792A0] text-[11px]"></i> <%# Eval("City") %>, <%# Eval("State") %>
                                        </span>
                                    </div>
                                </div>
                                <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-pill status-pill-verified text-[11px] shrink-0" : "status-pill status-pill-demo text-[11px] shrink-0" %>'>
                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-circle-check text-emerald-600" : "fa-clock text-amber-600" %> mr-1'></i>
                                    <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available for Dispatch" : "Engaged on Site" %>
                                </span>
                            </div>

                            <!-- Skills & Specialization -->
                            <div class="bg-[#F7F8FA] p-3 rounded-[2px] border border-[#D7DDE4] text-xs text-[#202833] space-y-1">
                                <div class="flex justify-between items-center text-[10px] text-[#667180] uppercase font-semibold">
                                    <span>Specialization &amp; Expertise</span>
                                    <span class="text-[#1769E0] font-mono"><%# Eval("ExperienceYears") %> Years Industry Experience</span>
                                </div>
                                <p class="text-xs text-[#202833] font-medium m-0 leading-relaxed"><%# Eval("SkillSummary") %></p>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="pt-3 border-t border-[#D7DDE4] flex items-center justify-between text-xs">
                            <div>
                                <span class="text-[10px] text-[#667180] block font-mono">Service Rate</span>
                                <strong class="text-sm font-bold text-[#17212F] font-mono">&#8377;<%# Eval("HourlyRate") %>/hour</strong>
                            </div>
                            <a href='<%# ResolveUrl("~/Account/Login.aspx?returnUrl=" + Server.UrlEncode("~/Public/Technicians.aspx")) %>' class="btn-primary text-xs py-2 px-4 font-bold inline-flex items-center gap-1.5">
                                <i class="fa-solid fa-calendar-check text-xs"></i> Book Technician
                            </a>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 5. Empty State Panel -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center py-12 bg-white border border-[#D7DDE4] rounded-[3px] space-y-3">
            <div class="card-icon-box mx-auto text-[#667180] text-lg">
                <i class="fa-solid fa-user-gear"></i>
            </div>
            <h3 class="text-base font-bold font-['Archivo',sans-serif] text-[#202833] m-0">No matching technicians found</h3>
            <p class="text-xs text-[#667180] max-w-md mx-auto m-0 leading-relaxed">
                Try selecting a different specialization or city, or clear the search filters to display all registered technicians.
            </p>
            <div class="pt-2">
                <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>

