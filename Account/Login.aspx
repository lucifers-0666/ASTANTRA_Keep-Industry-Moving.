<%@ Page Title="Sign In to Portal" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="IndustrialSparePartPortal.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Sign in to your ASTANTRA industrial procurement terminal." />
    <link href="<%= ResolveUrl("~/css/pages/sign-in.css") %>?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="p-signin-section">
        <!-- Two-Panel Split Terminal Card -->
        <div class="p-signin-card">
            
            <!-- ====================================================================
                 LEFT PANEL: AUTHENTICATION FORM & ROLE SWITCHER
                 ==================================================================== -->
            <div class="p-signin-form-col">
                <div class="p-signin-form-wrap u-animate-cascade">
                    
                    <!-- Console Header & Node Indicator -->
                    <div class="p-signin-meta-header">
                        <div class="p-signin-node">
                            <span class="p-signin-node-dot"></span>
                            <span class="p-signin-node-text">ASTANTRA // MCA CAPSTONE</span>
                        </div>
                        <div class="p-signin-status-pill">
                            <span class="u-pulse-beacon"></span>
                            <span>PROTOTYPE ONLINE</span>
                        </div>
                    </div>

                    <!-- Heading Block -->
                    <div class="p-signin-heading-group">
                        <span class="p-signin-kicker">PORTAL ACCESS // MULTI-ROLE</span>
                        <h1 class="p-signin-title">Sign In to Portal</h1>
                        <p class="p-signin-desc">Select your registered operational role to access RFQ dispatch, inventory quotation, or emergency breakdown response.</p>
                    </div>

                    <!-- Role-Context Segmented Toggle -->
                    <div class="p-signin-roles">
                        <div class="p-signin-roles__label-row">
                            <span>OPERATIONAL ENTITY:</span>
                            <span class="p-signin-roles__selected" id="lblSelectedRole">Factory Buyer</span>
                        </div>
                        <div class="p-signin-roles__segments" style="grid-template-columns: repeat(4, 1fr);" role="tablist">
                            <button type="button" class="p-signin-role-btn active" data-role="Factory" data-email="factory@plant.com" data-pwd="Factory@123" data-hint="Access RFQ Dispatch, Breakdown Escalations & Plant Equipment">
                                <i class="fa-solid fa-industry" aria-hidden="true"></i>
                                <span>Factory</span>
                            </button>
                            <button type="button" class="p-signin-role-btn" data-role="Supplier" data-email="supplier@parts.com" data-pwd="Supplier@123" data-hint="Manage Inventory Stock, Quote Submissions & Regional Deliveries">
                                <i class="fa-solid fa-boxes-stacked" aria-hidden="true"></i>
                                <span>Supplier</span>
                            </button>
                            <button type="button" class="p-signin-role-btn" data-role="Technician" data-email="tech@service.com" data-pwd="Tech@123" data-hint="View Service Dispatches, Work Orders & On-Call Deployment">
                                <i class="fa-solid fa-wrench" aria-hidden="true"></i>
                                <span>Engineer</span>
                            </button>
                            <button type="button" class="p-signin-role-btn" data-role="Admin" data-email="admin@sparepartportal.com" data-pwd="Admin@123" data-hint="Platform Administration, User Governance & System Audit">
                                <i class="fa-solid fa-shield-halved" aria-hidden="true"></i>
                                <span>Admin</span>
                            </button>
                        </div>
                        <div class="p-signin-roles__hint" id="roleHint">
                            Access RFQ Dispatch, Breakdown Escalations & Plant Equipment
                        </div>
                    </div>

                    <!-- Demo Credentials Quick-Fill Strip -->
                    <div class="mb-4 p-3 bg-[#F1F5F9] border border-[#CBD5E1] rounded-md text-xs">
                        <div class="flex items-center justify-between mb-2">
                            <span class="font-bold text-[#0F172A] uppercase tracking-wider text-[10px] flex items-center gap-1.5">
                                <i class="fa-solid fa-key text-[#1769E0]"></i> Demo Test Accounts (Click to Fill)
                            </span>
                            <span class="text-[10px] font-mono text-[#64748B]">Auto-Loads Form</span>
                        </div>
                        <div class="grid grid-cols-2 gap-2 text-[11px]">
                            <button type="button" class="demo-fill-btn text-left p-2 bg-white hover:bg-blue-50 border border-slate-200 rounded transition flex flex-col" data-role="Factory" data-email="factory@plant.com" data-pwd="Factory@123">
                                <span class="font-bold text-[#0F172A]">🏭 Factory Buyer</span>
                                <span class="text-[10px] font-mono text-slate-500">factory@plant.com</span>
                            </button>
                            <button type="button" class="demo-fill-btn text-left p-2 bg-white hover:bg-emerald-50 border border-slate-200 rounded transition flex flex-col" data-role="Supplier" data-email="supplier@parts.com" data-pwd="Supplier@123">
                                <span class="font-bold text-[#0F172A]">📦 Supplier Hub</span>
                                <span class="text-[10px] font-mono text-slate-500">supplier@parts.com</span>
                            </button>
                            <button type="button" class="demo-fill-btn text-left p-2 bg-white hover:bg-amber-50 border border-slate-200 rounded transition flex flex-col" data-role="Technician" data-email="tech@service.com" data-pwd="Tech@123">
                                <span class="font-bold text-[#0F172A]">🔧 Field Engineer</span>
                                <span class="text-[10px] font-mono text-slate-500">tech@service.com</span>
                            </button>
                            <button type="button" class="demo-fill-btn text-left p-2 bg-white hover:bg-purple-50 border border-slate-200 rounded transition flex flex-col" data-role="Admin" data-email="admin@sparepartportal.com" data-pwd="Admin@123">
                                <span class="font-bold text-[#0F172A]">🛡️ Administrator</span>
                                <span class="text-[10px] font-mono text-slate-500">admin@sparepartportal.com</span>
                            </button>
                        </div>
                    </div>

                    <!-- Server Alert Panel -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="c-alert c-alert--error">
                        <i class="fa-solid fa-circle-exclamation text-sm shrink-0 mt-0.5" aria-hidden="true"></i>
                        <div>
                            <strong class="block font-bold">Authentication Exception</strong>
                            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                        </div>
                    </asp:Panel>

                    <!-- Authentication Form Controls -->
                    <div class="p-signin-fields">
                        
                        <!-- Email Input -->
                        <div class="c-form-group">
                            <div class="c-form-header">
                                <label class="c-form-label" for="<%= txtEmail.ClientID %>">
                                    Corporate Email <span class="c-form-label__required">*</span>
                                </label>
                                <span class="c-form-label__hint">WORK ID</span>
                            </div>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" autocomplete="email" 
                                CssClass="c-form-input" 
                                Placeholder="procurement@industrial-plant.com" Required="true"></asp:TextBox>
                        </div>

                        <!-- Password Input with Toggle -->
                        <div class="c-form-group">
                            <div class="c-form-header">
                                <label class="c-form-label" for="<%= txtPassword.ClientID %>">
                                    Terminal Password <span class="c-form-label__required">*</span>
                                </label>
                                <span class="c-form-label__hint">MIN 6 CHARS</span>
                            </div>
                            <div class="c-input-wrap">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" autocomplete="current-password" 
                                    CssClass="c-form-input c-form-input--password" 
                                    Placeholder="••••••••••••" Required="true"></asp:TextBox>
                                <button type="button" id="btnTogglePassword" class="c-password-toggle" 
                                    aria-label="Show password" title="Show password" tabindex="0">
                                    <i class="fa-regular fa-eye" id="iconEye" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Remember Me Option -->
                        <div class="p-signin-remember-row">
                            <label class="c-checkbox-label">
                                <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="c-checkbox" />
                                <span>Keep session authenticated</span>
                            </label>
                            <a href="~/Public/WhyUs.aspx" runat="server" class="p-signin-help-link">Help &amp; Docs</a>
                        </div>

                        <!-- Submit Action Button -->
                        <div class="p-signin-action-wrap">
                            <asp:Button ID="btnLogin" runat="server" Text="Sign In to Portal &rarr;" OnClick="btnLogin_Click" 
                                CssClass="c-btn c-btn--primary p-signin-submit-btn" />
                        </div>

                    </div>

                    <!-- Footer Navigation -->
                    <div class="p-signin-footer-links">
                        <div>
                            New organization? 
                            <a href="~/Account/Register.aspx" runat="server" class="p-signin-register-link">
                                Register Account&nbsp;&rarr;
                            </a>
                        </div>
                        <div>
                            <a href="~/Public/HowItWorks.aspx" runat="server" class="p-signin-guide-link">
                                <i class="fa-solid fa-book-bookmark mr-1" aria-hidden="true"></i> Workflow Guide
                            </a>
                        </div>
                    </div>

                    <!-- Demonstration System Status Strip -->
                    <div class="p-signin-status-strip">
                        <div class="p-signin-status-left">
                            <span class="u-pulse-beacon"></span>
                            <span>ALL MODULES READY</span>
                        </div>
                        <div>
                            Simulated Environment &middot; <strong>MCA Demo</strong>
                        </div>
                    </div>

                </div>
            </div>

            <!-- ====================================================================
                 RIGHT PANEL: INDUSTRIAL CONTEXT & DEMONSTRATION WORKFLOWS
                 ==================================================================== -->
            <div class="p-signin-visual-col">
                
                <!-- Workshop Backdrop Imagery + Directional Scrim Overlay -->
                <div class="p-signin-visual-bg" aria-hidden="true">
                    <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>" alt="" class="p-signin-visual-img" />
                    <div class="p-signin-visual-scrim"></div>
                </div>

                <!-- Editorial Headlines & Value Proposition -->
                <div class="p-signin-visual-content">
                    
                    <div class="c-badge c-badge--blue p-signin-visual-badge">
                        <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                        <span>MCA CAPSTONE PROJECT &middot; DEMO PLATFORM</span>
                    </div>

                    <h2 class="p-signin-visual-title">
                        Streamlining industrial spare parts discovery & emergency dispatch.
                    </h2>

                    <p class="p-signin-visual-desc">
                        ASTANTRA models a multi-vendor procurement network connecting industrial plant buyers, regional parts suppliers, and certified field technicians for RFQ comparison, catalog inquiries, and rapid equipment breakdown escalation.
                    </p>

                    <!-- Real-Time Activity Feed Ticker (Simulated Demonstration) -->
                    <div class="p-signin-telemetry">
                        <div class="p-signin-telemetry__header">
                            <div class="p-signin-telemetry__title">
                                <span class="u-pulse-beacon"></span>
                                <span>DEMO ACTIVITY STREAM</span>
                            </div>
                            <span class="p-signin-telemetry__tag">SIMULATED DATA</span>
                        </div>
                        <div class="p-signin-telemetry__feed" id="webformsTelemetryFeed">
                            <div class="p-signin-telemetry__row">
                                <span class="p-signin-telemetry__time">14:28:12</span>
                                <span class="c-badge c-badge--blue">RFQ MATCH</span>
                                <span class="p-signin-telemetry__msg">Plant #3 requested quotation: SKF 6312 Bearing</span>
                            </div>
                            <div class="p-signin-telemetry__row">
                                <span class="p-signin-telemetry__time">14:26:45</span>
                                <span class="c-badge c-badge--emergency">BREAKDOWN</span>
                                <span class="p-signin-telemetry__msg">Hydraulic Solenoid breakdown ticket escalated</span>
                            </div>
                        </div>
                    </div>

                    <!-- Verified Platform Specifications -->
                    <div class="p-signin-metrics">
                        <div class="c-stat-card">
                            <div class="c-stat-card__value">3<span> Roles</span></div>
                            <div class="c-stat-card__label">Factory &middot; Supplier &middot; Tech</div>
                        </div>
                        <div class="c-stat-card">
                            <div class="c-stat-card__value">2<span> Flows</span></div>
                            <div class="c-stat-card__label">RFQ &middot; Emergency Desk</div>
                        </div>
                        <div class="c-stat-card">
                            <div class="c-stat-card__value">SQL<span> Server</span></div>
                            <div class="c-stat-card__label">Relational ADO.NET Schema</div>
                        </div>
                    </div>

                </div>

                <!-- Subordinate Visual Footer -->
                <div class="p-signin-visual-footer">
                    <div class="p-signin-visual-security">
                        <i class="fa-solid fa-shield-halved text-emerald-600" aria-hidden="true"></i>
                        <span>ROLE-BASED ACCESS CONTROL &middot; SECURE SESSION</span>
                    </div>
                    <div>ASTANTRA v2.4 // MCA DEMO</div>
                </div>

            </div>

        </div>
    </section>

    <!-- Client-side Password Visibility Toggle & Simulated Activity Ticker -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Password toggle
            var toggleBtn = document.getElementById('btnTogglePassword');
            var pwdInput = document.getElementById('<%= txtPassword.ClientID %>');
            var eyeIcon = document.getElementById('iconEye');

            if (toggleBtn && pwdInput && eyeIcon) {
                toggleBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    var isPassword = pwdInput.type === 'password';
                    pwdInput.type = isPassword ? 'text' : 'password';
                    eyeIcon.classList.toggle('fa-eye', !isPassword);
                    eyeIcon.classList.toggle('fa-eye-slash', isPassword);
                    var label = isPassword ? 'Hide password' : 'Show password';
                    toggleBtn.setAttribute('aria-label', label);
                    toggleBtn.setAttribute('title', label);
                });
            }

            // Role Segment switcher & Demo credentials autofill
            var roleButtons = document.querySelectorAll('.p-signin-role-btn');
            var demoButtons = document.querySelectorAll('.demo-fill-btn');
            var lblSelectedRole = document.getElementById('lblSelectedRole');
            var roleHint = document.getElementById('roleHint');
            var emailInput = document.getElementById('<%= txtEmail.ClientID %>');

            function applyCredentials(role, email, pwd) {
                if (emailInput && email) emailInput.value = email;
                if (pwdInput && pwd) pwdInput.value = pwd;

                roleButtons.forEach(function (b) {
                    if (b.getAttribute('data-role') === role) {
                        b.classList.add('active');
                        var hint = b.getAttribute('data-hint');
                        if (lblSelectedRole) {
                            lblSelectedRole.textContent = role === 'Technician' ? 'Field Engineer' : (role === 'Admin' ? 'Administrator' : role + ' Buyer');
                        }
                        if (roleHint) {
                            roleHint.textContent = hint;
                        }
                    } else {
                        b.classList.remove('active');
                    }
                });
            }

            demoButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var role = btn.getAttribute('data-role');
                    var email = btn.getAttribute('data-email');
                    var pwd = btn.getAttribute('data-pwd');
                    applyCredentials(role, email, pwd);
                });
            });

            roleButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var role = btn.getAttribute('data-role');
                    var email = btn.getAttribute('data-email');
                    var pwd = btn.getAttribute('data-pwd');
                    applyCredentials(role, email, pwd);
                });
            });

            // Simulated Telemetry Activity Feed
            var feedContainer = document.getElementById('webformsTelemetryFeed');
            var items = [
                { time: '14:28:12', badgeClass: 'c-badge c-badge--blue', tag: 'RFQ MATCH', text: 'Plant #3 requested quotation: SKF 6312 Bearing' },
                { time: '14:26:45', badgeClass: 'c-badge c-badge--emergency', tag: 'BREAKDOWN', text: 'Hydraulic Solenoid breakdown ticket escalated' },
                { time: '14:24:02', badgeClass: 'c-badge c-badge--verified', tag: 'QUOTE BID', text: 'Supplier submitted quotation: Siemens S7-1200 CPU' },
                { time: '14:21:18', badgeClass: 'c-badge c-badge--blue', tag: 'RFQ MATCH', text: 'Hydraulic Pump Assembly inquiry routed to 4 vendors' },
                { time: '14:18:50', badgeClass: 'c-badge c-badge--verified', tag: 'DISPATCH', text: 'Field Engineer #E-401 assigned to Thermal Plant' }
            ];

            var currIdx = 0;
            function updateFeed() {
                if (!feedContainer) return;
                feedContainer.innerHTML = '';
                for (var i = 0; i < 2; i++) {
                    var itm = items[(currIdx + i) % items.length];
                    var row = document.createElement('div');
                    row.className = 'p-signin-telemetry__row';
                    row.innerHTML = 
                        '<span class="p-signin-telemetry__time">' + itm.time + '</span>' +
                        '<span class="' + itm.badgeClass + '">' + itm.tag + '</span>' +
                        '<span class="p-signin-telemetry__msg">' + itm.text + '</span>';
                    feedContainer.appendChild(row);
                }
            }

            setInterval(function () {
                currIdx = (currIdx + 1) % items.length;
                updateFeed();
            }, 4200);
        });
    </script>
</asp:Content>

