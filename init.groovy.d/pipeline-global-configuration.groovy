#!/usr/bin/env groovy

/*
 * This file is responsible for setting Global Pipeline configurations to the
 * sensible defaults which are necessary
 */

import jenkins.model.GlobalConfiguration
import org.jenkinsci.plugins.pipeline.modeldefinition.config.GlobalConfig


/* Set the default Docker label for Declarative Pipeline to .. wait for it .. docker */
GlobalConfig c = GlobalConfiguration.all().find { it instanceof GlobalConfig }
c?.dockerLabel = 'docker'
