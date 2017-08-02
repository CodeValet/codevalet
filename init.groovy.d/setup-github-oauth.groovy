#!/usr/bin/env groovy
/*
 * Set up the basic GitHub OAuth permissions for this instance
 */

import jenkins.model.*
import org.jenkinsci.plugins.GithubAuthorizationStrategy
import org.jenkinsci.plugins.GithubSecurityRealm

/*
  <securityRealm class="org.jenkinsci.plugins.GithubSecurityRealm">
    <githubWebUri>https://github.com</githubWebUri>
    <githubApiUri>https://api.github.com</githubApiUri>
    <clientID>f19661554c93f3b11cfe</clientID>
    <clientSecret>{AQAAABAAAAAwDYrTDXUKoO3rGPSKsA0n3hZA8YcEXPhz/CpGq3jRzpAfSvwl4oilxDL5PUQA12gCcpAyvV58fP+E9UC3pPsnNw==}</clientSecret>
    <oauthScopes>read:org,user:email</oauthScopes>
  </securityRealm>
*/

/* http://javadoc.jenkins.io/plugin/github-oauth/org/jenkinsci/plugins/GithubAuthorizationStrategy.html */
def authorization = new GithubAuthorizationStrategy("rtyler", /* Administrator usernames */
                                                    true,     /* Authenticated users can READ */
                                                    true,     /* Use the repository's permissions */
                                                    false,    /* Authenticated user's can CREATE */
                                                    System.env.get('GITHUB_USER'), /* Collaborators */
                                                    true,     /* Allow /github-webhook */
                                                    false,    /* All cctray's READ */
                                                    true,     /* Allow anonymous READ */
                                                    true      /* Allow anonymous VIEW_STATUS */
                                                    )

def realm = new GithubSecurityRealm('https://github.com',           /* GitHub web URI */
                                    'https://api.github.com',       /* GitHub API URI */
                                    System.env.get('CLIENT_ID') ?: 'f19661554c93f3b11cfe',         /* OAuth Client ID */
                                    System.env.get('CLIENT_SECRET') ?: '0672e14addb9f41dec11b5da1219017edfc82a58',/* OAuth Client Secret */
                                    'read:public_repo,user:email'           /* OAuth permission scopes */
                                    )
Jenkins.instance.authorizationStrategy = authorization
Jenkins.instance.securityRealm = realm

