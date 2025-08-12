# JupiterOne Lambda Functions Analysis

## Executive Summary

This analysis examines seven Lambda functions within the JupiterOne platform to understand their usage, criticality, and integration patterns. These functions primarily support authentication, authorization, and compliance services, forming critical components of JupiterOne's security infrastructure.

---

## 1. invitation-service-deleter

### Overview
A Lambda function responsible for cleaning up invitation service data.

### Location & Usage
- **Primary Repository**: [JupiterOne/iam](https://github.com/jupiterone/iam)
- **Definition**: `deploy/terraform/iam.tf`
- **Related Infrastructure**: DynamoDB table `invitation-service-invitations`

### Purpose & Criticality
- **Purpose**: Handles deletion and cleanup of expired or processed invitations
- **Criticality**: **MEDIUM** - Important for data hygiene but not user-facing
- **Impact**: Prevents accumulation of stale invitation data

### Integration Points
- Works with IAM service infrastructure
- Manages invitation lifecycle in conjunction with the invitation service

---

## 2. jupiter-endpoint-compliance-service

### Overview
A compliance checking service for endpoints within the JupiterOne platform.

### Location & Usage
- **Referenced In**:
  - [JupiterOne/web-powerups](https://github.com/jupiterone/web-powerups)
  - [JupiterOne/ops-platform-jobs](https://github.com/jupiterone/ops-platform-jobs)
  - [JupiterOne/peril](https://github.com/jupiterone/peril) - Test fixtures

### Purpose & Criticality
- **Purpose**: Validates endpoint compliance with security policies
- **Criticality**: **HIGH** - Core security/compliance functionality
- **Impact**: Ensures endpoints meet security requirements

### Integration Points
- Referenced in terraform configurations
- Used by operational scripts for compliance validation
- Integrated with PowerUps (custom actions/automations)

---

## 3. access-token-validator

### Overview
Critical authentication component that validates access tokens for API requests.

### Location & Usage
- **Primary Repository**: [JupiterOne/graphql-proxy-service](https://github.com/jupiterone/graphql-proxy-service)
- **Definition**: `packages/graphql-proxy-service/deploy/terraform/variables.tf`
- **Role**: Listed as invokable Lambda function by GraphQL proxy service

### Purpose & Criticality
- **Purpose**: Validates JWT tokens and API access credentials
- **Criticality**: **VERY HIGH** - Core authentication infrastructure
- **Impact**: Gatekeeps all API access to the platform

### Integration Points
- Invoked by graphql-proxy-service for every authenticated request
- Part of the API gateway authentication flow
- Critical dependency for all authenticated services

---

## 4. Cognito Authentication Triggers

### Overview
A set of three Lambda functions that implement custom authentication flows in AWS Cognito.

### Functions
1. **define_auth_challenge_trigger**
   - Defines which authentication challenges to present
   - Determines authentication flow based on user state

2. **create_auth_challenge_trigger**
   - Generates authentication challenges (e.g., MFA codes)
   - Creates custom challenge parameters

3. **verify_auth_challenge_response_trigger**
   - Validates user responses to authentication challenges
   - Determines if authentication is successful

### Location & Usage
- **Primary Repositories**: 
  - [JupiterOne/provision-cognito](https://github.com/jupiterone/provision-cognito)
  - [JupiterOne/orchestrate-environment-deployment](https://github.com/jupiterone/orchestrate-environment-deployment)
- **Definition**: `deploy/terraform/lambda.tf`

### Purpose & Criticality
- **Purpose**: Implements custom authentication logic including MFA and passwordless flows
- **Criticality**: **VERY HIGH** - Core authentication infrastructure
- **Impact**: Handles all user authentication for the platform

### Integration Points
- Integrated with AWS Cognito User Pools
- Works in conjunction with login service
- Critical for all user authentication flows

---

## 5. auth-service

### Overview
No specific Lambda function named "auth-service" was found. Authentication functionality is distributed across multiple services.

### Related Authentication Components
- **Cognito Lambda triggers** (detailed above)
- **Login service** ([JupiterOne/login](https://github.com/jupiterone/login))
- **IAM service components** ([JupiterOne/iam](https://github.com/jupiterone/iam))
- **Access control provisioning** ([JupiterOne/provision-access-control](https://github.com/jupiterone/provision-access-control))

---

## Key Architectural Insights

### 1. **Authentication Architecture**
- Built on AWS Cognito with custom Lambda triggers
- Supports multiple authentication methods (MFA, passwordless)
- Centralized token validation through access-token-validator

### 2. **Service Integration Patterns**
- GraphQL proxy service acts as central gateway
- Lambda functions invoked via API Gateway and direct service calls
- Clear separation between authentication, authorization, and business logic

### 3. **Infrastructure as Code**
- All Lambda functions deployed via Terraform
- Configuration spread across domain-specific repositories
- Consistent deployment patterns across services

### 4. **Security Criticality Hierarchy**
1. **Very High**: Authentication triggers, access-token-validator
2. **High**: jupiter-endpoint-compliance-service
3. **Medium**: invitation-service-deleter

### 5. **Repository Organization**
- **Authentication**: provision-cognito, login
- **Authorization**: iam, provision-access-control
- **API Gateway**: graphql-proxy-service
- **Infrastructure**: orchestrate-environment-deployment

---

## Recommendations

1. **Documentation**: Create centralized documentation for authentication flow across all Lambda functions
2. **Monitoring**: Ensure critical Lambda functions (auth triggers, token validator) have comprehensive monitoring
3. **Testing**: Implement integration tests that cover the full authentication flow
4. **Security**: Regular security audits of authentication Lambda functions
5. **Performance**: Monitor Lambda cold starts for authentication functions to ensure good user experience