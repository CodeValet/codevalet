#!/usr/bin/env groovy

/* Configure the instance's URL based on the GITHUB_USER */

import jenkins.model.*

if (System.env.get('GITHUB_USER')) {
    JenkinsLocationConfiguration.get().setUrl("https://codevalet.io/u/${System.env.get('GITHUB_USER')}/")
}
