<%@ Page Title="Industrial Spare Parts Procurement Network" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IndustrialSparePartPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/home.css") %>" rel="stylesheet" />
    <meta name="description" content="Find industrial spare parts, compare suppliers, and get support when a machine breaks down." />
    <script src="<%= ResolveUrl("~/Content/js/ux-utils.js") %>"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HERO SECTION -->
    <section class="sf-hero" style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 64px 0;">
        <div class="sf-container">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center sf-animate-fade-up">
                
                <div class="space-y-6">
                    <span style="color: var(--sf-primary); font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em;">
                        Industrial Spare Parts Procurement
                    </span>
                    <h1 style="font-size: 42px; line-height: 1.15; color: var(--sf-navy); margin: 0;">
                        Find the Right Spare Parts.<br/>Keep Your Machines Running.
                    </h1>
                    <p style="font-size: 16px; color: var(--sf-text-muted); max-width: 480px; margin: 0;">
                        Source industrial spare parts, compare verified suppliers, and access technical support from one centralized platform.
                    </p>
                    
                    <div class="flex gap-4 pt-4">
                        <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-primary" style="padding: 12px 24px; font-size: 15px;">
                            <i class="fa-solid fa-magnifying-glass"></i> Search Spare Parts
                        </a>
                        <a href="~/Public/Emergency.aspx" runat="server" class="sf-btn sf-btn-outline" style="padding: 12px 24px; font-size: 15px;">
                            Emergency Request
                        </a>
                    </div>
                </div>

                <div class="sf-hero-image" style="border-radius: var(--sf-radius-lg); overflow: hidden; border: 1px solid var(--sf-border); box-shadow: var(--sf-shadow-sm);">
                    <img src="<%= ResolveUrl("~/Content/images/hero_plant_workshop.jpg") %>" alt="Industrial machinery and workshop" style="width: 100%; height: 380px; object-fit: cover;" />
                </div>
            </div>
        </div>
    </section>

    <!-- SEARCH BLOCK -->
    <section style="padding: 64px 0; background: var(--sf-bg);">
        <div class="sf-container">
            <div class="sf-card" style="max-width: 800px; margin: 0 auto; text-align: center;">
                <h2 style="font-size: 24px; color: var(--sf-navy); margin-bottom: 8px;">Find a Spare Part</h2>
                <p style="margin-bottom: 24px; color: var(--sf-text-muted);">Search by part name, OEM part number, or machine model.</p>
                <div style="display: flex; gap: 8px;">
                    <asp:TextBox ID="txtSearchQuery" runat="server" CssClass="sf-input" style="flex: 1; padding: 12px 16px; font-size: 16px;" placeholder="E.g., Hydraulic Pump, Bearing 6205..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="sf-btn sf-btn-navy" style="padding: 12px 24px; font-size: 15px;" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>
    </section>

    <!-- POPULAR CATEGORIES -->
    <section style="padding: 64px 0; background: var(--sf-surface); border-top: 1px solid var(--sf-border);">
        <div class="sf-container">
            <h2 style="font-size: 24px; color: var(--sf-navy); margin-bottom: 32px; text-align: center;">Popular Categories</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
                <!-- Electrical -->
                <a href="~/Public/Parts.aspx?category=electrical" runat="server" class="sf-card sf-card-hover" style="text-align: center; padding: 24px 16px;">
                    <i class="fa-solid fa-bolt" style="font-size: 24px; color: var(--sf-primary); margin-bottom: 12px;"></i>
                    <h3 style="font-size: 14px; margin: 0; color: var(--sf-text);">Electrical</h3>
                </a>
                <!-- Mechanical -->
                <a href="~/Public/Parts.aspx?category=mechanical" runat="server" class="sf-card sf-card-hover" style="text-align: center; padding: 24px 16px;">
                    <i class="fa-solid fa-gear" style="font-size: 24px; color: var(--sf-primary); margin-bottom: 12px;"></i>
                    <h3 style="font-size: 14px; margin: 0; color: var(--sf-text);">Mechanical</h3>
                </a>
                <!-- Hydraulic -->
                <a href="~/Public/Parts.aspx?category=hydraulic" runat="server" class="sf-card sf-card-hover" style="text-align: center; padding: 24px 16px;">
                    <i class="fa-solid fa-water" style="font-size: 24px; color: var(--sf-primary); margin-bottom: 12px;"></i>
                    <h3 style="font-size: 14px; margin: 0; color: var(--sf-text);">Hydraulic</h3>
                </a>
                <!-- Pneumatic -->
                <a href="~/Public/Parts.aspx?category=pneumatic" runat="server" class="sf-card sf-card-hover" style="text-align: center; padding: 24px 16px;">
                    <i class="fa-solid fa-wind" style="font-size: 24px; color: var(--sf-primary); margin-bottom: 12px;"></i>
                    <h3 style="font-size: 14px; margin: 0; color: var(--sf-text);">Pneumatic</h3>
                </a>
                <!-- Automation -->
                <a href="~/Public/Parts.aspx?category=automation" runat="server" class="sf-card sf-card-hover" style="text-align: center; padding: 24px 16px;">
                    <i class="fa-solid fa-microchip" style="font-size: 24px; color: var(--sf-primary); margin-bottom: 12px;"></i>
                    <h3 style="font-size: 14px; margin: 0; color: var(--sf-text);">Automation</h3>
                </a>
            </div>
        </div>
    </section>

    <!-- FEATURED PARTS -->
    <section style="padding: 64px 0; background: var(--sf-bg);">
        <div class="sf-container">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 32px;">
                <div>
                    <h2 style="font-size: 24px; color: var(--sf-navy); margin-bottom: 8px;">Featured Parts</h2>
                    <p style="color: var(--sf-text-muted); margin: 0;">Recently added components from verified suppliers.</p>
                </div>
                <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-outline">View All</a>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- ASP.NET Repeater or ListView would normally go here, but I will simulate the structure -->
                <div class="sf-card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                    <img src="<%= ResolveUrl("~/Content/images/hyd_pump.jpg") %>" alt="Part" style="width: 100%; height: 160px; object-fit: cover;" onerror="this.src='<%= ResolveUrl("~/Content/images/placeholder.png") %>';this.onerror='';" />
                    <div style="padding: 16px;">
                        <div style="font-size: 12px; color: var(--sf-text-muted); margin-bottom: 4px;">PUMP-700</div>
                        <h3 style="font-size: 16px; margin: 0 0 12px 0;">Heavy Duty Hydraulic Pump</h3>
                        <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-primary" style="width: 100%;">View Details</a>
                    </div>
                </div>
                
                <div class="sf-card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                    <img src="<%= ResolveUrl("~/Content/images/bearing.jpg") %>" alt="Part" style="width: 100%; height: 160px; object-fit: cover;" onerror="this.src='<%= ResolveUrl("~/Content/images/placeholder.png") %>';this.onerror='';" />
                    <div style="padding: 16px;">
                        <div style="font-size: 12px; color: var(--sf-text-muted); margin-bottom: 4px;">BRG-6205</div>
                        <h3 style="font-size: 16px; margin: 0 0 12px 0;">Deep Groove Ball Bearing</h3>
                        <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-primary" style="width: 100%;">View Details</a>
                    </div>
                </div>

                <div class="sf-card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                    <img src="<%= ResolveUrl("~/Content/images/motor.jpg") %>" alt="Part" style="width: 100%; height: 160px; object-fit: cover;" onerror="this.src='<%= ResolveUrl("~/Content/images/placeholder.png") %>';this.onerror='';" />
                    <div style="padding: 16px;">
                        <div style="font-size: 12px; color: var(--sf-text-muted); margin-bottom: 4px;">MTR-AC3</div>
                        <h3 style="font-size: 16px; margin: 0 0 12px 0;">3-Phase Induction Motor</h3>
                        <a href="~/Public/Parts.aspx" runat="server" class="sf-btn sf-btn-primary" style="width: 100%;">View Details</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- HOW IT WORKS (Simplified) -->
    <section style="padding: 64px 0; background: var(--sf-surface); border-top: 1px solid var(--sf-border);">
        <div class="sf-container">
            <h2 style="font-size: 24px; color: var(--sf-navy); margin-bottom: 48px; text-align: center;">How SPAREFINDER Works</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-12 relative">
                <!-- Step 1 -->
                <div style="text-align: center;">
                    <div style="width: 48px; height: 48px; border-radius: 24px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 700; margin: 0 auto 16px;">1</div>
                    <h3 style="font-size: 16px; margin-bottom: 8px;">Find a Part</h3>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0;">Search our catalog of industrial components by OEM number or description.</p>
                </div>
                
                <!-- Step 2 -->
                <div style="text-align: center;">
                    <div style="width: 48px; height: 48px; border-radius: 24px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 700; margin: 0 auto 16px;">2</div>
                    <h3 style="font-size: 16px; margin-bottom: 8px;">Compare Suppliers</h3>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0;">Review quotations, lead times, and supplier verification ratings.</p>
                </div>

                <!-- Step 3 -->
                <div style="text-align: center;">
                    <div style="width: 48px; height: 48px; border-radius: 24px; background: rgba(23, 105, 224, 0.1); color: var(--sf-primary); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 700; margin: 0 auto 16px;">3</div>
                    <h3 style="font-size: 16px; margin-bottom: 8px;">Place an Order</h3>
                    <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0;">Procure the part directly and dispatch technical support if needed.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- EMERGENCY (Bottom Callout handled by Site.Master pre-footer normally, but user requested an emergency section on the home page) -->
    <!-- The Pre-Footer emergency callout is already enabled via Site.Master for the homepage, so I will rely on that. -->

</asp:Content>
