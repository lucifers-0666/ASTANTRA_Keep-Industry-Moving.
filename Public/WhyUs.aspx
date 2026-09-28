<%@ Page Title="Why SPAREFINDER" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="WhyUs.aspx.cs" Inherits="IndustrialSparePartPortal.Public.WhyUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="<%= ResolveUrl("~/Content/css/public/why-us.css") %>" rel="stylesheet" />
    <meta name="description" content="Discover the practical reasons industrial procurement teams rely on SPAREFINDER." />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="background: var(--sf-surface); border-bottom: 1px solid var(--sf-border); padding: 48px 0;">
        <div class="sf-container" style="max-width: 960px;">
            <span style="font-size: 12px; font-weight: 700; color: var(--sf-primary); text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 8px;">
                Platform Value
            </span>
            <h1 style="font-size: 28px; color: var(--sf-navy); margin: 0 0 12px 0;">Why Choose SPAREFINDER?</h1>
            <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; max-width: 600px;">
                A specialized network bridging the gap between factory floors, regional spare-part stockists, and independent engineering talent.
            </p>
        </div>
    </div>

    <div class="sf-container" style="max-width: 960px; padding-top: 64px; padding-bottom: 64px;">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            
            <div class="sf-card" style="padding: 32px;">
                <i class="fa-solid fa-shield-halved" style="font-size: 32px; color: var(--sf-primary); margin-bottom: 24px;"></i>
                <h3 style="font-size: 18px; color: var(--sf-navy); margin: 0 0 12px 0;">Verified Suppliers Only</h3>
                <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; line-height: 1.6;">
                    Every supplier in our network undergoes a strict verification process. We mandate GST/tax documentation, physical warehouse verification, and OEM authorization certificates before they can bid on your RFQs.
                </p>
            </div>

            <div class="sf-card" style="padding: 32px;">
                <i class="fa-solid fa-scale-balanced" style="font-size: 32px; color: var(--sf-primary); margin-bottom: 24px;"></i>
                <h3 style="font-size: 18px; color: var(--sf-navy); margin: 0 0 12px 0;">Transparent Comparison</h3>
                <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; line-height: 1.6;">
                    Abandon the traditional phone-and-email procurement scramble. Receive standardized, side-by-side quotations detailing exact unit price, transit lead time, warranty periods, and technical specifications.
                </p>
            </div>

            <div class="sf-card" style="padding: 32px;">
                <i class="fa-solid fa-stopwatch" style="font-size: 32px; color: var(--sf-primary); margin-bottom: 24px;"></i>
                <h3 style="font-size: 18px; color: var(--sf-navy); margin: 0 0 12px 0;">Accelerated Procurement</h3>
                <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; line-height: 1.6;">
                    By centralizing the supplier base geographically, our localized search algorithms match your plant with the closest stocking distributor, significantly reducing transit delays for critical replacement components.
                </p>
            </div>

            <div class="sf-card" style="padding: 32px;">
                <i class="fa-solid fa-user-gear" style="font-size: 32px; color: var(--sf-primary); margin-bottom: 24px;"></i>
                <h3 style="font-size: 18px; color: var(--sf-navy); margin: 0 0 12px 0;">Integrated Technical Support</h3>
                <p style="font-size: 14px; color: var(--sf-text-muted); margin: 0; line-height: 1.6;">
                    Having the part is only half the solution. Our platform provides direct access to a certified roster of independent field engineers ready for immediate dispatch to install, calibrate, and troubleshoot your machinery.
                </p>
            </div>

        </div>
    </div>
</asp:Content>
