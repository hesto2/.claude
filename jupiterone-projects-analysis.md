# JupiterOne Projects Analysis

## Executive Summary

This analysis evaluates five JupiterOne organization projects to understand their dependencies, criticality, and maintenance status. The projects range from highly critical (security-policy-templates) to low-moderate criticality (template repositories) based on their usage patterns and integration depth across the JupiterOne platform.

---

## 1. security-policy-templates

### Overview
A foundational repository providing security policies, standards, and procedures that map to major compliance frameworks.

### Criticality: **HIGH**
- **Purpose**: Core security policy templates for HIPAA, NIST CSF, PCI DSS, SOC2, FedRAMP, and CIS Controls
- **Visibility**: Public repository with 318 stars and 93 forks
- **Business Impact**: Central to JupiterOne's compliance and policy management capabilities

### Projects Using This Repository
- [security-policy-builder](https://github.com/jupiterone/security-policy-builder) - CLI tool for generating policy documentation
- [compliance-service](https://github.com/jupiterone/compliance-service) - Core service for importing/exporting policy templates
- [policy-service](https://github.com/jupiterone/policy-service) - Contains `securityPolicyTemplatesDao` for template management
- [web-compliance](https://github.com/jupiterone/web-compliance) - Frontend application for compliance management
- [web-integrations](https://github.com/jupiterone/web-integrations) - Importable compliance framework templates
- [web-policies](https://github.com/jupiterone/web-policies) - Web interface for policy management
- [web-navbar](https://github.com/jupiterone/web-navbar) - Generated types reference security policy templates
- [internal-securitytracker](https://github.com/jupiterone/internal-securitytracker) - Internal security operations

### Last Updated
- **June 18, 2024** - Added OCI v2.0.0 compliance framework
- Shows signs of maintenance mode with 10 open issues and an unmerged FedRAMP v5 PR from December 2023

---

## 2. email-template-generator

### Overview
A centralized tool for creating and deploying email templates for AWS SES, handling all JupiterOne customer communications.

### Criticality: **MODERATE**
- **Purpose**: Manages all JupiterOne email templates for customer communications
- **Visibility**: Private internal repository
- **Business Impact**: Essential for customer communications but not a technical dependency

### Projects Using This Repository
- No direct code dependencies found
- Referenced in configuration files:
  - [ci-tools](https://github.com/jupiterone/ci-tools) - CI/CD test fixtures
  - [peril](https://github.com/jupiterone/peril) - Repository automation
  - [ops-platform-jobs](https://github.com/jupiterone/ops-platform-jobs) - Automated maintenance

### Last Updated
- **May 28, 2024** - Repository ownership update
- Recent updates focus on email content improvements:
  - March 2024: Updated user invitation wording
  - February 2024: Updated group invitation text

---

## 3. html-pdf-service

### Overview
A specialized service that converts HTML to PDF using Playwright with a deferred request/response flow through S3.

### Criticality: **MODERATE**
- **Purpose**: PDF generation from HTML content for reports
- **Tier**: Classified as Tier-4 (lower priority auxiliary service)
- **Business Impact**: Deployed for specific customer needs (HSBC production)

### Projects Using This Repository
- No direct code imports found
- Infrastructure references:
  - [provision-environment](https://github.com/jupiterone/provision-environment) - HSBC production S3 buckets:
    - `jupiterone-prod-hsbc-html-pdf-service-pdfs`
    - `jupiterone-prod-hsbc-html-pdf-service-deferred-responses`
  - [ops-platform-jobs](https://github.com/jupiterone/ops-platform-jobs) - Automated maintenance tasks

### Last Updated
- **May 23, 2024** - Repository owner update
- **December 18, 2023** - Last functional update (deployment fix)
- In stable maintenance-only state

---

## 4. web-runtime-parcel-template

### Overview
A GitHub template repository for creating runtime UI parcels within JupiterOne's microfrontend architecture.

### Criticality: **LOW-MODERATE**
- **Purpose**: Template for sharing UI components as runtime parcels across JupiterOne web applications
- **Visibility**: Private internal template repository
- **Business Impact**: Infrastructure tooling with minimal direct usage

### Projects Using This Repository
- **web-searchbar** - Only confirmed project created from this template (created October 25, 2022)
- Referenced in infrastructure repositories:
  - [ops-platform-jobs](https://github.com/jupiterone/ops-platform-jobs) - Mass repository update configurations
  - [ci-tools](https://github.com/jupiterone/ci-tools) - Test files and deployment snapshots

### Last Updated
- **May 28, 2024** - Repository ownership update
- Mostly automated dependency updates via multi-gitter
- No significant feature development since creation

---

## 5. web-runtime-utility-template

### Overview
A GitHub template repository for creating runtime utility modules for JupiterOne's web applications.

### Criticality: **LOW-MODERATE**
- **Purpose**: Standardizes creation of runtime utility modules
- **Visibility**: Private internal template repository
- **Business Impact**: Supporting tool for frontend infrastructure

### Projects Using This Repository
- **No direct usage found** - No repositories appear to be using this template
- Referenced in infrastructure repositories:
  - [ops-platform-jobs](https://github.com/jupiterone/ops-platform-jobs) - Listed in mass repository job configurations
  - [ci-tools](https://github.com/jupiterone/ci-tools) - Used as test case for CI/CD tooling

### Last Updated
- **May 23, 2024** - Repository ownership update
- Recent activity includes vulnerability fixes and package bumps
- Maintained through automated updates only

---

## Key Findings

1. **Dependency Patterns**: 
   - security-policy-templates has the widest integration across JupiterOne services
   - email-template-generator and html-pdf-service operate as standalone services
   - Template repositories (web-runtime-*) have minimal to no direct usage

2. **Maintenance Status**:
   - All five repositories show maintenance activity within the last 6-8 months
   - Updates are primarily configuration/maintenance rather than feature development
   - Template repositories receive only automated updates
   - This pattern suggests mature, stable services and infrastructure

3. **Business Impact**:
   - security-policy-templates is critical to core platform functionality
   - email-template-generator is essential for customer communications
   - html-pdf-service serves specific customer requirements
   - Template repositories provide standardization but have limited adoption

4. **Template Repository Insights**:
   - Both web-runtime templates were created in late 2022
   - Limited adoption suggests either niche use cases or alternative approaches being preferred
   - Still maintained but not actively developed

5. **Recommendations**:
   - Monitor the open PR for FedRAMP v5 in security-policy-templates
   - Consider dependency updates for repositories with old open issues
   - Evaluate whether the template repositories are achieving their intended purpose given low adoption
   - Document the relationship between these services for better understanding of the platform architecture