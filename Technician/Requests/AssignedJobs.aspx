<%@ Page Title="Assigned Service Calls" Language="C#" MasterPageFile="~/MasterPages/Technician.Master" AutoEventWireup="true" CodeBehind="AssignedJobs.aspx.cs" Inherits="IndustrialSparePartPortal.Technician.Requests.AssignedJobs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="View assigned on-site machinery maintenance service bookings, diagnostic notes, and work completion tracking." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">FIELD SERVICE &amp; MAINTENANCE</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Assigned Maintenance Calls
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Manage on-site machinery service assignments, plant customer contact information, and record diagnostic work notes.
                </p>
            </div>
            <a href="~/Technician/Dashboard.aspx" runat="server" class="btn-secondary text-xs py-2 px-3 font-bold">
                <i class="fa-solid fa-arrow-left mr-1"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text=""></asp:Label>
        </div>
    </asp:Panel>

    <!-- Job Status Update Panel -->
    <asp:Panel ID="pnlUpdateJob" runat="server" Visible="false" CssClass="bg-white rounded-[3px] border border-[#1769E0] p-6 mb-6 shadow-md text-left">
        <div class="flex justify-between items-center mb-4 pb-2 border-b border-[#E2E8F0]">
            <h2 class="text-sm font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Update Service Status &middot; Call #<asp:Label ID="lblCallIdDisp" runat="server" Text=""></asp:Label>
            </h2>
            <span class="text-xs text-[#5F6B7A]">Plant: <strong id="lblPlantNameDisp" runat="server" class="text-[#17212F]"></strong></span>
        </div>
        <asp:HiddenField ID="hfSelectedRequestId" runat="server" />

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Execution Status *</label>
                <asp:DropDownList ID="ddlJobStatus" runat="server" CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0]">
                    <asp:ListItem Value="Scheduled" Text="Scheduled / Confirmed"></asp:ListItem>
                    <asp:ListItem Value="In-Progress" Text="In-Progress (On Site)"></asp:ListItem>
                    <asp:ListItem Value="Completed" Text="Completed / Operational"></asp:ListItem>
                    <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-semibold text-[#17212F] mb-1">Diagnostic Report / Resolution Notes</label>
                <asp:TextBox ID="txtDiagnosisNotes" runat="server" TextMode="MultiLine" Rows="2" placeholder="Replaced hydraulic seal, pressure test passed at 180 bar..." CssClass="w-full text-xs p-2 border border-[#CBD5E1] rounded-[3px] focus:border-[#1769E0]"></asp:TextBox>
            </div>
        </div>

        <div class="flex gap-2">
            <asp:Button ID="btnSaveJobStatus" runat="server" Text="Update Service Call" OnClick="btnSaveJobStatus_Click"
                CssClass="btn-primary text-xs py-2 px-4 font-bold bg-[#1769E0] hover:bg-[#1254B7] cursor-pointer" />
            <asp:Button ID="btnCancelJob" runat="server" Text="Cancel" OnClick="btnCancelJob_Click"
                CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- Jobs Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden text-left">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Service Call Log (<asp:Label ID="lblJobsCount" runat="server" Text="0"></asp:Label>)
            </h2>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" CssClass="text-xs px-2.5 py-1.5 border border-[#D5DCE3] rounded-[3px]">
                <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                <asp:ListItem Value="Requested" Text="Requested"></asp:ListItem>
                <asp:ListItem Value="Scheduled" Text="Scheduled"></asp:ListItem>
                <asp:ListItem Value="In-Progress" Text="In-Progress"></asp:ListItem>
                <asp:ListItem Value="Completed" Text="Completed"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <asp:GridView ID="gvJobs" runat="server" AutoGenerateColumns="False" DataKeyNames="ServiceRequestId,FactoryName,ServiceStatus" OnRowCommand="gvJobs_RowCommand" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:BoundField DataField="ServiceRequestId" HeaderText="Call #" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]" />
                <asp:TemplateField HeaderText="Manufacturing Plant" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <div class="font-semibold text-[#17212F]"><%# Eval("FactoryName") %></div>
                        <div class="text-[11px] text-[#5F6B7A]"><%# Eval("FactoryCity") %> &middot; <%# Eval("FactoryAddress") %></div>
                        <div class="text-[11px] text-[#1769E0] font-mono"><i class="fa-solid fa-phone text-[9px] mr-1"></i><%# Eval("ContactPerson") %> (<%# Eval("FactoryPhone") %>)</div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ServiceType" HeaderText="Service Domain" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="IssueDescription" HeaderText="Breakdown Diagnostics" ItemStyle-CssClass="p-3 text-[#5F6B7A] max-w-xs" />
                <asp:TemplateField HeaderText="Scheduled Date" ItemStyle-CssClass="p-3 font-mono text-[11px] text-[#17212F]">
                    <ItemTemplate>
                        <%# Convert.ToDateTime(Eval("ScheduledDate")).ToString("yyyy-MM-dd HH:mm") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("ServiceStatus").ToString() == "Completed" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("ServiceStatus").ToString() == "In-Progress" ? "bg-blue-100 text-blue-800 border-blue-300" : "bg-amber-100 text-amber-800 border-amber-300" %> text-[10px]">
                            <%# Eval("ServiceStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <asp:Button ID="btnManage" runat="server" Text="Update Status" CommandName="UpdateJob" CommandArgument="<%# Container.DataItemIndex %>"
                            CssClass="btn-secondary text-[10px] py-1 px-2.5 font-bold cursor-pointer text-[#1769E0] hover:text-[#1254B7]" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-toolbox text-3xl mb-2 text-[#CBD5E1]"></i>
                    <p class="text-xs font-semibold">No assigned service maintenance calls at this time.</p>
                    <p class="text-[11px] text-[#94A3B8] m-0">When factories schedule diagnostic visits, they will appear here automatically.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

