#!/usr/bin/env groovy
/*
 * Pre-configure the Git plugin and the default git tooling in Jenkins
 */
import org.jenkinsci.plugins.gitclient.*
import jenkins.model.Jenkins

def gitConfig = Jenkins.instance.getDescriptor('hudson.plugins.git.GitSCM')
def tools = Jenkins.instance.getDescriptor('hudson.plugins.git.GitTool')

tools.setInstallations(new JGitTool()

gitConfig.globalConfigName = 'max'
gitConfig.globalConfigEmail = 'max@example.com'
