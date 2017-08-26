#!/usr/bin/env groovy 

/* Configure the Datadog plugin for this instance */

import jenkins.model.*
import org.datadog.jenkins.plugins.datadog.DatadogBuildListener

def dog = Jenkins.instance.getDescriptor('org.datadog.jenkins.plugins.datadog.DatadogBuildListener')

if (System.env.get('GITHUB_USER')) {
    dog.hostname = "${System.env.get('GITHUB_USER')}.codevalet.io"
}

dog.tagNode = true
dog.apiKey = System.env.get('DATADOG_API_KEY') ?: 'dummy-datadog-api-key'

dog.save()
