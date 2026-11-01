<%@ Page Title="Technician Service Portal Dashboard" Language="C#" MasterPageFile="~/MasterPages/Technician.Master"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IndustrialSparePartPortal.Technician.Dashboard" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Alert Panel -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false"
            CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between text-left">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
                <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
            </div>
        </asp:Panel>

        <!-- Technician Greeting & Status Banner -->
        <div class="surface-card bg-[#0F172A] text-white p-7 sm:p-9 mb-8 border-slate-700 shadow-lg text-left">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                <div class="space-y-1.5 text-left">
                    <span class="spec-tag spec-tag-blue text-[10px]">FIELD MAINTENANCE &amp; COMMISSIONING</span>
                    <h1 class="text-2xl font-black text-white tracking-tight m-0">Welcome back, <span id="lblTechName"
                            runat="server" class="text-[#38BDF8]">Service Provider</span></h1>
                    <p class="text-xs text-slate-300 m-0 max-w-xl leading-relaxed">Manage on-site breakdown requests,
                        update maintenance diagnostics, and set duty availability.</p>
                </div>
                <div class="flex flex-wrap gap-2.5 shrink-0">
                    <asp:Button ID="btnToggleAvailability" runat="server" Text="Toggle Duty Status"
                        OnClick="btnToggleAvailability_Click"
                        CssClass="btn-primary text-xs py-2.5 px-4 font-bold bg-[#0284C7] hover:bg-[#0369A1] cursor-pointer" />
                    <a href="~/Technician/Requests/AssignedJobs.aspx" runat="server"
                        class="btn-primary text-xs py-2.5 px-4 font-bold bg-[#1769E0] hover:bg-[#1254B7]">
                        <i class="fa-solid fa-screwdriver-wrench"></i> Assigned Jobs
                    </a>
                    <a href="~/Public/Emergency.aspx" runat="server"
                        class="btn-emergency text-xs py-2.5 px-4 font-bold">
                        <i class="fa-solid fa-triangle-exclamation"></i> Breakdown Alerts
                    </a>
                </div>
            </div>
        </div>

        <!-- Quick Stat Metrics -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8 text-left">
            <div class="surface-card p-5 border-l-4 border-l-cyan-600 space-y-1">
                <span class="text-[11px] font-mono uppercase text-[#64748B] block">Assigned Service Calls</span>
                <span class="text-2xl font-black text-[#0F172A] font-mono block">
                    <asp:Label ID="lblAssignedJobs" runat="server" Text="0"></asp:Label>
                </span>
                <span class="text-[11px] text-[#0284C7] font-mono font-bold block">Active / In-Progress</span>
            </div>

            <div class="surface-card p-5 border-l-4 border-l-[#059669] space-y-1">
                <span class="text-[11px] font-mono uppercase text-[#64748B] block">Services Completed</span>
                <span class="text-2xl font-black text-[#0F172A] font-mono block">
                    <asp:Label ID="lblCompletedJobs" runat="server" Text="0"></asp:Label>
                </span>
                <span class="text-[11px] text-[#059669] font-mono font-bold block">Verified Resolved</span>
            </div>

            <div class="surface-card p-5 border-l-4 border-l-[#B45309] space-y-1">
                <span class="text-[11px] font-mono uppercase text-[#64748B] block">Billing Hourly Rate</span>
                <span class="text-2xl font-black text-[#0F172A] font-mono block">
                    <asp:Label ID="lblHourlyRate" runat="server" Text="₹0/hr"></asp:Label>
                </span>
                <span class="text-[11px] text-[#B45309] font-mono font-bold block">Contract Baseline</span>
            </div>

            <div class="surface-card p-5 border-l-4 border-l-[#1D4ED8] space-y-1">
                <span class="text-[11px] font-mono uppercase text-[#64748B] block">Availability Status</span>
                <span class="text-sm font-bold mt-2 flex items-center gap-1.5 font-mono">
                    <asp:Label ID="lblDutyStatus" runat="server" Text="On Duty"></asp:Label>
                </span>
                <span class="text-[11px] text-[#64748B] font-mono block">Real-time Directory State</span>
            </div>
        </div>

        <!-- Quick Action Card -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 text-left">
            <a href="~/Technician/Requests/AssignedJobs.aspx" runat="server"
                class="surface-card p-6 hover:border-[#1769E0] transition duration-150 block group">
                <div class="flex items-center gap-3 mb-3">
                    <div
                        class="w-10 h-10 rounded-[3px] bg-blue-50 text-[#1769E0] flex items-center justify-center font-bold text-lg group-hover:bg-[#1769E0] group-hover:text-white transition">
                        <i class="fa-solid fa-list-check"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold text-[#17212F] m-0">Assigned Maintenance Calls</h3>
                        <span class="text-[11px] text-[#5F6B7A]">Manage appointments, mark completion, record
                            diagnosis</span>
                    </div>
                </div>
                <p class="text-xs text-[#5F6B7A] m-0">View scheduled factory machinery diagnostics, plant location
                    addresses, contact numbers, and update job execution status.</p>
            </a>

            <a href="~/Public/Emergency.aspx" runat="server"
                class="surface-card p-6 hover:border-[#EA580C] transition duration-150 block group">
                <div class="flex items-center gap-3 mb-3">
                    <div
                        class="w-10 h-10 rounded-[3px] bg-orange-50 text-[#EA580C] flex items-center justify-center font-bold text-lg group-hover:bg-[#EA580C] group-hover:text-white transition">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold text-[#17212F] m-0">Emergency Breakdown Alerts</h3>
                        <span class="text-[11px] text-[#5F6B7A]">High priority industrial SOS dispatches</span>
                    </div>
                </div>
                <p class="text-xs text-[#5F6B7A] m-0">Monitor urgent plant stoppage alerts across regional industrial
                    corridors and offer rapid response maintenance.</p>
            </a>
        </div>
    </asp:Content>