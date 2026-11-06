<%@ Page Title="Login & Session Security Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="LoginSecurity.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Security.LoginSecurity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">SECURITY GOVERNANCE &amp; SESSIONS</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Authentication &amp; Session Security Stream</h1>
            <p class="text-xs text-[#64748B] m-0">Real-time surveillance of authentication events, credential rotations, session validations, and access attempts.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span> SESSION SHIELD ACTIVE
            </span>
        </div>
    </div>

    <!-- Security Configuration Telemetry Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6 admin-animate-enter admin-stagger-1">
        <div class="surface-card p-4 border-l-4 border-l-[#1769E0]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Password Hashing</span>
            <span class="text-sm font-black font-mono text-[#0F172A] mt-1 block">SHA-256 + Salt</span>
            <span class="text-[10px] text-slate-500 mt-1 block">Cryptographic 32-byte salt</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#059669]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Cookie Protection</span>
            <span class="text-sm font-black font-mono text-emerald-700 mt-1 block">HttpOnly Enabled</span>
            <span class="text-[10px] text-slate-500 mt-1 block">Mitigates script theft</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#D97706]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Session Engine</span>
            <span class="text-sm font-black font-mono text-amber-700 mt-1 block">In-Proc Session</span>
            <span class="text-[10px] text-slate-500 mt-1 block">20-minute sliding timeout</span>
        </div>

        <div class="surface-card p-4 border-l-4 border-l-[#7C3AED]">
            <span class="text-[10px] font-mono font-bold text-[#64748B] uppercase block">Defense Gate</span>
            <span class="text-sm font-black font-mono text-purple-700 mt-1 block">BasePage RBAC</span>
            <span class="text-[10px] text-slate-500 mt-1 block">Strict role isolation</span>
        </div>
    </div>

    <!-- Live Authentication Security Log -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-2">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-user-shield text-[#1769E0]"></i> Live Authentication &amp; Access Events Stream
            </h2>
            <div class="flex items-center gap-3">
                <asp:LinkButton ID="btnRefresh" runat="server" OnClick="btnRefresh_Click" CssClass="btn-secondary text-xs py-1.5 px-2.5">
                    <i class="fa-solid fa-arrows-rotate mr-1"></i> Refresh Stream
                </asp:LinkButton>
            </div>
        </div>

        <asp:GridView ID="gvSecurityLogs" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No recent authentication security events logged.">
            <Columns>
                <asp:BoundField DataField="LogId" HeaderText="Log #" HeaderStyle-CssClass="w-14 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-slate-600" />
                
                <asp:BoundField DataField="CreatedAt" HeaderText="Timestamp" DataFormatString="{0:dd MMM yyyy HH:mm:ss}" HeaderStyle-CssClass="font-mono" ItemStyle-CssClass="font-mono text-xs text-[#0F172A]" />

                <asp:TemplateField HeaderText="User Account">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("ActorName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("ActorEmail") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Security Event">
                    <ItemTemplate>
                        <span class="font-mono text-[11px] font-bold text-[#0F172A] bg-slate-100 px-2 py-0.5 rounded border border-slate-300">
                            <%# Eval("ActionType") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Target Scope">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            <%# Eval("TargetEntity") %> #<%# Eval("EntityId") != DBNull.Value ? Eval("EntityId") : "-" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="IpAddress" HeaderText="Client IP" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" NullDisplayText="127.0.0.1" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
