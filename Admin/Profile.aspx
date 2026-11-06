<%@ Page Title="Admin Profile & Security Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb & Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 admin-animate-enter">
        <div>
            <span class="text-[11px] font-mono uppercase font-bold text-[#64748B] tracking-wider">PLATFORM GOVERNANCE &amp; CREDENTIALS</span>
            <h1 class="text-xl font-bold font-['Archivo',sans-serif] text-[#0F172A] mt-0.5">Administrator Profile &amp; Security</h1>
            <p class="text-xs text-[#64748B] m-0">Inspect administrator credentials, update contact telemetry, and manage governance authentication.</p>
        </div>
        <div class="flex items-center gap-2">
            <a href="~/Admin/Dashboard.aspx" runat="server" class="btn-secondary text-xs py-2 px-3">
                <i class="fa-solid fa-arrow-left mr-1.5"></i> Back to Console
            </a>
        </div>
    </div>

    <!-- Alert / Toast Banner -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="p-4 mb-6 rounded-md border text-xs flex items-center justify-between shadow-xs admin-animate-enter">
        <div class="flex items-center gap-2.5">
            <i id="iconAlert" runat="server" class="fa-solid fa-circle-check text-emerald-600 text-sm"></i>
            <asp:Label ID="lblAlertMessage" runat="server" Font-Bold="true"></asp:Label>
        </div>
        <asp:LinkButton ID="btnCloseAlert" runat="server" OnClick="btnCloseAlert_Click" CssClass="text-slate-400 hover:text-slate-600 text-xs">
            <i class="fa-solid fa-xmark"></i>
        </asp:LinkButton>
    </asp:Panel>

    <!-- Top Identity Card -->
    <div class="surface-card p-6 mb-6 shadow-xs border border-[#CBD5E1] admin-animate-enter admin-stagger-1">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div class="flex items-center gap-5">
                <div class="w-16 h-16 rounded-xl bg-slate-900 border-2 border-[#1769E0] flex items-center justify-center text-white font-black text-xl font-mono shadow-md">
                    SA
                </div>
                <div>
                    <div class="flex items-center gap-2.5 flex-wrap">
                        <h2 class="text-lg font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0" id="dispAdminName" runat="server">Platform Administrator</h2>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-[10px] font-mono font-bold bg-blue-50 text-[#1769E0] border border-blue-200">
                            <i class="fa-solid fa-shield-halved text-[9px]"></i> SUPERADMINISTRATOR
                        </span>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-[10px] font-mono font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> ACTIVE &amp; VERIFIED
                        </span>
                    </div>
                    <div class="flex items-center gap-4 mt-2 text-xs text-[#64748B] flex-wrap font-mono">
                        <span><i class="fa-regular fa-envelope text-slate-400 mr-1.5"></i><span id="dispAdminEmail" runat="server">admin@sparepartportal.com</span></span>
                        <span>&bull;</span>
                        <span><i class="fa-solid fa-phone text-slate-400 mr-1.5"></i><span id="dispAdminPhone" runat="server">+91 9876543210</span></span>
                        <span>&bull;</span>
                        <span><i class="fa-regular fa-calendar text-slate-400 mr-1.5"></i>Joined: <span id="dispAdminJoined" runat="server">31 Aug 2026</span></span>
                    </div>
                </div>
            </div>

            <div class="bg-[#F8FAFC] border border-[#E2E8F0] rounded-lg p-3.5 flex items-center gap-6 font-mono text-xs">
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Authority ID</span>
                    <span class="font-bold text-[#0F172A] text-sm" id="dispUserId" runat="server">#1</span>
                </div>
                <div class="h-8 w-px bg-[#CBD5E1]"></div>
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Access Scope</span>
                    <span class="font-bold text-[#1769E0]">Full (19 Tables)</span>
                </div>
                <div class="h-8 w-px bg-[#CBD5E1]"></div>
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Session Mode</span>
                    <span class="font-bold text-emerald-700">Authenticated</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Two-Column Profile & Security Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        
        <!-- Column 1: Edit Contact Information -->
        <div class="surface-card p-6 shadow-xs border border-[#CBD5E1] admin-animate-enter admin-stagger-2">
            <div class="flex items-center gap-2.5 pb-4 mb-5 border-b border-[#E2E8F0]">
                <div class="w-8 h-8 rounded-lg bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm">
                    <i class="fa-solid fa-user-pen"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Administrator Details</h3>
                    <p class="text-[11px] text-[#64748B] m-0">Update your primary identity information and operational contact numbers.</p>
                </div>
            </div>

            <div class="space-y-4 text-left">
                <div>
                    <label class="form-label text-xs">Full Name / Governance Signatory <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input text-xs py-2" placeholder="e.g. Platform Administrator" MaxLength="100" />
                </div>

                <div>
                    <label class="form-label text-xs">Corporate Email Address <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input text-xs py-2 font-mono" placeholder="admin@sparepartportal.com" MaxLength="100" />
                    <span class="text-[10px] text-[#64748B] mt-1 block">Used for primary system authentication and security dispatch notifications.</span>
                </div>

                <div>
                    <label class="form-label text-xs">Direct Emergency Telephone / Mobile</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="+91 9876543210" MaxLength="20" />
                </div>

                <div class="pt-3 border-t border-[#E2E8F0] flex items-center justify-end">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile Changes" OnClick="btnSaveProfile_Click" CssClass="btn-primary text-xs py-2 px-4 cursor-pointer" />
                </div>
            </div>
        </div>

        <!-- Column 2: Password & Authentication Credentials -->
        <div class="surface-card p-6 shadow-xs border border-[#CBD5E1] admin-animate-enter admin-stagger-3">
            <div class="flex items-center gap-2.5 pb-4 mb-5 border-b border-[#E2E8F0]">
                <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-700 flex items-center justify-center text-sm">
                    <i class="fa-solid fa-lock"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Password &amp; Security</h3>
                    <p class="text-[11px] text-[#64748B] m-0">Rotate your console access credentials. Enforces SHA-256 with unique cryptographic salt.</p>
                </div>
            </div>

            <div class="space-y-4 text-left">
                <div>
                    <label class="form-label text-xs">Current Password <span class="text-rose-500">*</span></label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input text-xs py-2 font-mono" placeholder="Enter existing password" />
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <div>
                        <label class="form-label text-xs">New Password <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input text-xs py-2 font-mono" placeholder="Min. 6 characters" />
                    </div>
                    <div>
                        <label class="form-label text-xs">Confirm New Password <span class="text-rose-500">*</span></label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input text-xs py-2 font-mono" placeholder="Re-type new password" />
                    </div>
                </div>

                <div class="p-3 bg-amber-50/70 border border-amber-200 rounded text-[11px] text-amber-900 flex items-start gap-2">
                    <i class="fa-solid fa-triangle-exclamation text-amber-600 mt-0.5"></i>
                    <span>Updating your password will immediately apply to all new console login sessions. Keep your credentials secure.</span>
                </div>

                <div class="pt-3 border-t border-[#E2E8F0] flex items-center justify-end">
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Security Password" OnClick="btnChangePassword_Click" CssClass="btn-secondary text-xs py-2 px-4 cursor-pointer" />
                </div>
            </div>
        </div>

    </div>

    <!-- Governance Access Clearance Summary -->
    <div class="surface-card p-5 border border-[#CBD5E1] shadow-xs admin-animate-enter admin-stagger-4">
        <h4 class="text-xs font-bold font-mono uppercase text-[#0F172A] tracking-wider mb-3 flex items-center gap-2">
            <i class="fa-solid fa-key text-[#1769E0]"></i> Superadministrator Authority Privileges
        </h4>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs text-[#64748B]">
            <div class="p-3 bg-[#F8FAFC] rounded border border-[#E2E8F0]">
                <div class="font-bold text-[#0F172A] mb-1 flex items-center gap-1.5">
                    <i class="fa-solid fa-database text-blue-500"></i> Full Database Governance
                </div>
                <span>Direct transactional control over Users, Roles, Factories, Suppliers, Technicians, Categories, Machinery, Parts, Quotations, Orders, and AuditLogs.</span>
            </div>
            <div class="p-3 bg-[#F8FAFC] rounded border border-[#E2E8F0]">
                <div class="font-bold text-[#0F172A] mb-1 flex items-center gap-1.5">
                    <i class="fa-solid fa-user-shield text-emerald-500"></i> RBAC Policy Management
                </div>
                <span>Ability to register, edit, activate, or deactivate ecosystem accounts across all four multi-tenant roles without restriction.</span>
            </div>
            <div class="p-3 bg-[#F8FAFC] rounded border border-[#E2E8F0]">
                <div class="font-bold text-[#0F172A] mb-1 flex items-center gap-1.5">
                    <i class="fa-solid fa-clipboard-list text-purple-500"></i> Immutable Audit Logging
                </div>
                <span>Every administrative action (create, update, delete, status toggle) is recorded to the AuditLogs table with IP address and timestamps.</span>
            </div>
        </div>
    </div>
</asp:Content>