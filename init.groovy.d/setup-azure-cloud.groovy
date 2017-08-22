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
final String cloudName                      = 'Azure'
final String githubUser                     = System.env.get('GITHUB_USER') ?: 'max-the-code-monkey'
final String resourceGroup                  = "azureagents-for-codevalet"
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


Jenkins.instance.clouds.clear()
def cloud = Jenkins.instance.clouds.find { it.name == cloudName }

/* Avoid adding the AzureVMCloud over and over and over again */
if (cloud == null) {
    cloud = new AzureVMCloud(cloudName,         /* Cloud Name */
                                /* Azure Credentials Id */
                                AzureCredentials.getServicePrincipal(credentialsId),
                                credentialsId,      /* credentials id */
                                maxAgents,          /* Max Agents */
                                '1200',             /* Deployment Timeout (s) */
                                'existing',              /* Resource group reference type */
                                null,      /* New resource group name */
                                resourceGroup,                 /* Existing resource group name */
                                null)        /* VM Templates */
    Jenkins.instance.clouds.add(cloud)
}


/* Nuke all our templates */
cloud.clearVmTemplates()
final String labels = 'docker linux ubuntu'
final String agentWorkspace = '/home/azureuser/workspace'
final String retentionTime = '10'

def imageReference = new AzureVMAgentTemplate.ImageReferenceTypeClass(
    'https://codevaletvhds.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.1988366a-5fa8-43de-8af1-f33158e2f352.vhd',
    '',
    '',
    '',
    '')

/* Add templates */
def t = new AzureVMAgentTemplate('ubuntu-1604-docker', /* template name */
                                 'Azure-based Ubuntu 16.04 machine', /* description */
                                 labels, /* labels */
                                 'East US 2', /* location */
                                 'Standard_DS4_v2', /* VM Size */
                                 '', /* Storage account Name reference type */
                                 'Standard_LRS', /* Storage account type */
                                 '', /* new storage account name */
                                 'codevaletvhds', /* existing storage account name */
                                 'unmanaged', /* disk type */
                                 '1', /* number of executors */
                                 'NORMAL', /* Usage mode */
                                 '', /* built-in image */
                                 false, /* install git */
                                 false, /* install maven */
                                 false, /* install docker */
                                 'Linux', /* OS type */
                                 'custom', /* image top level type */
                                 true, /* image reference? */
                                 imageReference, /* image reference class */
                                 'SSH', /* agent launch method */
                                 false, /* pre install SSH */
                                 'usermod -aG docker azureuser', /* init script */
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
t.azureCloud = cloud
println t.verifyTemplate()
cloud.addVmTemplate(t)
