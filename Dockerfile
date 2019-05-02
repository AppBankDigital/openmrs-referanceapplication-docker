FROM tomcat:7-jre8

# Install openmrs.war and refapp addons
RUN mkdir -p /usr/local/tomcat/.OpenMRS \
    && wget --quiet https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Reference_Application_2.9.0/openmrs.war/download -O /usr/local/tomcat/webapps/openmrs.war \
    && wget --quiet https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Reference_Application_2.9.0/referenceapplication-addons-2.9.0.zip/download -O /tmp/refapp-addons.zip \
    && unzip -d /tmp/ /tmp/refapp-addons.zip \
    && cp -r /tmp/referenceapplication-package-2.9.0/* /usr/local/tomcat/.OpenMRS/ \
    && rm /tmp/refapp-addons.zip \
    && rm -rf /tmp/referenceapplication-package-2.9.0/ 

COPY startup.sh /usr/local/tomcat/startup.sh
COPY setenv.sh /usr/local/tomcat/bin/setenv.sh

ENTRYPOINT [ "/usr/local/tomcat/startup.sh" ]
