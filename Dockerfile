FROM tomcat:7-jre8
#set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Install openmrs.war and refapp addons
RUN mkdir -p /usr/local/tomcat/.OpenMRS
COPY ./openmrs-2.11/openmrs.war /usr/local/tomcat/webapps/openmrs.war
COPY ./openmrs-2.11/referenceapplication-package-2.11.0-SNAPSHOT-addons.zip /tmp/refapp-addons.zip
RUN unzip -d /tmp/ /tmp/refapp-addons.zip \
    && cp -r /tmp/referenceapplication-package-2.11.0-SNAPSHOT /usr/local/tomcat/.OpenMRS/ \
    && rm /tmp/refapp-addons.zip \
    && rm -rf /tmp/referenceapplication-package-2.11.0-SNAPSHOT/
#Adding branding image
#ADD openMrsLogo.png /usr/local/tomcat/.OpenMRS/person_images/openMrsLogo.png
COPY startup.sh /usr/local/tomcat/startup.sh
COPY setenv.sh /usr/local/tomcat/bin/setenv.sh

ENTRYPOINT [ "/usr/local/tomcat/startup.sh" ]
