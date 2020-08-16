FROM tomcat:7-jre8
#set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Install openmrs.war and refapp addons
RUN mkdir -p /usr/local/tomcat/.OpenMRS \
    && wget -q https://dl.bintray.com/safehands/openmrscore/openmrs.war -O /usr/local/tomcat/webapps/openmrs.war \
    && wget -q https://dl.bintray.com/safehands/referenceapps/referenceapplication-package-2.10.0-SNAPSHOT-addons.zip -O /tmp/refapp-addons.zip \
    && unzip -d /tmp/ /tmp/refapp-addons.zip \
    && cp -r /tmp/referenceapplication-package-2.10.0-SNAPSHOT /usr/local/tomcat/.OpenMRS/ \
    && rm /tmp/refapp-addons.zip \
    && rm -rf /tmp/referenceapplication-package-2.10.0-SNAPSHOT/ 

COPY startup.sh /usr/local/tomcat/startup.sh
COPY setenv.sh /usr/local/tomcat/bin/setenv.sh

ENTRYPOINT [ "/usr/local/tomcat/startup.sh" ]
