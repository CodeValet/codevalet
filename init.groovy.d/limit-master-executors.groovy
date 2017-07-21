#!/usr/bin/env groovy
/*
 * Make sure the number of executors available on the master is set to zero for
 * security purposes
 */

import jenkins.model.*
Jenkins.instance.setNumExecutors(0)
