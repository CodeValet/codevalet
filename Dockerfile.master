FROM nginx:alpine
USER root

# Prepare the alpine image with some Jenkins dependencies
################################################################################
RUN apk add --no-cache git \
        openssh-client \
        curl \
        unzip \
        bash \
        ttf-dejavu \
        coreutils \
        supervisor \
        openjdk8-jre && \
            mkdir -p /usr/share/jenkins && \
            curl -sSL https://ci.jenkins.io/job/Core/job/jenkins/job/master/lastSuccessfulBuild/artifact/war/target/linux-jenkins.war  > /usr/share/jenkins/jenkins.war
################################################################################


# Snippet taken from Dockerfile.alpine
################################################################################
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.14.0
ENV TINI_SHA 6c41ec7d33e857d4779f14d9c74924cab0c7973485d2972419a3b7c7620ff5fd

# Use tini as subreaper in Docker container to adopt zombie processes
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c -

ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached agents:
EXPOSE ${agent_port}
################################################################################


# Grab the latest jenkins.sh from the Jenkins on Docker project
RUN curl -fsSL https://github.com/jenkinsci/docker/raw/master/jenkins.sh > /usr/local/bin/jenkins.sh && \
        chmod +x /usr/local/bin/jenkins.sh
RUN curl -fsSL https://github.com/jenkinsci/docker/raw/master/jenkins-support > /usr/local/bin/jenkins-support


# Ensure that all our plugins are bundled properly, along with Groovy bootstrap
# scripts and other build-related content.
################################################################################
ADD build/plugins/*.hpi /usr/share/jenkins/ref/plugins/
RUN for f in /usr/share/jenkins/ref/plugins/*.hpi; do mv  $f $f.override ; done
ADD init.groovy.d/*.groovy /usr/share/jenkins/ref/init.groovy.d/
# Link all our files with .override as the suffix to ensure copy_reference_file
# overrides any existing versions on the persistent volume. Basically, we
# always want the init.groovy.d/ in the container to win.
RUN for f in /usr/share/jenkins/ref/init.groovy.d/*.groovy; do mv $f $f.override ; done

RUN mkdir /usr/share/jenkins/ref/userContent
RUN date > /usr/share/jenkins/ref/userContent/builtOn.txt
ADD build/git-refs.txt /usr/share/jenkins/ref/userContent
RUN for f in /usr/share/jenkins/ref/userContent/*.txt; do mv $f $f.override ; done
################################################################################


# Prepare the nginx instance itself
################################################################################
COPY nginx.master.conf /etc/nginx/conf.d/default.conf
################################################################################

# Prepare the supervisor script to run nginx and Jenkins inside the container
################################################################################
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
################################################################################
