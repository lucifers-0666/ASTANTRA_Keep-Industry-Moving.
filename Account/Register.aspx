<%@ Page Title="Register Portal Account" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="IndustrialSparePartPortal.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Register as a Factory Buyer, Spare-Part Supplier, or Certified Technician on SPAREFINDER." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="py-12 sm:py-16 bg-[#F1F3F5] flex items-center justify-center min-h-[calc(100vh-var(--site-header-height)-120px)] px-4 sm:px-6 lg:px-8">
        <div class="max-w-3xl w-full">
            <div class="surface-card p-6 sm:p-10 bg-white shadow-[0_4px_20px_-4px_rgba(20,35,55,0.06)] border border-[#D7DDE4] rounded-[4px] space-y-8">
                
                <!-- Registration Header -->
                <div class="text-left space-y-2 border-b border-[#D7DDE4] pb-6">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="spec-tag spec-tag-blue">ENTITY ONBOARDING</span>
                        <span class="spec-tag spec-tag-amber">ROLE VERIFICATION</span>
                    </div>
                    <h1 class="text-2xl sm:text-3xl font-black font-['Archivo',sans-serif] text-[#202833] tracking-tight m-0">Portal Account Registration</h1>
                    <p class="text-xs sm:text-sm text-[#667180] m-0">
                        Join the industrial spare-parts procurement network. Select your business role and configure your authorized credentials.
                    </p>
                </div>

                <!-- Alert Message -->
                <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 rounded-xl text-xs flex items-start gap-2.5">
                    <i class="fa-solid fa-circle-exclamation text-sm shrink-0 mt-0.5"></i>
                    <div>
                        <strong class="block font-bold">Registration Notice</strong>
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </div>
                </asp:Panel>

                <!-- SECTION 1: ROLE SELECTION -->
                <div class="space-y-3 text-left">
                    <div>
                        <span class="text-xs font-bold text-[#0F172A] uppercase tracking-wider block">01 · Choose Account Role <span class="text-red-500">*</span></span>
                        <p class="text-xs text-[#64748B] m-0 mt-0.5">Select the workspace profile that best matches your organization's primary operations.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-3.5 pt-1">
                        
                        <!-- Factory Buyer Option Card -->
                        <label class="relative flex flex-col justify-between p-4 rounded-xl border-2 cursor-pointer transition-all hover:bg-slate-50 <%= rdoFactory.Checked ? "border-[#1D4ED8] bg-blue-50/40 shadow-xs" : "border-[#CBD5E1] bg-white" %>">
                            <div class="space-y-2">
                                <div class="flex items-center justify-between">
                                    <div class="w-8 h-8 rounded-lg bg-blue-100 text-[#1D4ED8] flex items-center justify-center font-bold text-sm">
                                        <i class="fa-solid fa-industry"></i>
                                    </div>
                                    <asp:RadioButton ID="rdoFactory" runat="server" GroupName="RoleGroup" AutoPostBack="true" OnCheckedChanged="Role_CheckedChanged" Checked="true" />
                                </div>
                                <div class="font-bold text-[#0F172A] text-sm">Factory Buyer</div>
                                <p class="text-[11px] text-[#475569] leading-snug m-0">
                                    Industrial plant engineers seeking OEM parts, RFQ quotes &amp; breakdown dispatch.
                                </p>
                            </div>
                        </label>

                        <!-- Parts Supplier Option Card -->
                        <label class="relative flex flex-col justify-between p-4 rounded-xl border-2 cursor-pointer transition-all hover:bg-slate-50 <%= rdoSupplier.Checked ? "border-[#1D4ED8] bg-blue-50/40 shadow-xs" : "border-[#CBD5E1] bg-white" %>">
                            <div class="space-y-2">
                                <div class="flex items-center justify-between">
                                    <div class="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-sm">
                                        <i class="fa-solid fa-warehouse"></i>
                                    </div>
                                    <asp:RadioButton ID="rdoSupplier" runat="server" GroupName="RoleGroup" AutoPostBack="true" OnCheckedChanged="Role_CheckedChanged" />
                                </div>
                                <div class="font-bold text-[#0F172A] text-sm">Parts Supplier</div>
                                <p class="text-[11px] text-[#475569] leading-snug m-0">
                                    Authorized distributors managing warehouse stock &amp; RFQ bidding responses.
                                </p>
                            </div>
                        </label>

                        <!-- Field Technician Option Card -->
                        <label class="relative flex flex-col justify-between p-4 rounded-xl border-2 cursor-pointer transition-all hover:bg-slate-50 <%= rdoTechnician.Checked ? "border-[#1D4ED8] bg-blue-50/40 shadow-xs" : "border-[#CBD5E1] bg-white" %>">
                            <div class="space-y-2">
                                <div class="flex items-center justify-between">
                                    <div class="w-8 h-8 rounded-lg bg-orange-100 text-[#EA580C] flex items-center justify-center font-bold text-sm">
                                        <i class="fa-solid fa-wrench"></i>
                                    </div>
                                    <asp:RadioButton ID="rdoTechnician" runat="server" GroupName="RoleGroup" AutoPostBack="true" OnCheckedChanged="Role_CheckedChanged" />
                                </div>
                                <div class="font-bold text-[#0F172A] text-sm">Field Technician</div>
                                <p class="text-[11px] text-[#475569] leading-snug m-0">
                                    Certified technical specialists offering on-site machine repair &amp; commissioning.
                                </p>
                            </div>
                        </label>

                    </div>
                </div>

                <!-- SECTION 2: COMMON CONTACT & CREDENTIALS -->
                <div class="space-y-4 border-t border-[#E2E8F0] pt-6 text-left">
                    <div>
                        <span class="text-xs font-bold text-[#0F172A] uppercase tracking-wider block">02 · Account Representative &amp; Access</span>
                        <p class="text-xs text-[#64748B] m-0 mt-0.5">Primary individual authorized to operate this portal account.</p>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtFullName.ClientID %>">
                                Contact Representative Name <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtFullName" runat="server" autocomplete="name" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] focus:ring-2 focus:ring-[#1D4ED8]/20 transition-all font-medium" 
                                Placeholder="e.g. Ramesh Patel" Required="true"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtEmail.ClientID %>">
                                Authorized Corporate Email <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" autocomplete="email" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] focus:ring-2 focus:ring-[#1D4ED8]/20 transition-all font-medium" 
                                Placeholder="contact@company.com" Required="true"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtPassword.ClientID %>">
                                Account Password <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" autocomplete="new-password" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] focus:ring-2 focus:ring-[#1D4ED8]/20 transition-all font-medium" 
                                Placeholder="Min 6 characters" Required="true"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtPhone.ClientID %>">
                                Contact Phone Number <span class="text-slate-400 font-normal">(Optional)</span>
                            </label>
                            <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" autocomplete="tel" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] focus:ring-2 focus:ring-[#1D4ED8]/20 transition-all font-mono" 
                                Placeholder="+91 98765 43210"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- SECTION 3: ROLE-SPECIFIC DYNAMIC PROFILE FIELDS -->
                
                <!-- Role: Factory Buyer Profile -->
                <asp:Panel ID="pnlFactoryFields" runat="server" CssClass="space-y-4 border-t border-[#E2E8F0] pt-6 text-left">
                    <div>
                        <span class="text-xs font-bold text-[#0F172A] uppercase tracking-wider block">
                            <i class="fa-solid fa-industry text-[#1D4ED8] mr-1"></i> 03 · Manufacturing Plant Details
                        </span>
                        <p class="text-xs text-[#64748B] m-0 mt-0.5">Information identifying your factory facility and receiving location.</p>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtFactoryCompany.ClientID %>">
                                Company / Plant Legal Name <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtFactoryCompany" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Precision Engineering Works Ltd"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtIndustryType.ClientID %>">
                                Primary Industry Sector
                            </label>
                            <asp:TextBox ID="txtIndustryType" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Automotive, CNC Machining, Heavy Fabrication"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtFactoryCity.ClientID %>">
                                Plant City Location <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtFactoryCity" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Pune"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtFactoryState.ClientID %>">
                                State <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtFactoryState" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Maharashtra"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtFactoryGstin.ClientID %>">
                            Corporate GSTIN <span class="text-slate-400 font-normal">(Optional for GST Invoicing)</span>
                        </label>
                        <asp:TextBox ID="txtFactoryGstin" runat="server" 
                            CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-mono" 
                            Placeholder="27AAAAA0000A1Z5"></asp:TextBox>
                    </div>
                </asp:Panel>

                <!-- Role: Supplier Profile -->
                <asp:Panel ID="pnlSupplierFields" runat="server" Visible="false" CssClass="space-y-4 border-t border-[#E2E8F0] pt-6 text-left">
                    <div>
                        <span class="text-xs font-bold text-[#0F172A] uppercase tracking-wider block">
                            <i class="fa-solid fa-warehouse text-emerald-600 mr-1"></i> 03 · Supplier Warehouse &amp; Commercial Details
                        </span>
                        <p class="text-xs text-[#64748B] m-0 mt-0.5">Commercial identification for verified quotation issuance.</p>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtSupplierCompany.ClientID %>">
                                Supplier Entity Name <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtSupplierCompany" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. National Spares & Bearing Co"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtRegNo.ClientID %>">
                                Business Trade License / Reg #
                            </label>
                            <asp:TextBox ID="txtRegNo" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-mono" 
                                Placeholder="REG-882910"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtSupplierCity.ClientID %>">
                                Primary Warehouse City <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtSupplierCity" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Mumbai"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtSupplierState.ClientID %>">
                                State <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtSupplierState" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Maharashtra"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtSupplierGstin.ClientID %>">
                            Commercial GSTIN <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtSupplierGstin" runat="server" 
                            CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-mono" 
                            Placeholder="27BBBBB0000B1Z2"></asp:TextBox>
                    </div>
                </asp:Panel>

                <!-- Role: Technician Profile -->
                <asp:Panel ID="pnlTechnicianFields" runat="server" Visible="false" CssClass="space-y-4 border-t border-[#E2E8F0] pt-6 text-left">
                    <div>
                        <span class="text-xs font-bold text-[#0F172A] uppercase tracking-wider block">
                            <i class="fa-solid fa-wrench text-[#EA580C] mr-1"></i> 03 · Professional Engineering Qualifications
                        </span>
                        <p class="text-xs text-[#64748B] m-0 mt-0.5">Field service specialization for industrial emergency dispatch.</p>
                    </div>
                    
                    <div>
                        <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtSkills.ClientID %>">
                            Technical Skills &amp; Machinery Specializations <span class="text-red-500">*</span>
                        </label>
                        <asp:TextBox ID="txtSkills" runat="server" 
                            CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                            Placeholder="e.g. Hydraulic pump overhaul, CNC servo drive tuning, Siemens PLC troubleshooting"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtExperience.ClientID %>">
                                Experience (Years) <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtExperience" runat="server" TextMode="Number" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-mono" 
                                Placeholder="5"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtHourlyRate.ClientID %>">
                                Standard Hourly Rate (₹)
                            </label>
                            <asp:TextBox ID="txtHourlyRate" runat="server" TextMode="Number" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-mono" 
                                Placeholder="1200"></asp:TextBox>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-[#0F172A] mb-1.5 uppercase tracking-wider" for="<%= txtTechCity.ClientID %>">
                                Base Operational City <span class="text-red-500">*</span>
                            </label>
                            <asp:TextBox ID="txtTechCity" runat="server" 
                                CssClass="w-full px-3.5 py-2.5 bg-[#F8FAFC] border border-[#CBD5E1] rounded-xl text-sm text-[#0F172A] placeholder-slate-400 focus:bg-white focus:outline-none focus:border-[#1D4ED8] transition-all font-medium" 
                                Placeholder="e.g. Ahmedabad"></asp:TextBox>
                        </div>
                    </div>
                </asp:Panel>

                <!-- SECTION 4: SUBMISSION & CONFIRMATION -->
                <div class="pt-4 border-t border-[#E2E8F0] space-y-4">
                    <div class="text-[11px] text-[#64748B] text-left leading-relaxed">
                        By submitting this registration, you agree to portal operating guidelines and acknowledge that account approvals are governed by simulated academic verification rules.
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Complete Entity Registration →" OnClick="btnRegister_Click" 
                        CssClass="btn-primary w-full justify-center py-3.5 text-xs sm:text-sm font-bold shadow-xs cursor-pointer" />

                    <div class="text-center text-xs text-[#64748B]">
                        Already hold an accredited account? 
                        <a href="~/Account/Login.aspx" runat="server" class="font-bold text-[#1D4ED8] hover:underline ml-1">Sign In to Workspace</a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

