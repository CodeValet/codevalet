#!/usr/bin/env groovy
/*
 * Set up the CSRF protection which would normally be defaulted in 2.0 , but
 * are not in our instances because we're * skipping the setup wizard
 */

import jenkins.model.*
import hudson.security.csrf.*

println "Checking CSRF protection..."
if (Jenkins.instance.crumbIssuer == null) {
  println "Enabling CSRF protection"
  Jenkins.instance.crumbIssuer = new DefaultCrumbIssuer(true)
}
