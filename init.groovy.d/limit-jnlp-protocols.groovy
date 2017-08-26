#!/usr/bin/env groovy
/*
 * Restrict the JNLP protocols to only those which should be enabled (modern
 * and secure ones)
 */

import jenkins.model.*
import org.kohsuke.stapler.StaplerProxy
import jenkins.security.s2m.AdminWhitelistRule

Jenkins.instance.agentProtocols = ['JNLP4-connect', 'Ping']
Jenkins.instance.save()

Jenkins.instance.getExtensionList(StaplerProxy).get(AdminWhitelistRule).masterKillSwitch = false
