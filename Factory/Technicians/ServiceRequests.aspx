<%@ Page Title="Field Maintenance &amp; Technicians" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="ServiceRequests.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Technicians.ServiceRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Book certified on-site maintenance technicians, track machine breakdown triage visits, and review service logs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Command Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-user-gear mr-1"></i> Field Engineering Services
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Field Maintenance &amp; Engineer Bookings
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Dispatch certified industrial engineers for emergency breakdown troubleshooting, spare part installation, and plant overhaul.
                </p>
            </div>
            <asp:Button ID="btnOpenBookingForm" runat="server" Text="+ Book Maintenance Visit" OnClick="btnOpenBookingForm_Click" CssClass="btn-primary text-xs py-2 px-3.5 font-bold" />
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Booking Modal / Panel -->
    <asp:Panel ID="pnlBooking" runat="server" Visible="false" CssClass="factory-modal-backdrop">
        <div class="factory-modal-dialog">
            <div class="p-4 bg-slate-900 text-white flex justify-between items-center">
                <div>
                    <span class="text-[10px] font-mono uppercase text-sky-400 font-bold block">On-Site Technical Service Dispatch</span>
                    <h3 class="text-sm font-bold m-0 text-white">Book Certified Service Engineer</h3>
                </div>
                <asp:LinkButton ID="btnCloseBooking" runat="server" OnClick="btnCloseBooking_Click" CssClass="text-slate-400 hover:text-white text-lg">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="p-5 space-y-4 text-xs">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label" for="<%= ddlTechnicians.ClientID %>">Available Service Engineer <span class="text-rose-500">*</span></label>
                        <asp:DropDownList ID="ddlTechnicians" runat="server" CssClass="form-select font-medium"></asp:DropDownList>
                    </div>
                    <div>
                        <label class="form-label" for="<%= ddlServiceType.ClientID %>">Service Category <span class="text-rose-500">*</span></label>
                        <asp:DropDownList ID="ddlServiceType" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Emergency Machine Breakdown" Value="Emergency Repair"></asp:ListItem>
                            <asp:ListItem Text="Spare-Part Replacement / Installation" Value="Part Installation"></asp:ListItem>
                            <asp:ListItem Text="Preventative Plant Maintenance" Value="Preventative"></asp:ListItem>
                            <asp:ListItem Text="Hydraulic / Pneumatic Inspection" Value="Inspection"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div>
                    <label class="form-label" for="<%= txtScheduledDate.ClientID %>">Preferred Visit Date <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtScheduledDate" runat="server" TextMode="Date" CssClass="form-input"></asp:TextBox>
                </div>

                <div>
                    <label class="form-label" for="<%= txtIssueDescription.ClientID %>">Breakdown Symptoms / Problem Description <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtIssueDescription" runat="server" TextMode="MultiLine" Rows="3" placeholder="Describe error codes, machine sound, oil leaks, pressure drops, or electrical trips..." CssClass="form-textarea"></asp:TextBox>
                </div>

                <div class="flex justify-end gap-2.5 pt-3 border-t border-slate-100">
                    <asp:Button ID="btnCancelBooking" runat="server" Text="Cancel" OnClick="btnCloseBooking_Click" CssClass="btn-secondary" />
                    <asp:Button ID="btnSubmitServiceRequest" runat="server" Text="Confirm Dispatch Request" OnClick="btnSubmitServiceRequest_Click" CssClass="btn-primary" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Filters Bar -->
    <div class="factory-card p-4 mb-6">
        <div class="flex flex-col sm:flex-row gap-3 items-stretch sm:items-center justify-between">
            <div class="flex flex-1 flex-col sm:flex-row gap-3">
                <div class="relative flex-1">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none text-slate-400">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input pl-9" placeholder="Search by technician name, specialization or symptom..."></asp:TextBox>
                </div>
                <div class="w-full sm:w-48">
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                        <asp:ListItem Text="All Statuses" Value=""></asp:ListItem>
                        <asp:ListItem Text="Requested" Value="Requested"></asp:ListItem>
                        <asp:ListItem Text="Accepted" Value="Accepted"></asp:ListItem>
                        <asp:ListItem Text="In Progress" Value="In Progress"></asp:ListItem>
                        <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                        <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="flex gap-2">
                <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click" CssClass="btn-secondary text-xs px-3 py-1.5" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn-secondary text-xs px-3 py-1.5" />
            </div>
        </div>
    </div>

    <!-- Requests History Grid -->
    <div class="factory-card overflow-hidden">
        <div class="p-4 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
            <h2 class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 m-0">
                Service Visit History (<strong id="lblServiceCount" runat="server" class="text-slate-900">0</strong>)
            </h2>
            <span class="text-[11px] text-slate-400 font-mono">Real-time status updates from assigned field engineers</span>
        </div>

        <div class="overflow-x-auto">
            <asp:GridView ID="gvServices" runat="server" AutoGenerateColumns="False" DataKeyNames="ServiceRequestId" CssClass="factory-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Ticket #" ItemStyle-CssClass="font-mono font-bold text-[#1769E0]">
                        <ItemTemplate>
                            SRV-<%# Convert.ToInt32(Eval("ServiceRequestId")).ToString("D5") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Assigned Engineer">
                        <ItemTemplate>
                            <strong class="text-slate-900 block font-medium"><%# Eval("TechnicianName") %></strong>
                            <span class="text-slate-400 font-mono text-[11px]"><%# Eval("TechnicianCity") %> &middot; ₹<%# Convert.ToDecimal(Eval("HourlyRate")).ToString("N0") %>/hr</span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ServiceType" HeaderText="Service Category" ItemStyle-CssClass="font-medium text-slate-800" />
                    <asp:BoundField DataField="IssueDescription" HeaderText="Problem Description" ItemStyle-CssClass="text-[11px] text-slate-600 max-w-sm truncate" />
                    <asp:BoundField DataField="ScheduledDate" HeaderText="Scheduled Visit" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="font-mono text-slate-700" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge-status <%# Eval("ServiceStatus").ToString() == "Completed" ? "badge-delivered" : (Eval("ServiceStatus").ToString() == "Accepted" ? "badge-processing" : "badge-pending") %>'>
                                <%# Eval("ServiceStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="p-8 text-center text-slate-400">
                        <i class="fa-solid fa-user-gear text-3xl mb-2 text-slate-300 block"></i>
                        <p class="text-xs font-semibold text-slate-700 m-0">No technician service requests booked yet.</p>
                        <span class="text-[11px] text-slate-400">Schedule certified maintenance engineers for equipment inspection or emergency repairs.</span>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>