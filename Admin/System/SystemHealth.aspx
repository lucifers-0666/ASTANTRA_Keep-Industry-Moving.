<%@ Page Title="System Health & Infrastructure Telemetry" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="SystemHealth.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.SystemGovernance.SystemHealth" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">INFRASTRUCTURE &amp; RUNTIME MONITORING</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">System Health &amp; Infrastructure Telemetry</h1>
            <p class="text-xs text-[#64748B] m-0">Live connectivity heartbeat, LocalDB database engine telemetry, and Web Forms runtime diagnostics.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnTestDb" runat="server" Text="Execute Engine Heartbeat" OnClick="btnTestDb_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs admin-animate-enter">
        <div class="flex items-center gap-2.5">
            <i class="fa-solid fa-circle-check text-emerald-600 text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
    </asp:Panel>

    <!-- Health Telemetry Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6 admin-animate-enter admin-stagger-1">
        <div class="surface-card p-4 border-l-4 border-l-[#059669]">
            <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase">Database Engine</span>
                <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#059669]">ONLINE</span>
                <span class="text-[10px] text-slate-500 block mt-0.5">(localdb)\MSSQLLocalDB</span>
            </div>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#1769E0]">
            <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase">Total Tables</span>
                <i class="fa-solid fa-database text-xs text-[#1769E0]"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblTotalTables" runat="server">19</span>
                <span class="text-[10px] text-slate-500 block mt-0.5">Relational entities</span>
            </div>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#D97706]">
            <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase">Database Rows</span>
                <i class="fa-solid fa-server text-xs text-[#D97706]"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#0F172A]" id="lblTotalRows" runat="server">0</span>
                <span class="text-[10px] text-slate-500 block mt-0.5">Persisted table records</span>
            </div>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#7C3AED]">
            <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase">Memory / Threading</span>
                <i class="fa-solid fa-microchip text-xs text-[#7C3AED]"></i>
            </div>
            <div class="mt-2">
                <span class="text-xl font-black font-mono text-[#7C3AED]">64-bit</span>
                <span class="text-[10px] text-slate-500 block mt-0.5">CLR Threadpool Healthy</span>
            </div>
        </div>
    </div>

    <!-- Infrastructure Technical Specifications Card -->
    <div class="surface-card p-6 border border-[#CBD5E1] shadow-xs mb-8 admin-animate-enter admin-stagger-2">
        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] mb-4 pb-2 border-b border-[#E2E8F0] flex items-center gap-2">
            <i class="fa-solid fa-server text-[#1769E0]"></i> Technical Runtime Environment Specifications
        </h3>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs font-mono">
            <div class="space-y-3 bg-slate-50 p-4 rounded border border-slate-200">
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Framework Platform:</span>
                    <span class="font-bold text-[#0F172A]">Microsoft .NET Framework 4.8</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Language Standard:</span>
                    <span class="font-bold text-[#0F172A]">C# 7.3</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Web Forms Architecture:</span>
                    <span class="font-bold text-[#0F172A]">ASP.NET Web Forms (System.Web)</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">CLR Version:</span>
                    <span class="font-bold text-[#0F172A]" id="lblClrVersion" runat="server">4.0.30319.42000</span>
                </div>
            </div>

            <div class="space-y-3 bg-slate-50 p-4 rounded border border-slate-200">
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Database Engine:</span>
                    <span class="font-bold text-emerald-700">Microsoft SQL Server LocalDB</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">SQL Version:</span>
                    <span class="font-bold text-[#0F172A]" id="lblSqlVersion" runat="server">SQL Server 2019/2022</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Data Access Pattern:</span>
                    <span class="font-bold text-blue-700">3-Tier Parameterized ADO.NET</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-slate-500">Active Machine:</span>
                    <span class="font-bold text-[#0F172A]" id="lblMachineName" runat="server">LOCAL-WORKSTATION</span>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
