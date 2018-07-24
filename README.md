# bc-fips-hardening

Install RHEL 7 with Java 8
OpenJDK 1.8.0 enables unlimited encryption policy for JRE by default on RHEL 7

Copy BC FIPS jars to $JAVA_HOME/lib/ext, as root:

    export JAVA_HOME=$(java -XshowSettings:properties -version |& \
        grep java.home | awk '{print $3}')
    cd ~/bc-fips/jars
    cp bc-fips-1.0.1.jar bctls-fips-1.0.5.jar $JAVA_HOME/lib/ext
    restorecon -vFr $JAVA_HOME/lib/ext

Create the java.security.properties file:

    ./create-java-security-overrides.sh

