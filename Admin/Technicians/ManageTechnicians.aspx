<%@ Page Title="Field Service Technician Roster" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageTechnicians.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Technicians.ManageTechnicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">FIELD ENGINEERING &amp; EMERGENCY SUPPORT</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Service Technician Roster</h1>
            <p class="text-xs text-[#64748B] m-0">Administer certified industrial automation, electrical, and hydraulic technicians available for on-site dispatch.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Register Field Technician" OnClick="btnOpenAddModal_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded border text-xs flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i id="iconAlert" runat="server" class="fa-solid fa-circle-check text-emerald-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Filter & Search Toolbar -->
    <div class="surface-card p-4 mb-6">
        <div class="grid grid-cols-1 sm:grid-cols-12 gap-3 items-center">
            <!-- Search Keyword -->
            <div class="sm:col-span-6 relative">
                <i class="fa-solid fa-magnifying-glass absolute left-3 top-3 text-slate-400 text-xs"></i>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search technician name, skill (e.g. PLC, CNC), or city..." CssClass="form-input pl-8 text-xs py-2" />
            </div>

            <!-- Status Filter -->
            <div class="sm:col-span-3">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" CssClass="form-input text-xs py-2">
                    <asp:ListItem Value="" Text="All Duty &amp; Verification States"></asp:ListItem>
                    <asp:ListItem Value="Available" Text="Available On-Duty"></asp:ListItem>
                    <asp:ListItem Value="Unavailable" Text="Off-Duty / Dispatched"></asp:ListItem>
                    <asp:ListItem Value="Verified" Text="Verified Engineers"></asp:ListItem>
                    <asp:ListItem Value="Pending" Text="Pending Certification"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Action Buttons -->
            <div class="sm:col-span-3 flex items-center gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Filter Roster" OnClick="btnSearch_Click" CssClass="btn-secondary flex-1 text-xs py-2 cursor-pointer" />
                <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" CssClass="btn-secondary text-xs py-2 px-2.5 text-slate-500" ToolTip="Reset Filters">
                    <i class="fa-solid fa-rotate-left"></i>
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <!-- Data Grid Container -->
    <div class="table-container shadow-xs">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-user-wrench text-[#0891B2]"></i> Certified Field Service Engineers
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total: <asp:Label ID="lblTechsCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label> technicians
            </span>
        </div>

        <asp:GridView ID="gvTechnicians" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="TechnicianId,UserId,FullName,Email,PhoneNumber,SkillSummary,ExperienceYears,HourlyRate,Address,City,State,Pincode,IsAvailable,VerificationStatus" 
            OnRowCommand="gvTechnicians_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No field service technicians match the selected criteria.">
            <Columns>
                <asp:BoundField DataField="TechnicianId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                
                <asp:TemplateField HeaderText="Technician">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("FullName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("PhoneNumber") %> | <%# Eval("Email") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Technical Competencies">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px]">
                            <%# Eval("SkillSummary") != DBNull.Value ? Eval("SkillSummary") : "General Industrial Maintenance" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Experience &amp; Rate">
                    <ItemTemplate>
                        <div class="flex flex-col text-xs font-mono">
                            <span class="text-[#0F172A] font-bold"><%# Eval("ExperienceYears") %> yrs exp</span>
                            <span class="text-emerald-700 text-[11px] font-semibold">₹<%# string.Format("{0:N0}", Eval("HourlyRate")) %>/hr</span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Base Location">
                    <ItemTemplate>
                        <span class="text-xs text-[#1E293B]">
                            <i class="fa-solid fa-location-dot text-[10px] text-[#64748B] mr-1"></i><%# Eval("City") %>, <%# Eval("State") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Duty Availability">
                    <ItemTemplate>
                        <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-emergency text-[10px]" %>'>
                            <span class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "w-1.5 h-1.5 rounded-full bg-emerald-500" : "w-1.5 h-1.5 rounded-full bg-rose-500" %>'></span>
                            <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available On-Duty" : "Off-Duty / Engaged" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Verification">
                    <ItemTemplate>
                        <span class='<%# Eval("VerificationStatus").ToString() == "Verified" ? "status-pill status-pill-verified text-[10px]" : "status-pill status-pill-pending text-[10px]" %>'>
                            <%# Eval("VerificationStatus") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-1.5">
                            <asp:LinkButton ID="btnEdit" runat="server" 
                                CommandName="EditTech" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                ToolTip="Edit Engineer Profile">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnToggleDuty" runat="server" 
                                CommandName="ToggleDuty" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "px-2 py-1 text-[11px] font-semibold rounded bg-amber-50 hover:bg-amber-100 text-amber-800 border border-amber-300" : "px-2 py-1 text-[11px] font-semibold rounded bg-emerald-50 hover:bg-emerald-100 text-emerald-800 border border-emerald-300" %>' 
                                ToolTip='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "Set Off-Duty" : "Set Available" %>'>
                                <i class='<%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-solid fa-moon" : "fa-solid fa-bolt" %>'></i>
                                <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Off-Duty" : "On-Duty" %>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- MODAL 1: REGISTER NEW TECHNICIAN -->
    <asp:Panel ID="pnlAddModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-xl p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95 max-h-[90vh] overflow-y-auto">
            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-cyan-50 text-[#0891B2] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-user-wrench"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Register Service Technician</h3>
                </div>
                <asp:LinkButton ID="btnCloseAddModal" runat="server" OnClick="btnCloseAddModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Technician Full Name <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddFullName" runat="server" CssClass="form-input text-xs py-2" placeholder="e.g. Vikram Sharma" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Phone Number <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddPhone" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="+91 98240 55678" />
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Login Email <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddEmail" runat="server" TextMode="Email" CssClass="form-input text-xs py-2 font-mono" placeholder="tech@domain.com" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Initial Password <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddPassword" runat="server" TextMode="Password" CssClass="form-input text-xs py-2 font-mono" placeholder="Minimum 6 characters" />
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Skills &amp; Technical Competencies <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtAddSkills" runat="server" CssClass="form-input text-xs py-2" placeholder="e.g. PLC Automation, Siemens S7-1200, CNC Drives, High-Pressure Hydraulics" />
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Experience (Years) <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddExperience" runat="server" TextMode="Number" CssClass="form-input text-xs py-2 font-mono" placeholder="8" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Hourly Billing Rate (₹) <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddHourlyRate" runat="server" TextMode="Number" CssClass="form-input text-xs py-2 font-mono" placeholder="750" />
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Residential / Workshop Address</label>
                    <asp:TextBox ID="txtAddAddress" runat="server" CssClass="form-input text-xs py-2" placeholder="C-12, Industrial Colony" />
                </div>

                <div class="grid grid-cols-3 gap-3">
                    <div>
                        <label class="form-label text-xs">City <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddCity" runat="server" CssClass="form-input text-xs py-2" placeholder="Vadodara" />
                    </div>
                    <div>
                        <label class="form-label text-xs">State</label>
                        <asp:TextBox ID="txtAddState" runat="server" CssClass="form-input text-xs py-2" placeholder="Gujarat" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Pincode</label>
                        <asp:TextBox ID="txtAddPincode" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="390001" />
                    </div>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" OnClick="btnCloseAddModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitAddTech" runat="server" Text="Register Technician" OnClick="btnSubmitAddTech_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>

    <!-- MODAL 2: EDIT TECHNICIAN PROFILE -->
    <asp:Panel ID="pnlEditModal" runat="server" Visible="false" CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
        <div class="surface-card w-full max-w-xl p-6 shadow-2xl space-y-4 animate-in fade-in zoom-in-95 max-h-[90vh] overflow-y-auto">
            <asp:HiddenField ID="hdnEditTechId" runat="server" />

            <div class="flex items-center justify-between border-b border-[#E2E8F0] pb-3">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded bg-cyan-50 text-[#0891B2] flex items-center justify-center text-xs">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Edit Technician Qualifications</h3>
                </div>
                <asp:LinkButton ID="btnCloseEditModal" runat="server" OnClick="btnCloseEditModal_Click" CssClass="text-slate-400 hover:text-slate-600 text-sm">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <div class="space-y-3">
                <div>
                    <label class="form-label text-xs">Skills &amp; Technical Competencies <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtEditSkills" runat="server" CssClass="form-input text-xs py-2" />
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">Experience (Years) <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtEditExperience" runat="server" TextMode="Number" CssClass="form-input text-xs py-2 font-mono" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Hourly Billing Rate (₹) <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtEditHourlyRate" runat="server" TextMode="Number" CssClass="form-input text-xs py-2 font-mono" />
                    </div>
                </div>

                <div>
                    <label class="form-label text-xs">Base Address</label>
                    <asp:TextBox ID="txtEditAddress" runat="server" CssClass="form-input text-xs py-2" />
                </div>

                <div class="grid grid-cols-3 gap-3">
                    <div>
                        <label class="form-label text-xs">City <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtEditCity" runat="server" CssClass="form-input text-xs py-2" />
                    </div>
                    <div>
                        <label class="form-label text-xs">State</label>
                        <asp:TextBox ID="txtEditState" runat="server" CssClass="form-input text-xs py-2" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Pincode</label>
                        <asp:TextBox ID="txtEditPincode" runat="server" CssClass="form-input text-xs py-2 font-mono" />
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                    <div>
                        <label class="form-label text-xs">Verification Certification</label>
                        <asp:DropDownList ID="ddlEditVerification" runat="server" CssClass="form-input text-xs py-2">
                            <asp:ListItem Value="Verified" Text="Verified Engineer"></asp:ListItem>
                            <asp:ListItem Value="Pending" Text="Pending Certification"></asp:ListItem>
                            <asp:ListItem Value="Rejected" Text="Rejected"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="flex items-center pt-5">
                        <label class="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
                            <asp:CheckBox ID="chkEditIsAvailable" runat="server" />
                            Available On-Duty for Emergency Dispatch
                        </label>
                    </div>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2.5 pt-3 border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCloseEditModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitEditTech" runat="server" Text="Update Technician" OnClick="btnSubmitEditTech_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
