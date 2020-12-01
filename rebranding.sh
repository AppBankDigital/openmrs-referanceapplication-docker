#!/bin/bash
unzip openmrs.war -d ./openmrs
unzip ./openmrs/WEB-INF/bundledModules/referencemetadata-2.11.0-SNAPSHOT.omod -d ./openmrs/WEB-INF/bundledModules/referencemetadata-2.11.0-SNAPSHOT
rm ./openmrs/WEB-INF/bundledModules/referenceapplication-2.11.0-SNAPSHOT/web/module/resources/images/openMrsLogo.png
cp ./brandlogo ./openmrs/WEB-INF/bundledModules/referenceapplication-2.11.0-SNAPSHOT/web/module/resources/images/openMrsLogo.png
jar -cvf ./openmrs/WEB-INF/bundledModules/referenceapplication-2.11.0-SNAPSHOT.jar ./openmrs/WEB-INF/bundledModules/referenceapplication-2.11.0-SNAPSHOT/*


