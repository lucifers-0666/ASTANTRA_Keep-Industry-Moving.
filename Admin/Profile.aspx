<%@ Page Title="Admin Profile & Security Governance" Language="C#" MasterPageFile="~/MasterPages/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="IndustrialSparePartPortal.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .crop-canvas-container {
            position: relative;
            user-select: none;
            -webkit-user-select: none;
        }
        .crop-viewport-guide {
            position: absolute;
            pointer-events: none;
            border: 2px solid #38BDF8;
            box-shadow: 0 0 0 9999px rgba(15, 23, 42, 0.72);
            border-radius: 8px;
        }
        .crop-circle-guide {
            position: absolute;
            pointer-events: none;
            border: 1px dashed rgba(255, 255, 255, 0.6);
            border-radius: 50%;
        }
        .crop-grid-line-h {
            position: absolute;
            pointer-events: none;
            width: 100%;
            height: 1px;
            background: rgba(255, 255, 255, 0.25);
        }
        .crop-grid-line-v {
            position: absolute;
            pointer-events: none;
            height: 100%;
            width: 1px;
            background: rgba(255, 255, 255, 0.25);
        }
    </style>
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

    <!-- Top Identity Card with Avatar & Quick Actions -->
    <div class="surface-card p-6 mb-6 shadow-xs border border-[#CBD5E1] admin-animate-enter admin-stagger-1">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
            <div class="flex flex-col sm:flex-row sm:items-center gap-5">
                <!-- Avatar Display Box with Camera Overlay -->
                <div class="relative group shrink-0">
                    <div class="w-20 h-20 rounded-2xl bg-slate-900 border-2 border-[#1769E0] flex items-center justify-center text-white font-black text-2xl font-mono shadow-md overflow-hidden relative">
                        <asp:Image ID="imgProfilePreview" runat="server" Visible="false" CssClass="w-full h-full object-cover" />
                        <span id="lblProfileInitials" runat="server" class="font-bold text-2xl text-white font-mono">SA</span>
                    </div>
                    <button type="button" onclick="openAvatarStudio()" class="absolute -bottom-1 -right-1 w-7 h-7 rounded-full bg-[#1769E0] text-white hover:bg-[#1357BE] flex items-center justify-center text-xs shadow-md border-2 border-white cursor-pointer transition-transform hover:scale-110" title="Upload &amp; Crop Avatar Photo">
                        <i class="fa-solid fa-camera"></i>
                    </button>
                </div>

                <div>
                    <div class="flex items-center gap-2.5 flex-wrap">
                        <h2 class="text-lg font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0" id="dispAdminName" runat="server">Platform Administrator</h2>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-[10px] font-mono font-bold bg-blue-50 text-[#1769E0] border border-blue-200">
                            <i class="fa-solid fa-shield-halved text-[9px]"></i> SUPERADMINISTRATOR (LEVEL 4)
                        </span>
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded text-[10px] font-mono font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span> ACTIVE &amp; VERIFIED
                        </span>
                    </div>

                    <div class="flex items-center gap-4 mt-2 text-xs text-[#64748B] flex-wrap font-mono">
                        <span><i class="fa-regular fa-envelope text-slate-400 mr-1.5"></i><span id="dispAdminEmail" runat="server">admin@sparepartportal.com</span></span>
                        <span>&bull;</span>
                        <span><i class="fa-solid fa-phone text-slate-400 mr-1.5"></i><span id="dispAdminPhone" runat="server">+91 9876543210</span></span>
                        <span>&bull;</span>
                        <span><i class="fa-regular fa-calendar text-slate-400 mr-1.5"></i>Joined: <span id="dispAdminJoined" runat="server">31 Aug 2026</span></span>
                    </div>

                    <!-- Avatar Management Actions -->
                    <div class="flex items-center gap-2 mt-3.5">
                        <button type="button" onclick="openAvatarStudio()" class="btn-primary text-xs py-1.5 px-3 cursor-pointer shadow-2xs">
                            <i class="fa-solid fa-camera mr-1.5"></i> Upload &amp; Crop Photo
                        </button>
                        <asp:Button ID="btnRemoveAvatar" runat="server" Text="Remove Photo" OnClick="btnRemoveAvatar_Click" CssClass="btn-secondary text-xs py-1.5 px-3 text-rose-600 hover:text-rose-700 hover:border-rose-300 cursor-pointer" Visible="false" />
                    </div>
                </div>
            </div>

            <!-- Authority Telemetry Card -->
            <div class="bg-[#F8FAFC] border border-[#E2E8F0] rounded-lg p-3.5 flex items-center gap-6 font-mono text-xs shrink-0">
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Authority ID</span>
                    <span class="font-bold text-[#0F172A] text-sm" id="dispUserId" runat="server">#1 (Root)</span>
                </div>
                <div class="h-8 w-px bg-[#CBD5E1]"></div>
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Access Scope</span>
                    <span class="font-bold text-[#1769E0]">Full (19 Tables)</span>
                </div>
                <div class="h-8 w-px bg-[#CBD5E1]"></div>
                <div>
                    <span class="text-[10px] uppercase text-[#64748B] font-bold block">Security Standard</span>
                    <span class="font-bold text-emerald-700">SHA-256 + Salt</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Two-Column Profile & Security Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        
        <!-- Column 1: Administrator Contact & Governance Details -->
        <div class="surface-card p-6 shadow-xs border border-[#CBD5E1] admin-animate-enter admin-stagger-2">
            <div class="flex items-center gap-2.5 pb-4 mb-5 border-b border-[#E2E8F0]">
                <div class="w-8 h-8 rounded-lg bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm">
                    <i class="fa-solid fa-user-pen"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Administrator Details</h3>
                    <p class="text-[11px] text-[#64748B] m-0">Update your primary identity information, corporate telephone, and directorate assignments.</p>
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
                    <span class="text-[10px] text-[#64748B] mt-1 block">Primary system authentication and emergency dispatch notifications.</span>
                </div>

                <div>
                    <label class="form-label text-xs">Direct Emergency Telephone / Mobile</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input text-xs py-2 font-mono" placeholder="+91 9876543210" MaxLength="20" />
                </div>

                <!-- Governance Operational Directorate (Read-only System Telemetry) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
                    <div class="p-3 bg-[#F8FAFC] rounded border border-[#E2E8F0]">
                        <span class="text-[10px] uppercase font-mono font-bold text-[#64748B] block">Operational Directorate</span>
                        <span class="text-xs font-semibold text-[#0F172A] mt-0.5 block">Industrial Operations &amp; Fleet HQ</span>
                    </div>
                    <div class="p-3 bg-[#F8FAFC] rounded border border-[#E2E8F0]">
                        <span class="text-[10px] uppercase font-mono font-bold text-[#64748B] block">Primary Regional Hub</span>
                        <span class="text-xs font-semibold text-[#0F172A] mt-0.5 block">Western Corridor (Ahmedabad GIDC)</span>
                    </div>
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
                    <p class="text-[11px] text-[#64748B] m-0">Rotate console access credentials. Enforces SHA-256 with unique cryptographic salt.</p>
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
                    <i class="fa-solid fa-triangle-exclamation text-amber-600 mt-0.5 shrink-0"></i>
                    <span>Rotating your password takes effect immediately. Prior authenticated sessions will require re-login with the new credential.</span>
                </div>

                <div class="pt-3 border-t border-[#E2E8F0] flex items-center justify-end">
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Security Password" OnClick="btnChangePassword_Click" CssClass="btn-secondary text-xs py-2 px-4 cursor-pointer" />
                </div>
            </div>
        </div>

    </div>

    <!-- Governance Access Clearance Summary -->
    <div class="surface-card p-5 border border-[#CBD5E1] shadow-xs admin-animate-enter admin-stagger-4 mb-6">
        <h4 class="text-xs font-bold font-mono uppercase text-[#0F172A] tracking-wider mb-3 flex items-center gap-2">
            <i class="fa-solid fa-key text-[#1769E0]"></i> Superadministrator Authority Privileges &amp; Auditing
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

    <!-- Hidden Server Controls for Cropped Avatar PostBack -->
    <asp:HiddenField ID="hdnCroppedAvatarData" runat="server" />
    <asp:Button ID="btnSaveAvatarDirect" runat="server" OnClick="btnSaveAvatarDirect_Click" style="display:none;" />

    <!-- MODAL: INTERACTIVE AVATAR UPLOAD & CROPPING STUDIO -->
    <div id="avatarStudioModal" class="admin-modal-overlay admin-modal-hidden fixed inset-0 z-50 flex items-center justify-center p-4">
        <div class="surface-card w-full max-w-2xl shadow-2xl rounded-xl border border-[#CBD5E1] overflow-hidden flex flex-col max-h-[90vh]">
            
            <!-- Modal Header -->
            <div class="px-6 py-4 bg-white border-b border-[#E2E8F0] flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-blue-50 text-[#1769E0] flex items-center justify-center text-sm border border-blue-200">
                        <i class="fa-solid fa-crop-simple"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold font-['Archivo',sans-serif] text-[#0F172A] m-0">Administrator Avatar Studio</h3>
                        <p class="text-[11px] text-[#64748B] m-0">Crop, scale, and align your official administrator portrait.</p>
                    </div>
                </div>
                <button type="button" onclick="closeAvatarStudio()" class="text-slate-400 hover:text-slate-600 text-sm cursor-pointer p-1">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <!-- Modal Body (Scrollable) -->
            <div class="p-6 overflow-y-auto flex-1 space-y-5 bg-[#F8FAFC]">

                <!-- Step 1: Upload / Drag & Drop Area (Shown initially if no image loaded) -->
                <div id="avatarDropzone" class="border-2 border-dashed border-slate-300 hover:border-[#1769E0] rounded-xl p-8 text-center bg-white cursor-pointer transition-colors" onclick="document.getElementById('avatarFileInput').click()">
                    <input type="file" id="avatarFileInput" accept="image/png, image/jpeg, image/jpg, image/webp" class="hidden" onchange="handleFileSelect(event)" />
                    <div class="w-12 h-12 rounded-full bg-blue-50 text-[#1769E0] flex items-center justify-center mx-auto mb-3 text-lg">
                        <i class="fa-solid fa-cloud-arrow-up"></i>
                    </div>
                    <div class="text-xs font-bold text-[#0F172A]">Click to select or drag &amp; drop profile photo</div>
                    <p class="text-[11px] text-[#64748B] mt-1 mb-3">Accepts JPG, PNG, or WEBP (Max 5 MB recommended)</p>
                    <span class="btn-secondary text-[11px] py-1.5 px-3 inline-flex items-center gap-1.5">
                        <i class="fa-solid fa-folder-open text-[10px]"></i> Browse Files
                    </span>
                </div>

                <!-- Step 2: Interactive Cropping Workspace (Shown once an image is chosen) -->
                <div id="avatarCropWorkspace" style="display:none;" class="space-y-4">
                    
                    <div class="flex flex-col md:flex-row gap-6 items-start justify-center">
                        <!-- Canvas Container -->
                        <div class="flex flex-col items-center">
                            <div class="text-[11px] font-mono font-bold text-[#64748B] mb-2 uppercase tracking-wider flex items-center gap-1.5">
                                <i class="fa-solid fa-arrows-up-down-left-right text-[#1769E0]"></i> Drag image to frame • Scroll or use slider to zoom
                            </div>
                            
                            <div class="crop-canvas-container rounded-xl overflow-hidden border-2 border-slate-700 bg-slate-950 shadow-lg" style="width: 320px; height: 320px;">
                                <canvas id="cropCanvas" width="320" height="320" class="cursor-grab active:cursor-grabbing block"></canvas>
                            </div>

                            <!-- Canvas Interactive Controls Toolbar -->
                            <div class="flex items-center gap-2 mt-3 w-full justify-center">
                                <button type="button" onclick="adjustZoom(-0.1)" class="w-8 h-8 rounded bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs shadow-2xs" title="Zoom Out">
                                    <i class="fa-solid fa-minus"></i>
                                </button>
                                <input type="range" id="cropZoomSlider" min="0.3" max="3.0" step="0.02" value="1.0" class="w-36 accent-[#1769E0] cursor-pointer" oninput="handleZoomSlider(this.value)" />
                                <button type="button" onclick="adjustZoom(0.1)" class="w-8 h-8 rounded bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs shadow-2xs" title="Zoom In">
                                    <i class="fa-solid fa-plus"></i>
                                </button>
                                <div class="h-5 w-px bg-slate-300 mx-1"></div>
                                <button type="button" onclick="rotateImage(-90)" class="w-8 h-8 rounded bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs shadow-2xs" title="Rotate Counter-Clockwise 90°">
                                    <i class="fa-solid fa-rotate-left"></i>
                                </button>
                                <button type="button" onclick="rotateImage(90)" class="w-8 h-8 rounded bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs shadow-2xs" title="Rotate Clockwise 90°">
                                    <i class="fa-solid fa-rotate-right"></i>
                                </button>
                                <button type="button" onclick="resetCropView()" class="w-8 h-8 rounded bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 flex items-center justify-center text-xs shadow-2xs" title="Reset Frame">
                                    <i class="fa-solid fa-arrows-to-dot"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Live Multi-Scale Preview Deck -->
                        <div class="flex flex-col gap-3 min-w-[190px]">
                            <span class="text-[11px] font-mono font-bold text-[#64748B] uppercase tracking-wider block">Real-Time Previews</span>

                            <!-- Preview 1: Profile Header Size (72x72) -->
                            <div class="p-3 bg-white rounded-lg border border-[#E2E8F0] flex items-center gap-3 shadow-2xs">
                                <div class="w-16 h-16 rounded-xl overflow-hidden border-2 border-[#1769E0] bg-slate-900 shrink-0">
                                    <img id="previewLarge" class="w-full h-full object-cover" alt="Large Preview" />
                                </div>
                                <div class="text-[11px]">
                                    <span class="font-bold text-[#0F172A] block">Profile Card</span>
                                    <span class="text-[#64748B] font-mono text-[10px]">1:1 Square</span>
                                </div>
                            </div>

                            <!-- Preview 2: Header Avatar Size (40x40) -->
                            <div class="p-3 bg-white rounded-lg border border-[#E2E8F0] flex items-center gap-3 shadow-2xs">
                                <div class="w-10 h-10 rounded-full overflow-hidden border border-slate-300 bg-slate-900 shrink-0">
                                    <img id="previewMedium" class="w-full h-full object-cover" alt="Medium Preview" />
                                </div>
                                <div class="text-[11px]">
                                    <span class="font-bold text-[#0F172A] block">Top Console</span>
                                    <span class="text-[#64748B] font-mono text-[10px]">Circle 40px</span>
                                </div>
                            </div>

                            <!-- Preview 3: Sidebar Footbar Size (32x32) -->
                            <div class="p-3 bg-white rounded-lg border border-[#E2E8F0] flex items-center gap-3 shadow-2xs">
                                <div class="w-8 h-8 rounded-full overflow-hidden border border-slate-300 bg-slate-900 shrink-0">
                                    <img id="previewSmall" class="w-full h-full object-cover" alt="Small Preview" />
                                </div>
                                <div class="text-[11px]">
                                    <span class="font-bold text-[#0F172A] block">Sidebar Footbar</span>
                                    <span class="text-[#64748B] font-mono text-[10px]">Circle 32px</span>
                                </div>
                            </div>

                            <!-- Telemetry Meta -->
                            <div class="p-2.5 bg-blue-50/60 rounded border border-blue-100 text-[10px] font-mono text-blue-900 space-y-1">
                                <div><span class="font-bold">Output Res:</span> 256 &times; 256 px</div>
                                <div><span class="font-bold">Compression:</span> High-Q JPEG</div>
                                <div><span class="font-bold">Storage:</span> ~/Uploads/Avatars/</div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <!-- Modal Footer -->
            <div class="px-6 py-4 bg-white border-t border-[#E2E8F0] flex items-center justify-between">
                <div>
                    <button type="button" id="btnChangeImage" onclick="document.getElementById('avatarFileInput').click()" class="btn-secondary text-xs py-2 px-3 hidden">
                        <i class="fa-solid fa-image mr-1"></i> Choose Another Image
                    </button>
                </div>
                <div class="flex items-center gap-2">
                    <button type="button" onclick="closeAvatarStudio()" class="btn-secondary text-xs py-2 px-3">
                        Cancel
                    </button>
                    <button type="button" id="btnApplyCrop" onclick="applyAndSaveCroppedAvatar()" class="btn-primary text-xs py-2 px-4 shadow-xs hidden">
                        <i class="fa-solid fa-check mr-1.5"></i> Save &amp; Apply Avatar
                    </button>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script>
        // High-Precision Client-Side Canvas Cropper Studio
        var avatarState = {
            image: null,
            imgWidth: 0,
            imgHeight: 0,
            canvas: null,
            ctx: null,
            canvasSize: 320,
            cropSize: 240, // 240x240 square crop box centered inside 320x320 canvas
            scale: 1.0,
            baseScale: 1.0,
            panX: 0,
            panY: 0,
            rotation: 0,
            isDragging: false,
            dragStartX: 0,
            dragStartY: 0,
            dragStartPanX: 0,
            dragStartPanY: 0
        };

        function openAvatarStudio() {
            var modal = document.getElementById('avatarStudioModal');
            if (modal) {
                modal.classList.remove('admin-modal-hidden');
            }
            initCanvas();
        }

        function closeAvatarStudio() {
            var modal = document.getElementById('avatarStudioModal');
            if (modal) {
                modal.classList.add('admin-modal-hidden');
            }
        }

        function initCanvas() {
            if (!avatarState.canvas) {
                avatarState.canvas = document.getElementById('cropCanvas');
                avatarState.ctx = avatarState.canvas.getContext('2d');

                // Mouse Drag Listeners
                avatarState.canvas.addEventListener('mousedown', onMouseDown);
                window.addEventListener('mousemove', onMouseMove);
                window.addEventListener('mouseup', onMouseUp);

                // Touch Drag Listeners
                avatarState.canvas.addEventListener('touchstart', onTouchStart, { passive: false });
                window.addEventListener('touchmove', onTouchMove, { passive: false });
                window.addEventListener('touchend', onTouchEnd);

                // Mouse Wheel Zoom
                avatarState.canvas.addEventListener('wheel', onWheel, { passive: false });
            }
        }

        // Drag & Drop Setup
        var dropzone = document.getElementById('avatarDropzone');
        if (dropzone) {
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function (eventName) {
                dropzone.addEventListener(eventName, function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                }, false);
            });

            ['dragenter', 'dragover'].forEach(function (eventName) {
                dropzone.addEventListener(eventName, function () {
                    dropzone.classList.add('border-[#1769E0]', 'bg-blue-50/20');
                }, false);
            });

            ['dragleave', 'drop'].forEach(function (eventName) {
                dropzone.addEventListener(eventName, function () {
                    dropzone.classList.remove('border-[#1769E0]', 'bg-blue-50/20');
                }, false);
            });

            dropzone.addEventListener('drop', function (e) {
                var dt = e.dataTransfer;
                var files = dt.files;
                if (files && files.length > 0) {
                    loadImageFile(files[0]);
                }
            }, false);
        }

        function handleFileSelect(event) {
            var files = event.target.files;
            if (files && files.length > 0) {
                loadImageFile(files[0]);
            }
        }

        function loadImageFile(file) {
            if (!file.type.match(/^image\//)) {
                alert('Please select an image file (PNG, JPG, or WEBP).');
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                var img = new Image();
                img.onload = function () {
                    avatarState.image = img;
                    avatarState.imgWidth = img.width;
                    avatarState.imgHeight = img.height;
                    avatarState.rotation = 0;
                    avatarState.panX = 0;
                    avatarState.panY = 0;

                    // Fit image to cropSize
                    var fitScale = Math.max(avatarState.cropSize / img.width, avatarState.cropSize / img.height);
                    avatarState.baseScale = fitScale;
                    avatarState.scale = fitScale;

                    var slider = document.getElementById('cropZoomSlider');
                    if (slider) {
                        slider.min = (fitScale * 0.5).toFixed(2);
                        slider.max = (fitScale * 3.5).toFixed(2);
                        slider.value = fitScale.toFixed(2);
                    }

                    // Toggle views
                    document.getElementById('avatarDropzone').classList.add('hidden');
                    document.getElementById('avatarCropWorkspace').style.display = 'block';
                    document.getElementById('btnChangeImage').classList.remove('hidden');
                    document.getElementById('btnApplyCrop').classList.remove('hidden');

                    renderCanvas();
                };
                img.src = e.target.result;
            };
            reader.readAsDataURL(file);
        }

        function onMouseDown(e) {
            if (!avatarState.image) return;
            avatarState.isDragging = true;
            avatarState.dragStartX = e.clientX;
            avatarState.dragStartY = e.clientY;
            avatarState.dragStartPanX = avatarState.panX;
            avatarState.dragStartPanY = avatarState.panY;
        }

        function onMouseMove(e) {
            if (!avatarState.isDragging) return;
            var dx = e.clientX - avatarState.dragStartX;
            var dy = e.clientY - avatarState.dragStartY;
            avatarState.panX = avatarState.dragStartPanX + dx;
            avatarState.panY = avatarState.dragStartPanY + dy;
            renderCanvas();
        }

        function onMouseUp() {
            avatarState.isDragging = false;
        }

        function onTouchStart(e) {
            if (!avatarState.image || e.touches.length === 0) return;
            e.preventDefault();
            avatarState.isDragging = true;
            avatarState.dragStartX = e.touches[0].clientX;
            avatarState.dragStartY = e.touches[0].clientY;
            avatarState.dragStartPanX = avatarState.panX;
            avatarState.dragStartPanY = avatarState.panY;
        }

        function onTouchMove(e) {
            if (!avatarState.isDragging || e.touches.length === 0) return;
            e.preventDefault();
            var dx = e.touches[0].clientX - avatarState.dragStartX;
            var dy = e.touches[0].clientY - avatarState.dragStartY;
            avatarState.panX = avatarState.dragStartPanX + dx;
            avatarState.panY = avatarState.dragStartPanY + dy;
            renderCanvas();
        }

        function onTouchEnd() {
            avatarState.isDragging = false;
        }

        function onWheel(e) {
            if (!avatarState.image) return;
            e.preventDefault();
            var zoomDelta = e.deltaY < 0 ? 0.08 : -0.08;
            adjustZoom(zoomDelta);
        }

        function adjustZoom(delta) {
            if (!avatarState.image) return;
            var newScale = avatarState.scale + delta;
            var slider = document.getElementById('cropZoomSlider');
            if (slider) {
                var min = parseFloat(slider.min);
                var max = parseFloat(slider.max);
                if (newScale < min) newScale = min;
                if (newScale > max) newScale = max;
                slider.value = newScale.toFixed(2);
            }
            avatarState.scale = newScale;
            renderCanvas();
        }

        function handleZoomSlider(val) {
            avatarState.scale = parseFloat(val);
            renderCanvas();
        }

        function rotateImage(deg) {
            if (!avatarState.image) return;
            avatarState.rotation = (avatarState.rotation + deg) % 360;
            renderCanvas();
        }

        function resetCropView() {
            if (!avatarState.image) return;
            avatarState.panX = 0;
            avatarState.panY = 0;
            avatarState.rotation = 0;
            avatarState.scale = avatarState.baseScale;
            var slider = document.getElementById('cropZoomSlider');
            if (slider) slider.value = avatarState.baseScale.toFixed(2);
            renderCanvas();
        }

        function renderCanvas() {
            if (!avatarState.image || !avatarState.ctx) return;

            var ctx = avatarState.ctx;
            var w = avatarState.canvasSize;
            var h = avatarState.canvasSize;
            var cx = w / 2;
            var cy = h / 2;

            // Clear background
            ctx.clearRect(0, 0, w, h);
            ctx.fillStyle = '#0F172A';
            ctx.fillRect(0, 0, w, h);

            // Draw image with pan, zoom, rotation
            ctx.save();
            ctx.translate(cx + avatarState.panX, cy + avatarState.panY);
            ctx.rotate((avatarState.rotation * Math.PI) / 180);
            ctx.scale(avatarState.scale, avatarState.scale);
            ctx.drawImage(avatarState.image, -avatarState.imgWidth / 2, -avatarState.imgHeight / 2);
            ctx.restore();

            // Draw Crop Guides & Semi-transparent Mask
            var cropX = (w - avatarState.cropSize) / 2;
            var cropY = (h - avatarState.cropSize) / 2;
            var cropS = avatarState.cropSize;

            ctx.save();
            // Outer dark overlay (semi-transparent)
            ctx.fillStyle = 'rgba(15, 23, 42, 0.68)';
            ctx.beginPath();
            ctx.rect(0, 0, w, h);
            ctx.rect(cropX + cropS, cropY, -cropS, cropS); // cut hole
            ctx.fill();

            // Crop boundary border
            ctx.strokeStyle = '#38BDF8';
            ctx.lineWidth = 2;
            ctx.strokeRect(cropX, cropY, cropS, cropS);

            // Rule of thirds grid
            ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.moveTo(cropX + cropS / 3, cropY);
            ctx.lineTo(cropX + cropS / 3, cropY + cropS);
            ctx.moveTo(cropX + (cropS * 2) / 3, cropY);
            ctx.lineTo(cropX + (cropS * 2) / 3, cropY + cropS);
            ctx.moveTo(cropX, cropY + cropS / 3);
            ctx.lineTo(cropX + cropS, cropY + cropS / 3);
            ctx.moveTo(cropX, cropY + (cropS * 2) / 3);
            ctx.lineTo(cropX + cropS, cropY + (cropS * 2) / 3);
            ctx.stroke();

            // Circular avatar framing guide
            ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
            ctx.setLineDash([4, 4]);
            ctx.beginPath();
            ctx.arc(cx, cy, cropS / 2, 0, Math.PI * 2);
            ctx.stroke();
            ctx.setLineDash([]);
            ctx.restore();

            // Update live previews
            updatePreviews();
        }

        function updatePreviews() {
            var offscreen = document.createElement('canvas');
            offscreen.width = 256;
            offscreen.height = 256;
            var octx = offscreen.getContext('2d');

            var cropX = (avatarState.canvasSize - avatarState.cropSize) / 2;
            var cropY = (avatarState.canvasSize - avatarState.cropSize) / 2;
            var cropS = avatarState.cropSize;

            // Draw just the cropped square region from canvas to 256x256
            octx.drawImage(
                avatarState.canvas,
                cropX, cropY, cropS, cropS,
                0, 0, 256, 256
            );

            var dataUrl = offscreen.toDataURL('image/jpeg', 0.92);

            var prevL = document.getElementById('previewLarge');
            if (prevL) prevL.src = dataUrl;
            var prevM = document.getElementById('previewMedium');
            if (prevM) prevM.src = dataUrl;
            var prevS = document.getElementById('previewSmall');
            if (prevS) prevS.src = dataUrl;
        }

        function applyAndSaveCroppedAvatar() {
            if (!avatarState.image) return;

            // Render high-quality 256x256 output canvas directly from transformed source image
            var outputCanvas = document.createElement('canvas');
            outputCanvas.width = 256;
            outputCanvas.height = 256;
            var octx = outputCanvas.getContext('2d');

            // Fill solid dark background in case of transparent PNG
            octx.fillStyle = '#0F172A';
            octx.fillRect(0, 0, 256, 256);

            // Compute mapping from 320 canvas to 256 output
            var cropX = (avatarState.canvasSize - avatarState.cropSize) / 2;
            var cropY = (avatarState.canvasSize - avatarState.cropSize) / 2;
            var cropS = avatarState.cropSize;

            // Draw full transformed source into temporary full-res canvas, then clip
            var tempCanvas = document.createElement('canvas');
            tempCanvas.width = avatarState.canvasSize;
            tempCanvas.height = avatarState.canvasSize;
            var tctx = tempCanvas.getContext('2d');

            var cx = avatarState.canvasSize / 2;
            var cy = avatarState.canvasSize / 2;

            tctx.save();
            tctx.translate(cx + avatarState.panX, cy + avatarState.panY);
            tctx.rotate((avatarState.rotation * Math.PI) / 180);
            tctx.scale(avatarState.scale, avatarState.scale);
            tctx.drawImage(avatarState.image, -avatarState.imgWidth / 2, -avatarState.imgHeight / 2);
            tctx.restore();

            // Transfer cropped region into 256x256 output
            octx.drawImage(
                tempCanvas,
                cropX, cropY, cropS, cropS,
                0, 0, 256, 256
            );

            var croppedDataUrl = outputCanvas.toDataURL('image/jpeg', 0.92);

            // Set hidden field value
            var hdnField = document.getElementById('<%= hdnCroppedAvatarData.ClientID %>');
            if (hdnField) {
                hdnField.value = croppedDataUrl;
            }

            // Visual feedback on button
            var btnApply = document.getElementById('btnApplyCrop');
            if (btnApply) {
                btnApply.disabled = true;
                btnApply.innerHTML = '<i class="fa-solid fa-spinner fa-spin mr-1.5"></i> Saving Photo...';
            }

            // Trigger server-side save postback
            var btnServer = document.getElementById('<%= btnSaveAvatarDirect.ClientID %>');
            if (btnServer) {
                btnServer.click();
            }
        }
    </script>
</asp:Content>