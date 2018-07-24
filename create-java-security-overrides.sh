#!/bin/bash

. $(dirname $0)/demo.conf

tmpfile=$(mktemp /tmp/security.providers.list.XXXXXX)

PUSHD "$WORK_DIR"

JRE_HOME=$(java -XshowSettings:properties -version |& grep java.home | \
    awk '{print $3}')

cat > java.security.properties <<END1
#
# This file overrides the values in the java.security policy file.
# It can be found in:
#
#    JRE_HOME=$JRE_HOME
#    \$JRE_HOME/lib/security/java.security
#
security.provider.1=org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider
security.provider=2=org.bouncycastle.jsse.provider.BouncyCastleJsseProvider fips:BCFIPS
END1

JAVA_SECURITY_POLICY="$JRE_HOME/lib/security/java.security"

provnum=3
for prov in $(grep -E '^security.provider.[0-9]+=' $JAVA_SECURITY_POLICY | \
    cut -d= -f2 | grep -v com.sun.net.ssl.internal.ssl.Provider)
do
    echo security.provider.$provnum=$prov >> java.security.properties
    (( provnum = provnum + 1 ))
done

cat >> java.security.properties <<END2

# use /dev/urandom so threads don't block on low entropy
securerandom.source=file:/dev/urandom
securerandom.strongAlgorithms=DEFAULT:BCFIPS

END2
POPD

