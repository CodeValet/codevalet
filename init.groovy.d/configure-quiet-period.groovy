#!/usr/bin/env groovy
/*
 * Set the global quiet period to zero to avoid any delays in provisioning
 * infrastructure or executing Pipelines
 */

import jenkins.model.Jenkins

Jenkins.instance.quietPeriod = 0
