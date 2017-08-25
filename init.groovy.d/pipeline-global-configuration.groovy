#!/usr/bin/env groovy

/*
 * This file is responsible for setting Global Pipeline configurations to the
 * sensible defaults which are necessary
 */


import jenkins.model.*
import jenkins.plugins.git.GitSCMSource
import org.jenkinsci.plugins.workflow.libs.*
import jenkins.model.GlobalConfiguration
import org.jenkinsci.plugins.pipeline.modeldefinition.config.GlobalConfig


/* Set the default Docker label for Declarative Pipeline to .. wait for it .. docker */
GlobalConfig c = GlobalConfiguration.all().find { it instanceof GlobalConfig }
c?.dockerLabel = 'docker'


/* Add our global library properly */
List<LibraryConfiguration> libs = []

['pipeline-library', 'inline-pipeline-secrets'].each {
  GitSCMSource source= new GitSCMSource(it, "https://github.com/codevalet/${it}.git",
                                        null, null, null, false)

  LibraryConfiguration lib = new LibraryConfiguration(it, new SCMSourceRetriever(source))
  lib.implicit = true
  lib.defaultVersion = 'master'
  libs.add (lib)
}

GlobalLibraries.get().libraries = libs
