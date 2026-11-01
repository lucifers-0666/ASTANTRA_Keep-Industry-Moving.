<%@ Page Title="Technician Service Requests" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="ServiceRequests.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Technicians.ServiceRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Book certified on-site maintenance technicians, track machine breakdown triage visits, and review service logs." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Page Header -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="status-pill status-pill-verified text-[10px] mb-1.5 inline-block">ON-SITE MAINTENANCE DISPATCH</span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-[#17212F] tracking-tight m-0">
                    Field Maintenance & Technician Bookings
                </h1>
                <p class="text-xs text-[#5F6B7A] m-0 mt-1">
                    Book certified field technicians for emergency machine repairs, part installations, and preventative servicing.
                </p>
            </div>
            <asp:Button ID="btnOpenBookingForm" runat="server" Text="+ Book Maintenance Visit" OnClick="btnOpenBookingForm_Click" CssClass="btn-primary text-xs py-2 px-4 font-bold cursor-pointer" />
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-[3px] bg-[#E8F5F0] border border-[#A7F3D0] text-xs text-[#17212F] flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-[#18865B] text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Action completed."></asp:Label>
        </div>
    </asp:Panel>

    <!-- Booking Panel -->
    <asp:Panel ID="pnlBooking" runat="server" Visible="false" CssClass="bg-[#F8FAFC] border-2 border-[#1769E0] rounded-[3px] p-6 mb-6 shadow-md">
        <div class="flex justify-between items-center mb-4 pb-3 border-b border-[#D5DCE3]">
            <h3 class="text-base font-bold text-[#17212F] m-0">Book Qualified Technician</h3>
            <asp:Button ID="btnCloseBooking" runat="server" Text="✕ Close" OnClick="btnCloseBooking_Click" CssClass="text-xs text-[#5F6B7A] hover:text-[#17212F] bg-transparent border-0 cursor-pointer font-bold" />
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Select Available Specialist <span class="text-red-500">*</span></label>
                <asp:DropDownList ID="ddlTechnicians" runat="server" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Service Type <span class="text-red-500">*</span></label>
                <asp:DropDownList ID="ddlServiceType" runat="server" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]">
                    <asp:ListItem Text="Emergency Machine Breakdown" Value="Emergency Repair"></asp:ListItem>
                    <asp:ListItem Text="Spare-Part Replacement / Installation" Value="Part Installation"></asp:ListItem>
                    <asp:ListItem Text="Preventative Plant Maintenance" Value="Preventative"></asp:ListItem>
                    <asp:ListItem Text="Hydraulic / Pneumatic Inspection" Value="Inspection"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <label class="block text-xs font-bold text-[#17212F] mb-1">Preferred Date <span class="text-red-500">*</span></label>
                <asp:TextBox ID="txtScheduledDate" runat="server" TextMode="Date" CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
            </div>
        </div>

        <div class="mb-4">
            <label class="block text-xs font-bold text-[#17212F] mb-1">Breakdown Symptoms / Problem Description <span class="text-red-500">*</span></label>
            <asp:TextBox ID="txtIssueDescription" runat="server" TextMode="MultiLine" Rows="2" placeholder="Describe error codes, machine sound, oil leaks, pressure drops, or electrical trips..." CssClass="w-full text-xs px-3 py-2 border border-[#D5DCE3] rounded-[3px]"></asp:TextBox>
        </div>

        <div class="flex justify-end gap-3">
            <asp:Button ID="btnCancelBooking" runat="server" Text="Cancel" OnClick="btnCloseBooking_Click" CssClass="btn-secondary text-xs py-2 px-4 font-bold cursor-pointer" />
            <asp:Button ID="btnSubmitServiceRequest" runat="server" Text="Dispatch Service Request" OnClick="btnSubmitServiceRequest_Click" CssClass="btn-primary text-xs py-2 px-5 font-bold cursor-pointer" />
        </div>
    </asp:Panel>

    <!-- Requests History Grid -->
    <div class="bg-white rounded-[3px] border border-[#D5DCE3] shadow-xs overflow-hidden">
        <div class="p-4 border-b border-[#D5DCE3] bg-[#FAFAFA] flex justify-between items-center">
            <h2 class="text-xs font-bold font-['Archivo',sans-serif] uppercase tracking-wider text-[#17212F] m-0">
                Service Visit History (<asp:Label ID="lblServiceCount" runat="server" Text="0"></asp:Label>)
            </h2>
        </div>

        <asp:GridView ID="gvServices" runat="server" AutoGenerateColumns="False" DataKeyNames="ServiceRequestId" CssClass="w-full text-left text-xs border-collapse">
            <HeaderStyle CssClass="bg-[#F1F3F5] text-[#5F6B7A] font-bold text-[11px] uppercase tracking-wider border-b border-[#D5DCE3] p-3" />
            <RowStyle CssClass="border-b border-[#E1E6EB] hover:bg-[#F8FAFC]" />
            <Columns>
                <asp:TemplateField HeaderText="Ticket #" ItemStyle-CssClass="p-3 font-mono font-bold text-[#1769E0]">
                    <ItemTemplate>
                        SRV-<%# Convert.ToInt32(Eval("ServiceRequestId")).ToString("D5") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TechnicianName" HeaderText="Technician" ItemStyle-CssClass="p-3 font-semibold text-[#17212F]" />
                <asp:BoundField DataField="ServiceType" HeaderText="Service Type" ItemStyle-CssClass="p-3 text-[#17212F]" />
                <asp:BoundField DataField="IssueDescription" HeaderText="Issue Details" ItemStyle-CssClass="p-3 text-[#5F6B7A] max-w-sm truncate" />
                <asp:BoundField DataField="ScheduledDate" HeaderText="Scheduled Date" DataFormatString="{0:dd-MMM-yyyy}" ItemStyle-CssClass="p-3 text-[#5F6B7A]" />
                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="p-3">
                    <ItemTemplate>
                        <span class="status-pill <%# Eval("ServiceStatus").ToString() == "Completed" ? "bg-emerald-100 text-emerald-800 border-emerald-300" : Eval("ServiceStatus").ToString() == "Accepted" ? "bg-blue-100 text-blue-800 border-blue-300" : "bg-amber-100 text-amber-800 border-amber-300" %> text-[10px]">
                            <%# Eval("ServiceStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="p-8 text-center text-[#5F6B7A]">
                    <i class="fa-solid fa-wrench text-2xl text-[#94A3B8] mb-2 block"></i>
                    <p class="text-xs font-semibold m-0">No technician service requests booked yet.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>

