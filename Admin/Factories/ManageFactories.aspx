<%@ Page Title="Industrial Plant Buyer Registry" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="ManageFactories.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Factories.ManageFactories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">PROCUREMENT BUYER ECOSYSTEM</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Industrial Plant Buyer Registry</h1>
            <p class="text-xs text-[#64748B] m-0">Oversee manufacturing facilities, chemical plants, and heavy engineering buyers actively issuing RFQs.</p>
        </div>
        <div class="flex items-center gap-2">
            <asp:Button ID="btnOpenAddModal" runat="server" Text="+ Register Industrial Plant" OnClick="btnOpenAddModal_Click" CssClass="btn-primary text-xs py-2 px-3 cursor-pointer" />
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-3.5 mb-5 rounded border text-xs flex items-center justify-between admin-animate-enter">
        <div class="flex items-center gap-2">
            <i id="iconAlert" runat="server" class="fa-solid fa-circle-check text-emerald-600"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Filter & Search Toolbar (Standard Reusable Pattern) -->
    <div class="admin-toolbar rounded-md mb-6 admin-animate-enter admin-stagger-1">
        <div class="admin-search-box">
            <i class="fa-solid fa-magnifying-glass"></i>
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Search plant name, GSTIN, contact person, or email..." />
        </div>

        <div class="admin-filter-group">
            <asp:TextBox ID="txtCityFilter" runat="server" placeholder="Filter by City (e.g. Ahmedabad)" CssClass="admin-filter-select" />
            <asp:Button ID="btnSearch" runat="server" Text="Filter Plants" OnClick="btnSearch_Click" CssClass="btn-admin-primary" />
            <asp:LinkButton ID="btnReset" runat="server" OnClick="btnReset_Click" CssClass="btn-admin-secondary" ToolTip="Reset Filters">
                <i class="fa-solid fa-rotate-left"></i>
            </asp:LinkButton>
        </div>
    </div>

    <!-- Data Grid Container -->
    <div class="table-container shadow-xs admin-animate-enter admin-stagger-2">
        <div class="px-5 py-3.5 border-b border-[#CBD5E1] flex justify-between items-center bg-white">
            <h2 class="text-xs font-bold text-[#0F172A] uppercase tracking-wider font-mono m-0 flex items-center gap-2">
                <i class="fa-solid fa-industry text-[#D97706]"></i> Registered Manufacturing Facilities
            </h2>
            <span class="text-xs font-mono font-bold text-[#64748B]">
                Total: <asp:Label ID="lblFactoriesCount" runat="server" Text="0" CssClass="text-[#0F172A]"></asp:Label> plants
            </span>
        </div>

        <asp:GridView ID="gvFactories" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="FactoryId,UserId,CompanyName,IndustryType,Address,City,State,Pincode,Gstin,ContactPerson,Email,PhoneNumber" 
            OnRowCommand="gvFactories_RowCommand" 
            CssClass="table-custom" GridLines="None" 
            EmptyDataText="No registered industrial manufacturing plants match the current filter.">
            <Columns>
                <asp:BoundField DataField="FactoryId" HeaderText="ID" HeaderStyle-CssClass="w-12 font-mono" ItemStyle-CssClass="font-mono text-xs font-bold" />
                
                <asp:TemplateField HeaderText="Manufacturing Plant">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-bold text-xs text-[#0F172A]"><%# Eval("CompanyName") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("City") %>, <%# Eval("State") %> - <%# Eval("Pincode") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Industry Sector">
                    <ItemTemplate>
                        <span class="spec-tag spec-tag-blue text-[10px] font-mono">
                            <%# Eval("IndustryType") != DBNull.Value ? Eval("IndustryType") : "General Heavy Engineering" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="GSTIN / Compliance">
                    <ItemTemplate>
                        <span class="font-mono text-xs text-[#1E293B]">
                            <%# Eval("Gstin") != DBNull.Value && !string.IsNullOrEmpty(Eval("Gstin").ToString()) ? Eval("Gstin") : "NOT ENTERED" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Authorized Liaison">
                    <ItemTemplate>
                        <div class="flex flex-col">
                            <span class="font-semibold text-xs text-[#0F172A]"><%# Eval("ContactPerson") %></span>
                            <span class="text-[10px] text-[#64748B] font-mono"><%# Eval("PhoneNumber") %> | <%# Eval("Email") %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Procurement Telemetry">
                    <ItemTemplate>
                        <div class="flex items-center gap-2 text-[11px] font-mono">
                            <span class="text-indigo-700 bg-indigo-50 px-1.5 py-0.5 rounded border border-indigo-200">
                                <%# Eval("TotalRfqs") %> RFQs
                            </span>
                            <span class="text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">
                                <%# Eval("TotalOrders") %> Orders
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-right">
                    <ItemTemplate>
                        <div class="flex items-center justify-end gap-1.5">
                            <asp:LinkButton ID="btnEdit" runat="server" 
                                CommandName="EditFactory" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300" 
                                ToolTip="Edit Facility Data">
                                <i class="fa-solid fa-pen-to-square"></i> Edit
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnDelete" runat="server" 
                                CommandName="DeleteFactory" 
                                CommandArgument='<%# Container.DataItemIndex %>' 
                                OnClientClick="return confirm('WARNING: Are you sure you want to permanently delete this Industrial Plant and its user account?');" 
                                CssClass="px-2 py-1 text-[11px] font-semibold rounded bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200" 
                                ToolTip="Delete Plant Record">
                                <i class="fa-solid fa-trash-can"></i>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- MODAL 1: REGISTER NEW INDUSTRIAL PLANT -->
    <asp:Panel ID="pnlAddModal" runat="server" Visible="false" CssClass="admin-modal-overlay">
        <div class="admin-modal-dialog surface-card w-full max-w-xl shadow-2xl">
            <!-- Modal Pinned Header -->
            <div class="admin-modal-header border-b border-[#E2E8F0]">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded bg-amber-50 text-[#D97706] flex items-center justify-center text-xs shadow-xs border border-amber-200">
                        <i class="fa-solid fa-industry"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Register New Industrial Plant</h3>
                        <span class="text-[10px] font-mono text-[#64748B] block mt-0.5">BUYER PROCUREMENT ACCOUNT &amp; FACILITY PROVISIONING</span>
                    </div>
                </div>
                <asp:LinkButton ID="btnCloseAddModal" runat="server" OnClick="btnCloseAddModal_Click" CssClass="admin-modal-close-btn" ToolTip="Close dialog">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <!-- Modal Scrollable Body -->
            <div class="admin-modal-body space-y-4">
                <!-- Section 1: Enterprise Profile -->
                <div>
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-building"></i> 1. Manufacturing Enterprise Identity
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="form-label text-xs">Company / Plant Name <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddCompanyName" runat="server" CssClass="form-input text-xs" placeholder="e.g. Gujarat Heavy Machinery Works" />
                        </div>
                        <div>
                            <label class="form-label text-xs">Industry Sector <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddIndustryType" runat="server" CssClass="form-input text-xs" placeholder="e.g. Petrochemical, Automotive, Steel" />
                        </div>
                    </div>
                </div>

                <!-- Section 2: Platform Credentials & Representative -->
                <div class="pt-2">
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-user-lock"></i> 2. Platform Authentication &amp; Representative
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-3">
                        <div>
                            <label class="form-label text-xs">Login Email <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddEmail" runat="server" TextMode="Email" CssClass="form-input text-xs font-mono" placeholder="procurement@plant.com" />
                            <span class="admin-form-hint">Used for primary login and RFQ dispatch alerts</span>
                        </div>
                        <div>
                            <label class="form-label text-xs">Initial Password <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddPassword" runat="server" TextMode="Password" CssClass="form-input text-xs font-mono" placeholder="Minimum 6 characters" />
                            <span class="admin-form-hint">Temporary credential; user can change after login</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="form-label text-xs">Authorized Contact Person <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddContactPerson" runat="server" CssClass="form-input text-xs" placeholder="e.g. Rajesh Shah (Plant Head)" />
                        </div>
                        <div>
                            <label class="form-label text-xs">Contact Phone Number <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddPhone" runat="server" CssClass="form-input text-xs font-mono" placeholder="+91 98250 12345" />
                        </div>
                    </div>
                </div>

                <!-- Section 3: Facility Location & Statutory Tax -->
                <div class="pt-2">
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-location-dot"></i> 3. Facility Location &amp; Statutory GSTIN
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-xs">Plant Facility Address</label>
                        <asp:TextBox ID="txtAddAddress" runat="server" CssClass="form-input text-xs" placeholder="Plot No. 42, GIDC Industrial Estate, Phase II" />
                    </div>

                    <div class="grid grid-cols-3 gap-3 mb-3">
                        <div>
                            <label class="form-label text-xs">City <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtAddCity" runat="server" CssClass="form-input text-xs" placeholder="Ahmedabad" />
                        </div>
                        <div>
                            <label class="form-label text-xs">State</label>
                            <asp:TextBox ID="txtAddState" runat="server" CssClass="form-input text-xs" placeholder="Gujarat" />
                        </div>
                        <div>
                            <label class="form-label text-xs">Pincode</label>
                            <asp:TextBox ID="txtAddPincode" runat="server" CssClass="form-input text-xs font-mono" placeholder="382445" />
                        </div>
                    </div>

                    <div>
                        <label class="form-label text-xs">GSTIN Tax Registration Number</label>
                        <asp:TextBox ID="txtAddGstin" runat="server" CssClass="form-input text-xs font-mono uppercase" placeholder="24AAACG1234F1Z5" />
                        <span class="admin-form-hint">15-character statutory alphanumeric GST identifier</span>
                    </div>
                </div>
            </div>

            <!-- Modal Pinned Footer -->
            <div class="admin-modal-footer border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" OnClick="btnCloseAddModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitAddFactory" runat="server" Text="Register Plant Facility" OnClick="btnSubmitAddFactory_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>

    <!-- MODAL 2: EDIT INDUSTRIAL PLANT -->
    <asp:Panel ID="pnlEditModal" runat="server" Visible="false" CssClass="admin-modal-overlay">
        <div class="admin-modal-dialog surface-card w-full max-w-xl shadow-2xl">
            <asp:HiddenField ID="hdnEditFactoryId" runat="server" />

            <!-- Modal Pinned Header -->
            <div class="admin-modal-header border-b border-[#E2E8F0]">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded bg-amber-50 text-[#D97706] flex items-center justify-center text-xs shadow-xs border border-amber-200">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Edit Plant Profile</h3>
                        <span class="text-[10px] font-mono text-[#64748B] block mt-0.5">UPDATE FACILITY SPECIFICATIONS &amp; STATUTORY DETAILS</span>
                    </div>
                </div>
                <asp:LinkButton ID="btnCloseEditModal" runat="server" OnClick="btnCloseEditModal_Click" CssClass="admin-modal-close-btn" ToolTip="Close dialog">
                    <i class="fa-solid fa-xmark"></i>
                </asp:LinkButton>
            </div>

            <!-- Modal Scrollable Body -->
            <div class="admin-modal-body space-y-4">
                <!-- Section 1: Enterprise Profile -->
                <div>
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-building"></i> 1. Manufacturing Enterprise Identity
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="form-label text-xs">Company / Plant Name <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtEditCompanyName" runat="server" CssClass="form-input text-xs" />
                        </div>
                        <div>
                            <label class="form-label text-xs">Industry Sector</label>
                            <asp:TextBox ID="txtEditIndustryType" runat="server" CssClass="form-input text-xs" />
                        </div>
                    </div>
                </div>

                <!-- Section 2: Contact & Tax -->
                <div class="pt-2">
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-user-tie"></i> 2. Authorized Representative &amp; Compliance
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="form-label text-xs">Authorized Contact Person <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtEditContactPerson" runat="server" CssClass="form-input text-xs" />
                        </div>
                        <div>
                            <label class="form-label text-xs">GSTIN Tax Registration</label>
                            <asp:TextBox ID="txtEditGstin" runat="server" CssClass="form-input text-xs font-mono uppercase" />
                        </div>
                    </div>
                </div>

                <!-- Section 3: Physical Location -->
                <div class="pt-2">
                    <div class="admin-form-section-title">
                        <i class="fa-solid fa-location-dot"></i> 3. Facility Physical Location
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-xs">Facility Address</label>
                        <asp:TextBox ID="txtEditAddress" runat="server" CssClass="form-input text-xs" />
                    </div>

                    <div class="grid grid-cols-3 gap-3">
                        <div>
                            <label class="form-label text-xs">City <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtEditCity" runat="server" CssClass="form-input text-xs" />
                        </div>
                        <div>
                            <label class="form-label text-xs">State</label>
                            <asp:TextBox ID="txtEditState" runat="server" CssClass="form-input text-xs" />
                        </div>
                        <div>
                            <label class="form-label text-xs">Pincode</label>
                            <asp:TextBox ID="txtEditPincode" runat="server" CssClass="form-input text-xs font-mono" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Pinned Footer -->
            <div class="admin-modal-footer border-t border-[#E2E8F0]">
                <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="btnCloseEditModal_Click" CssClass="btn-secondary text-xs py-2 px-3 cursor-pointer" />
                <asp:Button ID="btnSubmitEditFactory" runat="server" Text="Update Facility" OnClick="btnSubmitEditFactory_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>

