#
# Dockerfile of MyAppx-Server
#
FROM phusion/baseimage:noble-1.0.2

ENV MYAPPXSERVER_DOCKER_VERSION=20260111

# Default locale
RUN locale-gen en_US.UTF-8 && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale

# Setup fast apt in China
RUN echo "deb https://mirrors.huaweicloud.com/ubuntu/ noble main restricted universe multiverse \n" \
		"deb https://mirrors.huaweicloud.com/ubuntu/ noble-security main restricted universe multiverse \n" \
	    "deb https://mirrors.huaweicloud.com/ubuntu/ noble-updates main restricted universe multiverse \n" \
		"deb https://mirrors.huaweicloud.com/ubuntu/ noble-proposed main restricted universe multiverse \n" \
        "deb https://mirrors.huaweicloud.com/ubuntu/ noble-backports main restricted universe multiverse " > /etc/apt/sources.list
		
# Install unzip and other useful packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nano wget unzip pwgen expect sudo libfontconfig postgresql-client

# Add app stuff into Container
COPY app /tmp/app

# Setup Openjdk (offline mode)
## https://adoptium.net/en-GB/temurin/releases
ENV JVM_DIR=/usr/lib/jvm
ENV OPENJDK_FILE=OpenJDK21U-jdk_x64_linux_hotspot_21.0.9_10.tar.gz
RUN mkdir ${JVM_DIR}
RUN tar xfvz /tmp/app/${OPENJDK_FILE} --directory ${JVM_DIR} 
ENV JAVA_HOME=${JVM_DIR}/jdk-21.0.9+10
ENV PATH=$PATH:$JAVA_HOME/bin

# Java version
RUN java -version

# Setup IDEMPIERE_HOME
ARG MYAPPX_TAG
ENV IDEMPIERE_HOME=/opt/myappxserver
ENV IDEMPIERE_FILE=myappxserver-${MYAPPX_TAG}-linux.gtk.x86_64.tar.gz
WORKDIR $IDEMPIERE_HOME

# Setup IDEMPIERE Package
RUN tar xfvz /tmp/app/${IDEMPIERE_FILE} --directory /opt
RUN rm /tmp/app/${IDEMPIERE_FILE}

# Setup Environment for idempiere-server
## Root Home
RUN mv /tmp/app/home.properties ${IDEMPIERE_HOME}/home.properties
RUN mv /tmp/app/myappxserver.sh ${IDEMPIERE_HOME}/myappxserver.sh
RUN mv /tmp/app/data/fonts ${IDEMPIERE_HOME}/data/
RUN mv /tmp/app/data/lang ${IDEMPIERE_HOME}/data/
## Docker Entrypoint
RUN mv /tmp/app/docker-entrypoint.sh $IDEMPIERE_HOME
## Local Storage of idempiere
RUN mkdir -p /opt/myappx-localstorage/
## Local Packin Folder of idempiere
RUN mkdir -p /opt/myappx-packin_data/

# Clean up
## Clean tmp/app
RUN rm -rf /tmp/app
## Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set +x for script
RUN chmod 755 ${IDEMPIERE_HOME}/idempiere
RUN chmod 755 ${IDEMPIERE_HOME}/*.sh
RUN chmod 755 ${IDEMPIERE_HOME}/utils/*.sh
RUN chmod 755 ${IDEMPIERE_HOME}/utils/postgresql/*.sh
RUN chmod 755 ${IDEMPIERE_HOME}/data/lang/*.sh

# Export Port
EXPOSE 8080 8443 4554

# Health Check
HEALTHCHECK --interval=5s --timeout=3s --retries=12 CMD curl --silent -fs http://localhost:8080/webui || exit 1

# Setup script for Entrypoint
RUN chmod +x ${IDEMPIERE_HOME}/myappxserver.sh
RUN ln -s $IDEMPIERE_HOME/myappxserver.sh /usr/bin/myappxserver

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["myappxserver"]
