<%@ Page Title="Field Technician Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Technicians.aspx.cs" Inherits="IndustrialSparePartPortal.Public.Technicians" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="Connect with certified industrial field service engineers for machine troubleshooting, PLC automation, and hydraulic repairs." />
    <link href="<%= ResolveUrl("~/Content/css/public/technicians.css") %>" rel="stylesheet" />
    <style>
        .technician-card {
            background: var(--color-bg-surface);
            border: 1px solid var(--color-border-default);
            border-radius: var(--radius-lg);
            padding: var(--space-6);
            transition: all var(--transition-normal);
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .technician-card:hover {
            box-shadow: var(--shadow-elevated);
            transform: translateY(-4px);
            border-color: var(--color-brand-primary);
        }

        .technician-header {
            display: flex;
            align-items: flex-start;
            gap: var(--space-4);
            margin-bottom: var(--space-4);
            padding-bottom: var(--space-4);
            border-bottom: 1px solid var(--color-border-subtle);
        }

        .technician-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--color-brand-primary), var(--color-brand-secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--color-text-inverse);
            font-size: var(--text-2xl);
            font-weight: var(--font-weight-bold);
            flex-shrink: 0;
        }

        .technician-info h3 {
            margin: 0 0 var(--space-1) 0;
            font-size: var(--text-lg);
            color: var(--color-text-primary);
        }

        .technician-meta {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            font-size: var(--text-sm);
            color: var(--color-text-secondary);
            margin-bottom: var(--space-2);
        }

        .technician-status {
            display: inline-flex;
            align-items: center;
            gap: var(--space-1);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-semibold);
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-full);
        }

        .status-available {
            background-color: var(--color-status-success-bg);
            color: var(--color-status-success);
        }

        .status-engaged {
            background-color: var(--color-status-warning-bg);
            color: var(--color-status-warning);
        }

        .technician-rating {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            margin-top: var(--space-2);
        }

        .rating-stars {
            color: #FFC107;
            font-size: var(--text-sm);
        }

        .rating-value {
            font-size: var(--text-sm);
            font-weight: var(--font-weight-semibold);
            color: var(--color-text-primary);
        }

        .technician-skills {
            margin: var(--space-4) 0;
        }

        .skills-label {
            font-size: var(--text-xs);
            font-weight: var(--font-weight-bold);
            text-transform: uppercase;
            letter-spacing: var(--letter-spacing-wide);
            color: var(--color-text-secondary);
            margin-bottom: var(--space-2);
        }

        .skills-list {
            display: flex;
            flex-wrap: wrap;
            gap: var(--space-2);
        }

        .skill-badge {
            background-color: var(--color-brand-primary-light);
            color: var(--color-brand-primary-dark);
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-semibold);
        }

        .technician-footer {
            display: flex;
            gap: var(--space-2);
            margin-top: auto;
            padding-top: var(--space-4);
            border-top: 1px solid var(--color-border-subtle);
        }

        .technician-footer button {
            flex: 1;
        }

        .filter-card {
            background: var(--color-bg-surface);
            border: 1px solid var(--color-border-default);
            border-radius: var(--radius-lg);
            padding: var(--space-4);
            margin-bottom: var(--space-4);
        }

        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: var(--space-3);
            align-items: flex-end;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-label {
            display: block;
            font-size: var(--text-sm);
            font-weight: var(--font-weight-semibold);
            color: var(--color-text-primary);
            margin-bottom: var(--space-2);
        }

        .filter-buttons {
            display: flex;
            gap: var(--space-2);
        }

        .results-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-6);
            padding: var(--space-3) 0;
            border-bottom: 1px solid var(--color-border-subtle);
        }

        .results-count {
            font-size: var(--text-sm);
            font-weight: var(--font-weight-semibold);
            color: var(--color-text-primary);
        }

        .results-badge {
            display: inline-flex;
            align-items: center;
            gap: var(--space-1);
            font-size: var(--text-xs);
            color: var(--color-text-secondary);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HERO SECTION -->
    <div class="hero hero--minimal l-section--no-padding">
        <div class="container">
            <div style="max-width: 800px;">
                <h6 style="margin-bottom: var(--space-2); color: var(--color-brand-primary);">
                    <i class="fa-solid fa-tools"></i> Field Service Engineering
                </h6>
                <h1 style="margin-bottom: var(--space-4); font-size: var(--text-4xl);">Certified Field Technicians</h1>
                <p style="font-size: var(--text-lg); color: var(--color-text-secondary); line-height: var(--leading-relaxed); margin-bottom: 0;">
                    Connect with certified, on-demand field engineers. Mobilize expertise in machine diagnostics, PLC troubleshooting, 
                    high-pressure hydraulics, and precision fitting across Gujarat's manufacturing corridor.
                </p>
            </div>
        </div>
    </div>

    <!-- FILTERS SECTION -->
    <div class="l-section">
        <div class="container">
            <div class="filter-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-4);">
                    <h3 style="margin: 0; font-size: var(--text-lg);">
                        <i class="fa-solid fa-sliders"></i> Find Technicians
                    </h3>
                </div>

                <div class="filter-section">
                    <!-- Search -->
                    <div class="filter-group" style="flex: 2; position: relative; min-width: 250px;">
                        <label class="filter-label">Name or Specialty</label>
                        <div style="position: relative;">
                            <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: var(--space-3); top: 50%; transform: translateY(-50%); color: var(--color-text-muted);" ></i>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search technician name or skill..." 
                                style="padding-left: 36px; width: 100%; padding: var(--space-2) var(--space-3) var(--space-2) 36px; border: 1px solid var(--color-border-default); border-radius: var(--radius-md);" />
                        </div>
                    </div>

                    <!-- Skill Selection -->
                    <div class="filter-group">
                        <label class="filter-label">Technical Skill</label>
                        <asp:DropDownList ID="ddlSkill" runat="server" CssClass="form-control" style="width: 100%; padding: var(--space-2) var(--space-3); border: 1px solid var(--color-border-default); border-radius: var(--radius-md);">
                            <asp:ListItem Value="" Text="All Skills" />
                            <asp:ListItem Value="Hydraulic" Text="Hydraulic Systems" />
                            <asp:ListItem Value="CNC" Text="CNC Machinery" />
                            <asp:ListItem Value="PLC" Text="Electrical & PLC" />
                            <asp:ListItem Value="Mechanical" Text="Mechanical & Pumps" />
                            <asp:ListItem Value="Automation" Text="Industrial Automation" />
                        </asp:DropDownList>
                    </div>

                    <!-- Location Selection -->
                    <div class="filter-group">
                        <label class="filter-label">Location</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control" style="width: 100%; padding: var(--space-2) var(--space-3); border: 1px solid var(--color-border-default); border-radius: var(--radius-md);">
                            <asp:ListItem Value="" Text="All Locations" />
                            <asp:ListItem Value="Ahmedabad" Text="Ahmedabad, GJ" />
                            <asp:ListItem Value="Pune" Text="Pune, MH" />
                            <asp:ListItem Value="Mumbai" Text="Mumbai, MH" />
                            <asp:ListItem Value="Vadodara" Text="Vadodara, GJ" />
                            <asp:ListItem Value="Rajkot" Text="Rajkot, GJ" />
                            <asp:ListItem Value="Surat" Text="Surat, GJ" />
                        </asp:DropDownList>
                    </div>

                    <!-- Action Buttons -->
                    <div class="filter-buttons">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="btn btn-primary" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn btn-secondary" />
                    </div>
                </div>
            </div>

            <!-- RESULTS METADATA -->
            <div class="results-meta">
                <div>
                    <span class="results-count"><asp:Label ID="lblResultsCount" runat="server">Loading...</asp:Label></span>
                </div>
                <div class="results-badge">
                    <i class="fa-solid fa-check-circle"></i> Verified Network
                </div>
            </div>

            <!-- TECHNICIAN GRID -->
            <div class="responsive-grid">
                <asp:Repeater ID="rptTechnicians" runat="server">
                    <ItemTemplate>
                        <div class="technician-card">
                            <!-- Card Header with Avatar -->
                            <div class="technician-header">
                                <div class="technician-avatar">
                                    <i class="fa-solid fa-user-gear"></i>
                                </div>
                                <div class="technician-info" style="flex: 1;">
                                    <h3><%# Eval("FullName") %></h3>
                                    <div class="technician-meta">
                                        <i class="fa-solid fa-location-dot"></i>
                                        <span><%# Eval("City") %>, <%# Eval("State") %></span>
                                    </div>
                                    <div>
                                        <span class="technician-status <%# Convert.ToBoolean(Eval("IsAvailable")) ? "status-available" : "status-engaged" %>">
                                            <i class="fa-solid <%# Convert.ToBoolean(Eval("IsAvailable")) ? "fa-circle-check" : "fa-calendar-check" %>"></i>
                                            <%# Convert.ToBoolean(Eval("IsAvailable")) ? "Available Now" : "Engaged" %>
                                        </span>
                                    </div>
                                    <div class="technician-rating">
                                        <span class="rating-stars">
                                            <i class="fa-solid fa-star"></i>
                                            <i class="fa-solid fa-star"></i>
                                            <i class="fa-solid fa-star"></i>
                                            <i class="fa-solid fa-star"></i>
                                            <i class="fa-solid fa-star-half-stroke"></i>
                                        </span>
                                        <span class="rating-value">4.8 (48 reviews)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Skills Section -->
                            <div class="technician-skills">
                                <div class="skills-label">Technical Expertise</div>
                                <div class="skills-list">
                                    <span class="skill-badge">Hydraulics</span>
                                    <span class="skill-badge">PLC</span>
                                    <span class="skill-badge">CNC</span>
                                </div>
                            </div>

                            <!-- Description -->
                            <p style="color: var(--color-text-secondary); font-size: var(--text-sm); line-height: var(--leading-relaxed); margin-bottom: auto;">
                                <%# Eval("Description") %>
                            </p>

                            <!-- Footer with Actions -->
                            <div class="technician-footer">
                                <button class="btn btn-primary btn-sm">View Profile</button>
                                <button class="btn btn-ghost btn-sm">Contact Now</button>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Empty State -->
            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div style="text-align: center; padding: var(--space-12); background: var(--color-bg-subtle); border-radius: var(--radius-lg);">
                    <i class="fa-solid fa-search" style="font-size: var(--text-5xl); color: var(--color-text-muted); margin-bottom: var(--space-3);"></i>
                    <h3 style="color: var(--color-text-primary); margin-bottom: var(--space-2);">No technicians found</h3>
                    <p style="color: var(--color-text-secondary);">Try adjusting your filters or search criteria</p>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

</asp:Content>                            
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Primary Skill</div>
                                    <div style="font-size: 13px; font-weight: 600; color: var(--sf-navy);">
                                        <%# Eval("SkillSummary") %>
                                    </div>
                                </div>
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Experience</div>
                                    <div style="font-size: 13px; font-weight: 600; color: var(--sf-navy);">
                                        <%# Eval("ExperienceYears") %> Years
                                    </div>
                                </div>
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Hourly Rate</div>
                                    <div style="font-size: 13px; font-weight: 600; color: var(--sf-navy);">
                                        <%# (Eval("HourlyRate") != null && Eval("HourlyRate") != DBNull.Value) ? "₹" + string.Format("{0:N0}", Eval("HourlyRate")) + "/hr" : "Negotiable" %>
                                    </div>
                                </div>
                                <div>
                                    <div style="font-size: 11px; text-transform: uppercase; color: var(--sf-text-light); font-weight: 700; margin-bottom: 4px;">Verification</div>
                                    <div style="font-size: 13px; font-weight: 600; color: var(--sf-navy);">
                                        <%# Eval("VerificationStatus").ToString() == "Verified" ? "<i class=\"fa-solid fa-check-circle\" style=\"color: var(--sf-success);\"></i> Certified" : "Standard" %>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="border-top: 1px solid var(--sf-border); margin: 0 -20px; padding: 16px 20px 0;">
                            <!-- Action button -->
                            <a href="~/Public/Emergency.aspx" runat="server" class="sf-btn sf-btn-outline" style="width: 100%; justify-content: center; font-size: 13px; padding: 8px;">
                                Request Engineer
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <!-- EMPTY STATE -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="text-align: center; padding: 64px 0; background: var(--sf-surface); border: 1px dashed var(--sf-border); border-radius: var(--sf-radius-md); margin-top: 24px;">
            <i class="fa-solid fa-helmet-safety" style="font-size: 32px; color: var(--sf-border); margin-bottom: 16px;"></i>
            <h3 style="font-size: 16px; color: var(--sf-navy); margin: 0 0 8px 0;">No matching technicians found</h3>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0 0 16px 0;">Try adjusting your skill filters or location preferences.</p>
            <asp:Button ID="btnResetNoResults" runat="server" Text="Reset Filters" OnClick="btnReset_Click" CssClass="sf-btn sf-btn-outline" />
        </asp:Panel>
        
    </div>
</asp:Content>
