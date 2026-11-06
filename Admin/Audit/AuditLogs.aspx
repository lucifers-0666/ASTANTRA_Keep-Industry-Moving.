<%@ Page Title="Platform Audit Trail & Security Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="AuditLogs.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Audit.AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">SECURITY GOVERNANCE &amp; ACCOUNTABILITY</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Platform Audit Trail &amp; Event Logs</h1>
            <p class="text-xs text-[#64748B] m-0">Immutable transaction log tracking administrative mutations, compliance certifications, and account lifecycle actions.</p>
        </div>
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded text-xs font-mono font-bold bg-rose-50 text-rose-800 border border-rose-200">
                <i class="fa-solid fa-lock text-rose-600"></i> TAMPER-EVIDENT RECORDING
            </span>
        </div>
    </div>

    <!-- Filter & Search Toolbar (Standard Reusable Pattern) -->
    <div class="admin-toolbar rounded-md mb-6 admin-animate-enter admin-stagger-1">
        <div class="admin-filter-group" style="width: 100%; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
            <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                <span class="text-[11px] font-mono font-bold text-slate-500 uppercase">Filters:</span>
                <asp:DropDownList ID="ddlActionFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="admin-filter-select">
                    <asp:ListItem Value="" Text="All Action Types"></asp:ListItem>
                    <asp:ListItem Value="CREATE_USER" Text="CREATE_USER"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_USER" Text="UPDATE_USER"></asp:ListItem>
                    <asp:ListItem Value="DELETE_USER" Text="DELETE_USER"></asp:ListItem>
                    <asp:ListItem Value="TOGGLE_STATUS" Text="TOGGLE_STATUS"></asp:ListItem>
                    <asp:ListItem Value="CREATE_FACTORY" Text="CREATE_FACTORY"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_FACTORY" Text="UPDATE_FACTORY"></asp:ListItem>
                    <asp:ListItem Value="DELETE_FACTORY" Text="DELETE_FACTORY"></asp:ListItem>
                    <asp:ListItem Value="APPROVE_SUPPLIER" Text="APPROVE_SUPPLIER"></asp:ListItem>
                    <asp:ListItem Value="REJECT_SUPPLIER" Text="REJECT_SUPPLIER"></asp:ListItem>
                    <asp:ListItem Value="CREATE_TECHNICIAN" Text="CREATE_TECHNICIAN"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_TECHNICIAN" Text="UPDATE_TECHNICIAN"></asp:ListItem>
                    <asp:ListItem Value="TOGGLE_TECH_DUTY" Text="TOGGLE_TECH_DUTY"></asp:ListItem>
                    <asp:ListItem Value="CREATE_CATEGORY" Text="CREATE_CATEGORY"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_CATEGORY" Text="UPDATE_CATEGORY"></asp:ListItem>
                    <asp:ListItem Value="DELETE_CATEGORY" Text="DELETE_CATEGORY"></asp:ListItem>
                    <asp:ListItem Value="CREATE_MACHINE" Text="CREATE_MACHINE"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_MACHINE" Text="UPDATE_MACHINE"></asp:ListItem>
                    <asp:ListItem Value="DELETE_MACHINE" Text="DELETE_MACHINE"></asp:ListItem>
                    <asp:ListItem Value="CREATE_PART" Text="CREATE_PART"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_PART" Text="UPDATE_PART"></asp:ListItem>
                    <asp:ListItem Value="DELETE_PART" Text="DELETE_PART"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_SOS_STATUS" Text="UPDATE_SOS_STATUS"></asp:ListItem>
                    <asp:ListItem Value="UPDATE_ORDER_STATUS" Text="UPDATE_ORDER_STATUS"></asp:ListItem>
                </asp:DropDownList>

                <asp:DropDownList ID="ddlEntityFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="admin-filter-select">
                    <asp:ListItem Value="" Text="All Target Entities"></asp:ListItem>
                    <asp:ListItem Value="Users" Text="Users"></asp:ListItem>
                    <asp:ListItem Value="Factories" Text="Factories"></asp:ListItem>
                    <asp:ListItem Value="Suppliers" Text="Suppliers"></asp:ListItem>
                    <asp:ListItem Value="Technicians" Text="Technicians"></asp:ListItem>
                    <asp:ListItem Value="Categories" Text="Categories"></asp:ListItem>
                    <asp:ListItem Value="Machines" Text="Machines"></asp:ListItem>
                    <asp:ListItem Value="SpareParts" Text="SpareParts"></asp:ListItem>
                    <asp:ListItem Value="EmergencyRequests" Text="EmergencyRequests"></asp:ListItem>
                    <asp:ListItem Value="Orders" Text="Orders"></asp:ListItem>
                </asp:DropDownList>

                <asp:DropDownList ID="ddlTopCount" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="admin-filter-select font-mono">
                    <asp:ListItem Value="50" Text="Top 50"></asp:ListItem>
                    <asp:ListItem Value="100" Text="Top 100" Selected="True"></asp:ListItem>
                    <asp:ListItem Value="250" Text="Top 250"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div style="display: flex; align-items: center; gap: 8px;">
                <asp:Button ID="btnFilter" runat="server" Text="Refresh Stream" OnClick="btnFilter_Click" CssClass="btn-admin-primary" />
                <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" CssClass="btn-admin-secondary" ToolTip="Reset Filters">
                    <i class="fa-solid fa-rotate-left"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- Data Grid Container -->
    <div class="table-container shadow-xs mb-8 admin-animate-enter admin-stagger-2">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-clipboard-check text-[#E11D48]"></i> Security Audit Log Stream
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Recorded Entries: <asp:Label ID="lblLogsCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label>
            </span>
        </div>

        <asp:GridView ID="gvAuditLogs" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No audit log events match the selected criteria.">
            <Columns>
                <asp:BoundField DataField="LogId" HeaderText="Log #" HeaderStyle-CssClass="w-14 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold text-slate-600" />
                
                <asp:BoundField DataField="CreatedAt" HeaderText="Timestamp" DataFormatString="{0:dd MMM yyyy HH:mm:ss}" HeaderStyle-CssClass="font-mono" ItemStyle-CssClass="font-mono text-xs text-[#0F172A]" />

                <asp:TemplateField HeaderText="Initiating Actor">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("ActorName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("ActorRole") %> | <%# Eval("ActorEmail") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action Type">
                    <ItemTemplate>
                        <span class="font-mono text-[11px] font-bold text-[#0F172A] bg-slate-100 px-2 py-0.5 rounded border border-slate-300">
                            <%# Eval("ActionType") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Target Entity">
                    <ItemTemplate>
                        <div class="flex items-center gap-1.5 font-mono text-xs">
                            <span class="spec-tag spec-tag-blue text-[10px]"><%# Eval("TargetEntity") %></span>
                            <span class="text-slate-500 font-semibold">#<%# Eval("EntityId") != DBNull.Value ? Eval("EntityId") : "-" %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Audit Mutation Payload">
                    <ItemTemplate>
                        <div class="flex flex-col font-mono text-[11px] max-w-md">
                            <%# Eval("OldValue") != DBNull.Value && !string.IsNullOrEmpty(Eval("OldValue").ToString()) ? "<span class='text-rose-600 text-[10px] truncate'>Old: " + Eval("OldValue") + "</span>" : "" %>
                            <%# Eval("NewValue") != DBNull.Value && !string.IsNullOrEmpty(Eval("NewValue").ToString()) ? "<span class='text-emerald-700 text-[10px] truncate'>New: " + Eval("NewValue") + "</span>" : "<span class='text-slate-400'>-</span>" %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="IpAddress" HeaderText="Source IP" ItemStyle-CssClass="font-mono text-xs text-[#64748B]" NullDisplayText="127.0.0.1" />
            </Columns>
        </asp:GridView>
    </div>

    <!-- Governance Compliance Footer Card -->
    <div class="surface-card p-5 bg-[#0F172A] text-white border-slate-700 space-y-3">
        <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <div class="flex items-center gap-2">
                <i class="fa-solid fa-scale-balanced text-amber-400 text-sm"></i>
                <span class="text-xs font-bold font-mono text-amber-400 tracking-wider">ACADEMIC &amp; VIVA COMPLIANCE DEFENSE</span>
            </div>
            <span class="spec-tag spec-tag-blue text-[9px]">ISO 27001 GOVERNANCE</span>
        </div>
        <p class="text-xs text-slate-300 m-0 leading-relaxed">
            All administrative operations executed across User Management, Factory Directories, Supplier Verifications, Component Taxonomies, and Incident Triage automatically emit structured records into the SQL Server LocalDB <code class="text-amber-300">AuditLogs</code> table using the professor's <code class="text-[#38BDF8]">AuditLogic.logAction(...)</code> method.
        </p>
    </div>
</asp:Content>

