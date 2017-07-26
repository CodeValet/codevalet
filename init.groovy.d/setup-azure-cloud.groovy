#!/usr/bin/env groovy

/*
 * Set up the Azure VM Cloud plugin
 */

import jenkins.model.*
import com.microsoft.azure.vmagent.*
import com.microsoft.azure.util.*

import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.Domain

final String maxAgents = '1'

List<AzureVMAgentTemplate> vmTemplates = []
final String githubUser     = System.env.get('GITHUB_USER') ?: 'max-the-code-monkey'
final String resourceGroup  = "azureagents-for-${githubUser}"
final String credentialsId  = 'azure-agents-credential'
final String tenantId       = System.env.get('TENANT_ID') ?: 'dummy-tenant-id'
final String subscriptionId = System.env.get('SUBSCRIPTION_ID') ?: 'dummy-subscription-id'
final String clientId       = System.env.get('CLIENT_ID') ?: 'dummy-client-id'
final String clientSecret   = System.env.get('CLIENT_SECRET') ?: 'dummy-secret'

AzureCredentials.ServicePrincipal principle = AzureCredentials.getServicePrincipal(credentialsId)

/* If the credentials hasn't already been defined, let's create one! */
if (principle.isBlank()) {
    CredentialsScope scope = CredentialsScope.valueOf('SYSTEM')
    AzureCredentials credential = new AzureCredentials(scope,         /* Scope for the credential */
                                      credentialsId, /* */
                                      'Azure credentials for provisioning agent', /* description */
                                      subscriptionId,           /* subscriptionId */
                                      clientId,                /* clientId */
                                      clientSecret ,           /* clientSecret */
                                      /* oauth2 Token endpoint */
                                      "https://login.windows.net/${tenantId}",
                                      /* service management url */
                                      AzureCredentials.Constants.DEFAULT_MANAGEMENT_URL,
                                      /* authentication endpoint */
                                      AzureCredentials.Constants.DEFAULT_AUTHENTICATION_ENDPOINT,
                                      /* resource manager endpoint */
                                      AzureCredentials.Constants.DEFAULT_RESOURCE_MANAGER_ENDPOINT,
                                      /* graph endpoint */
                                      AzureCredentials.Constants.DEFAULT_GRAPH_ENDPOINT)

    SystemCredentialsProvider.instance.store.addCredentials(Domain.global(), credential)
}


def cloud = new AzureVMCloud('Azure',            /* Cloud Name */
                             /* Azure Credentials Id */
                             AzureCredentials.getServicePrincipal(credentialsId),
                             credentialsId,      /* credentials id */
                             maxAgents,          /* Max Agents */
                             '1200',             /* Deployment Timeout (s) */
                             'new',              /* Resource group reference type */
                             resourceGroup,      /* New resource group name */
                             '',                 /* Existing resource group name */
                             vmTemplates)        /* VM Templates */
Jenkins.instance.clouds.add(cloud)
