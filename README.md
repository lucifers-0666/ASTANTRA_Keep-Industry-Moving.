# ASTANTRA — Industrial Spare Parts Procurement & Maintenance Network

> **Tagline**: Keep Industry Moving &middot; Industrial Parts &middot; Procurement &middot; Services  
> **Official Brand Guide**: See [`docs/brand-guide.md`](docs/brand-guide.md) for brand identity tokens, vector logo assets, and viva voce defense notes.

An enterprise B2B Web Application built with **ASP.NET Web Forms**, **C#**, **SQL Server (ADO.NET)**, and **Tailwind CSS**.

The platform connects **Factory Buyers**, **Verified Spare-Part Suppliers**, **Certified Field Technicians**, and **System Administrators** into a single real-time resolution pipeline to eliminate industrial machine breakdown downtime.

---

## 🎯 Problem Statement

Industrial manufacturing facilities suffer severe financial losses (often exceeding ₹50,000+ per hour) during unscheduled machine breakdowns. Traditional procurement relies on manual vendor calling, unknown OEM part numbers, price uncertainty, and a lack of available field technicians for installation.

---

## 💡 Proposed Solution

The **Industrial Spare-Part Finder & Emergency Procurement Portal** provides a streamlined 6-step resolution path:
1. **Search Catalog**: Match exact OEM part numbers, machine models, or categories.
2. **Compare Options**: View supplier distance (km), stock availability, and unit pricing side-by-side.
3. **Issue Requests**: Submit Requests for Quotation (RFQ) or trigger Emergency Breakdown Alerts.
4. **Connect**: Receive instant supplier bids & book certified field service technicians.
5. **Procure**: Approve purchase orders and initiate priority dispatch.
6. **Track & Resolve**: Follow real-time dispatch and technician arrival until plant capacity is restored.

---

## 👥 Core User Roles & Responsibilities

| Role | Key Capabilities & Functionality |
| :--- | :--- |
| **Factory Buyer** | Part search, supplier stock/price comparison, RFQ generation, emergency breakdown alert dispatch, technician booking, request tracking. |
| **Supplier** | Inventory stock & price management, RFQ quotation bidding, emergency breakdown order fulfillment, GSTIN document submission. |
| **Technician** | Skill profiling (hydraulics, CNC, VFDs), hourly service rates (₹/hr), real-time duty status toggle, on-site repair visits. |
| **Administrator** | User entity verification, GSTIN auditing, system analytics, dispute resolution, security policy governance. |

---

## 🛠️ Technology Stack

- **Framework**: ASP.NET Web Forms Web Application Project (`.csproj`) on .NET Framework 4.8
- **Language**: C# 7.3
- **Database Engine**: Microsoft SQL Server LocalDB (`(localdb)\MSSQLLocalDB`)
- **Data Access Layer**: Direct, parameterized ADO.NET (`SqlConnection`, `SqlCommand`, `SqlDataReader`)
- **Authentication**: ASP.NET Forms Authentication & Salted SHA-256 Hasher (`PasswordHasher.cs`)
- **Frontend Presentation**: Tailwind CSS, custom light industrial CSS design system, and Vanilla JavaScript

---

## 📁 Project Architecture & Directory Structure

```
industrial-spare-part-portal/
├── README.md                           # Master Project Documentation
├── LICENSE                             # MIT License
├── .gitignore                          # ASP.NET, Visual Studio, & Node Ignore Rules
│
├── docs/                               # Comprehensive Technical Documentation
│   ├── project-definition.md          # MCA Project Scope & Requirements
│   ├── project-structure.md           # Architecture & Technical Solution Tree
│   └── design-system.md               # Light Industrial Visual Identity & Color Tokens
│
├── database/                           # Database Migration & Seed Data
│   ├── Tables/01_CreateTables.sql     # DDL Table Definitions
│   ├── Seed/02_SeedData.sql           # Seed Data & Salted Demo Admin Account
│   └── README.md                       # LocalDB Setup Guide
│
├── App_Code/                           # Business Logic, Models, & ADO.NET Repositories
├── MasterPages/                        # Shared Layout Master Pages (Site, Admin, Factory, Supplier, Technician)
├── Account/                            # Authentication Pages (Login, Register, Logout)
├── Admin/                              # Admin Governance Portal Pages
├── Factory/                            # Factory Buyer Portal Pages
├── Supplier/                           # Supplier Hub Pages
├── Technician/                         # Field Technician Portal Pages
├── Content/                            # Production Assets & Compiled CSS
├── Tailwind/                           # Tailwind CSS Configuration & Input Directives
│
├── Default.aspx                        # Main Visitor Landing Page (Redesigned Light System)
├── Global.asax                         # Application Lifecycle Handler
├── Web.config                          # ASP.NET Application Configuration
├── IndustrialSparePartPortal.csproj    # Visual Studio Project File
└── IndustrialSparePartPortal.sln       # Visual Studio Solution File
```

---

## 🎨 UI Design System

The platform features a **Light Industrial B2B Technology Design System**:
- **Primary Page Background (`#F1F3F5`)**: Light cool gray surface grounding technical content.
- **Surface Panels (`#FFFFFF`)**: Pure white surfaces with `#D9DEE5` 1px borders and 3px radius.
- **Primary Text (`#111827`)**: High-contrast dark navy-slate.
- **Secondary Text (`#5F6B7A`)**: Muted slate for subtext and metadata.
- **Primary Action Blue (`#1769E0`)**: Confident B2B interaction blue for buttons and search tabs.
- **Emergency Orange (`#E87519`)**: Reserved strictly for high-priority machine breakdown dispatches.
- **Verified Green (`#18865B`)**: Authenticated entity badges and status indicators.
- **Industrial Navy (`#101C2C`)**: High-impact section band and footer anchor.
- **Typography**: Archivo (headings), IBM Plex Sans (body), IBM Plex Mono (part numbers & tolerances).

---

## 📊 Development & Implementation Status

### Implemented Modules & Features
- [x] Reusable Master Page Layouts (`Site.Master`, `Admin.Master`, `Factory.Master`, `Supplier.Master`, `Technician.Master`)
- [x] Multi-Role User Registration & Authentication (`Account/Login.aspx`, `Account/Register.aspx`)
- [x] Salted SHA-256 Password Security & Strongly-typed Session Manager (`SessionHelper.cs`)
- [x] Redesigned Light Industrial Visitor Landing Experience (`Default.aspx`)
- [x] Multi-Tab Spare-Part Search Preview & Category Filtering
- [x] Enterprise B2B Supplier Comparison Software Table
- [x] Emergency Machine Breakdown Procurement Alert Protocol
- [x] Field Technician Discovery & Service Profile Showcase
- [x] Parameterized ADO.NET Database Layer (`DbFactory.cs`, `UserRepository.cs`)
- [x] SQL Schema (`01_CreateTables.sql`) and Seed Data (`02_SeedData.sql`)

### Planned Modules
- [ ] Live Real-Time SignalR Supplier Notification Broadcasts
- [ ] PDF Purchase Order Generation
- [ ] Payment Gateway Integration

---

## 🎓 Academic Note

This project is an **MCA Final-Year Academic Project**. While the frontend presentation utilizes modern B2B technology standards, the backend architecture deliberately maintains clean, explainable ASP.NET Web Forms, ADO.NET, and SQL Server conventions for viva evaluation.

