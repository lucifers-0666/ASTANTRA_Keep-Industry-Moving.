<%@ Page Title="Plant Profile &amp; Settings" Language="C#" MasterPageFile="~/MasterPages/Factory.Master" AutoEventWireup="true" CodeBehind="PlantProfile.aspx.cs" Inherits="IndustrialSparePartPortal.Factory.Profile.PlantProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Manage plant company information, tax GSTIN identifiers, factory dispatch address, and emergency contact numbers." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header -->
    <div class="bg-white rounded-lg border border-[#CBD5E1] p-6 mb-6 shadow-xs text-left">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold uppercase bg-blue-100 text-blue-800 border border-blue-200 mb-1.5 inline-block">
                    <i class="fa-solid fa-building-shield mr-1"></i> Facility Master Data
                </span>
                <h1 class="text-xl sm:text-2xl font-black font-['Archivo',sans-serif] text-slate-900 m-0">
                    Manufacturing Plant Profile &amp; Settings
                </h1>
                <p class="text-xs text-slate-500 m-0 mt-1 max-w-2xl">
                    Configure legal enterprise credentials, verified GSTIN identifiers, physical logistics delivery coordinates, and 24/7 emergency dispatch contacts.
                </p>
            </div>
            <div class="flex items-center gap-2">
                <span class="text-xs font-mono bg-slate-100 text-slate-700 px-3 py-1.5 rounded border border-slate-300 font-semibold" id="lblTenantBadge" runat="server">
                    Tenant ID: FID-000
                </span>
            </div>
        </div>
    </div>

    <!-- Alert Panel -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md bg-emerald-50 border border-emerald-300 text-xs text-slate-800 flex items-center justify-between">
        <div class="flex items-center gap-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Text="Profile updated successfully."></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Main Form: 2 Cols -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Corporate Entity Information -->
            <div class="factory-card p-6">
                <div class="flex items-center gap-2 pb-3 mb-4 border-b border-slate-200">
                    <i class="fa-solid fa-landmark text-blue-600 text-sm"></i>
                    <h2 class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 m-0">
                        Legal Entity &amp; Commercial Tax Details
                    </h2>
                </div>

                <div class="space-y-4 text-xs">
                    <div>
                        <label class="form-label" for="<%= txtCompanyName.ClientID %>">Company / Plant Name <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-input font-semibold"></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= txtIndustryType.ClientID %>">Industry Sector</label>
                            <asp:TextBox ID="txtIndustryType" runat="server" CssClass="form-input" placeholder="e.g. Heavy Forging, CNC Machining"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtGstin.ClientID %>">GSTIN Identification Number</label>
                            <asp:TextBox ID="txtGstin" runat="server" CssClass="form-input font-mono uppercase font-bold" placeholder="24AAACA0000A1Z5"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="form-label" for="<%= txtContactPerson.ClientID %>">Primary Procurement Officer <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtContactPerson" runat="server" CssClass="form-input"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtContactPhone.ClientID %>">24/7 Emergency Dispatch Telephone <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtContactPhone" runat="server" CssClass="form-input font-mono" placeholder="+91 98765 43210"></asp:TextBox>
                            <span class="text-[11px] text-slate-400 mt-0.5 block">Used for immediate SOS breakdown verification by field engineers.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Physical Consignment Delivery Address -->
            <div class="factory-card p-6">
                <div class="flex items-center gap-2 pb-3 mb-4 border-b border-slate-200">
                    <i class="fa-solid fa-map-location-dot text-blue-600 text-sm"></i>
                    <h2 class="text-xs font-bold font-mono uppercase tracking-wider text-slate-800 m-0">
                        Consignment Delivery Address &amp; Gate Access
                    </h2>
                </div>

                <div class="space-y-4 text-xs">
                    <div>
                        <label class="form-label" for="<%= txtAddress.ClientID %>">Plant Physical Address <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-textarea" placeholder="Plot No., GIDC Industrial Estate, Phase / Gate..."></asp:TextBox>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div>
                            <label class="form-label" for="<%= txtCity.ClientID %>">City <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-input"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtState.ClientID %>">State <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtState" runat="server" CssClass="form-input"></asp:TextBox>
                        </div>
                        <div>
                            <label class="form-label" for="<%= txtPincode.ClientID %>">Postal PIN Code <span class="text-rose-500">*</span></label>
                            <asp:TextBox ID="txtPincode" runat="server" CssClass="form-input font-mono" MaxLength="10" placeholder="360002"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="mt-6 pt-4 border-t border-slate-200 flex justify-end">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Update Plant Profile" OnClick="btnSaveProfile_Click" CssClass="btn-primary text-xs py-2 px-5 font-bold" />
                </div>
            </div>
        </div>

        <!-- Sidebar Info Column: 1 Col -->
        <div class="space-y-6">
            <!-- Account Identity Card -->
            <div class="factory-card p-5">
                <span class="text-[10px] font-mono uppercase font-bold text-slate-400 block mb-2">Master Account Telemetry</span>
                <div class="space-y-3 text-xs">
                    <div>
                        <span class="text-slate-400 text-[11px] block">Login Email</span>
                        <strong class="text-slate-800 font-mono" id="lblUserEmail" runat="server">-</strong>
                    </div>
                    <div>
                        <span class="text-slate-400 text-[11px] block">Security Verification</span>
                        <span class="px-2 py-0.5 rounded text-[10px] font-mono font-bold bg-emerald-100 text-emerald-800 border border-emerald-200 inline-block mt-0.5">
                            <i class="fa-solid fa-shield-check mr-1"></i> Verified Commercial Plant
                        </span>
                    </div>
                    <div>
                        <span class="text-slate-400 text-[11px] block">Account Registered On</span>
                        <span class="text-slate-700 font-mono text-[11px]" id="lblRegistrationDate" runat="server">-</span>
                    </div>
                </div>
            </div>

            <!-- Guidance Note -->
            <div class="p-4 rounded-lg bg-blue-50/60 border border-blue-200 text-xs text-slate-700 leading-relaxed">
                <div class="flex items-center gap-1.5 font-bold text-blue-900 mb-1">
                    <i class="fa-solid fa-circle-info text-blue-600"></i> B2B Compliance Note
                </div>
                <p class="m-0 text-[11px] text-slate-600">
                    Your Company Name and GSTIN are automatically stamped onto quotation RFQs, purchase orders, and tax invoices. Ensure PIN Code and physical address are exact for commercial courier waybill generation.
                </p>
            </div>
        </div>
    </div>
</asp:Content>