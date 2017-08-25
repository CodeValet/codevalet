#!/usr/bin/env groovy
/*
 * Pre-configure the Git plugin and the default git tooling in Jenkins
 */
import org.jenkinsci.plugins.gitclient.*
import hudson.plugins.git.*
import jenkins.model.Jenkins

def gitConfig = Jenkins.instance.getDescriptor('hudson.plugins.git.GitSCM')
def tools = Jenkins.instance.getDescriptor('hudson.plugins.git.GitTool')

GitTool[] gitTools = new GitTool[1]
gitTools[0] = new JGitTool()

tools.installations = gitTools
tools.save()

gitConfig.globalConfigName = 'max'
gitConfig.globalConfigEmail = 'max@example.com'
