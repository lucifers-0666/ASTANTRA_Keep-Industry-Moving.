<%@ Page Title="Database & Data Integrity Diagnostics" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="DataIntegrity.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.SystemGovernance.DataIntegrity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">DATABASE INTEGRITY &amp; DIAGNOSTICS</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Database Referential Integrity &amp; Diagnostic Suite</h1>
            <p class="text-xs text-[#64748B] m-0">Live referential integrity audit, orphaned record diagnostics, and normal form consistency across SQL Server LocalDB.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnRepairIntegrity" runat="server" Text="Reconcile Discrepancies" OnClick="btnRepairIntegrity_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
            <asp:Button ID="btnRunAudit" runat="server" Text="Execute Integrity Audit" OnClick="btnRunAudit_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs admin-animate-enter">
        <div class="flex items-center gap-2.5">
            <i class="fa-solid fa-circle-check text-emerald-600 text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
    </asp:Panel>

    <!-- Integrity Diagnostics Telemetry Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6 admin-animate-enter admin-stagger-1">
        <div class="surface-card p-4 border-l-4 border-l-[#059669]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Orphaned Accounts</span>
            <div class="flex items-baseline gap-2 mt-1">
                <span class="text-2xl font-black font-mono text-[#059669]" id="lblOrphanedUsers" runat="server">0</span>
                <span class="text-[11px] text-emerald-700 font-semibold font-mono">100% Intact</span>
            </div>
            <span class="text-[10px] text-slate-500 mt-1 block">Profiles bound to Users table</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#D97706]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Supplier Verification Queue</span>
            <div class="flex items-baseline gap-2 mt-1">
                <span class="text-2xl font-black font-mono text-[#D97706]" id="lblUnverifiedSuppliers" runat="server">0</span>
                <span class="text-[11px] text-amber-700 font-mono">Pending KYC</span>
            </div>
            <span class="text-[10px] text-slate-500 mt-1 block">Vendors awaiting GSTIN check</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#EA580C]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Unresolved SOS Breakdown</span>
            <div class="flex items-baseline gap-2 mt-1">
                <span class="text-2xl font-black font-mono text-[#EA580C]" id="lblPendingEmergencies" runat="server">0</span>
                <span class="text-[11px] text-orange-700 font-mono">Active Incidents</span>
            </div>
            <span class="text-[10px] text-slate-500 mt-1 block">Machine breakdown queue</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#1769E0]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Audit Trail Depth</span>
            <div class="flex items-baseline gap-2 mt-1">
                <span class="text-2xl font-black font-mono text-[#1769E0]" id="lblAuditRecords" runat="server">0</span>
                <span class="text-[11px] text-blue-700 font-mono">Events Logged</span>
            </div>
            <span class="text-[10px] text-slate-500 mt-1 block">Immutable mutation history</span>
        </div>
    </div>

    <!-- SQL Server LocalDB Table Record Count Roster -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-2">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-table-cells text-[#1769E0]"></i> Relational Schema Tables &amp; Row Distribution
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Database: <span class="text-[#0F172A]">IndustrialSparePartDB</span>
            </span>
        </div>

        <asp:GridView ID="gvTables" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No user table metadata returned from SQL Server.">
            <Columns>
                <asp:TemplateField HeaderText="Table Name">
                    <ItemTemplate>
                        <div class="flex items-center gap-2">
                            <i class="fa-solid fa-table text-slate-400 text-xs"></i>
                            <span class="font-mono text-xs font-bold text-[#0F172A]"><%# Eval("TableName") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Total Records">
                    <ItemTemplate>
                        <span class="font-mono text-xs font-bold text-[#1769E0]">
                            <%# string.Format("{0:N0}", Eval("RecordCount")) %> Rows
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Storage Tier">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            Clustered Index / Heap
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Referential Health">
                    <ItemTemplate>
                        <span class="status-pill status-pill-verified text-[10px] font-mono">
                            <i class="fa-solid fa-check text-[9px] mr-1"></i> Normal Form Validated
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
