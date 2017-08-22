#!/usr/bin/env groovy
/*
 * This file will annotate all loggers in the system witha Sentry Handler to
 * make sure that important errors are getting surfaced off the instance
 */

import io.sentry.jul.SentryHandler
import java.util.logging.*

SentryHandler sentry = new SentryHandler()
/* Default everything to the warning level, no need for INFO */
sentry.level = Level.WARNING

Thread.start {
    println 'Waiting for 2 minutes for Jenkins to bootstrap before configuring Sentry'
    sleep 120
    while (true) {
        LogManager.logManager.loggerNames.toList().each { loggerName ->
            def manager = LogManager.logManager.getLogger(loggerName)

            boolean found = false
            manager.handlers.each { handler ->
                if (handler.class == SentryHandler) {
                    found = true
                }
            }

            if (!found) {
                println "Adding Sentry to ${loggerName}"
                manager.addHandler(sentry)
            }
        }
        /* Sleep for five minutes in this thread, to make sure we are always
         * adding Sentry to new loggers should they appear
         */
        sleep 500
    }
}
