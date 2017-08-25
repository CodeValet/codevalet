#!/usr/bin/env groovy
/*
 * Restrict the JNLP protocols to only those which should be enabled (modern
 * and secure ones)
 */

import jenkins.model.*

Jenkins.instance.agentProtocols = ['JNLP4-connect', 'Ping']
Jenkins.instance.save()
