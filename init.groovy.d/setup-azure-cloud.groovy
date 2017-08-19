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

final String maxAgents                      = '2'
final String githubUser                     = System.env.get('GITHUB_USER') ?: 'max-the-code-monkey'
final String resourceGroup                  = "azureagents-for-${githubUser}"
final String credentialsId                  = 'azure-agents-credential'
final String adminCredentialsId             = 'azure-agent-admin-credential'
final String tenantId                       = System.env.get('AZURE_TENANT_ID') ?: 'dummy-tenant-id'
final String subscriptionId                 = System.env.get('AZURE_SUBSCRIPTION_ID') ?: 'dummy-subscription-id'
final String clientId                       = System.env.get('AZURE_CLIENT_ID') ?: 'dummy-client-id'
final String clientSecret                   = System.env.get('AZURE_CLIENT_SECRET') ?: 'dummy-secret'
CredentialsScope scope                      = CredentialsScope.valueOf('SYSTEM')
AzureCredentials.ServicePrincipal principle = AzureCredentials.getServicePrincipal(credentialsId)
final String id                             = java.util.UUID.randomUUID().toString()
final Credentials c                         = new UsernamePasswordCredentialsImpl(scope,
                                                                                    adminCredentialsId,
                                                                                    adminCredentialsId,
                                                                                    'azureuser',
                                                                                    id)

SystemCredentialsProvider.instance.store.addCredentials(Domain.global(), c)

println ">> Credential: ${id}"

/* If the credentials hasn't already been defined, let's create one! */
if (principle.isBlank()) {
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
                             null)        /* VM Templates */
Jenkins.instance.clouds.add(cloud)



/* Nuke all our templates */
cloud.clearVmTemplates()
final String labels = 'docker linux ubuntu'
final String agentWorkspace = '/home/azureuser/workspace'
final String retentionTime = '10'

def imageReference = new AzureVMAgentTemplate.ImageReferenceTypeClass(
    'Ubuntu 16.04',
    'Canonical',
    'UbuntuServer',
    '16.04 LTS',
    'latest')

/* Add templates */
def t = new AzureVMAgentTemplate('ubuntu-1604-docker', /* template name */
                                 'Azure-based Ubuntu 16.04 machine', /* description */
                                 labels, /* labels */
                                 'East US', /* location */
                                 'Standard_A4', /* VM Size */
                                 'new', /* Storage account Name reference type */
                                 'Standard_LRS', /* Storage account type */
                                 '', /* new storage account name */
                                 '', /* existing storage account name */
                                 'unmanaged', /* disk tyep */
                                 '1', /* number of executors */
                                 'NORMAL', /* Usage mode */
                                 'Ubuntu 16.04 LTS', /* built-in image */
                                 true, /* install git */
                                 false, /* install maven */
                                 true, /* install docker */
                                 'Linux', /* OS type */
                                 'basic', /* image top level type */
                                 false, /* image reference? */
                                 imageReference, /* image reference class */
                                 'SSH', /* agent launch method */
                                 true, /* pre install SSH */
                                 '', /* init script */
                                 adminCredentialsId, /* admin credential Id */
                                 '', /* virtual network name */
                                 '', /* virtual network resource group name */
                                 '', /* subnet name */
                                 false, /* use private IP */
                                 '', /* Network security group name */
                                 agentWorkspace, /* agent workspace */
                                 '', /* JVM options */
                                 retentionTime, /* retention time */
                                 false, /* shutdown on idle */
                                 false, /* template disabled */
                                 '', /* template status details */
                                 true, /* execute init script as root */
                                 true /* do not use machine if init fails */
        )
cloud.addVmTemplate(t)
