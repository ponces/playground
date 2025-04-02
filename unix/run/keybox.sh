#!/bin/bash

set -e

keybox="$1"

if [ ! -f "$keybox" ]; then
    keybox="/tmp/keybox.xml"
    if [[ "$1" == "http"* ]]; then
        curl -sfL "$1" -o "$keybox"
    else
        echo "$1" > "$keybox"
    fi
fi

if [ ! -f "$keybox" ] || [ ! -s "$keybox" ]; then
    echo "Keybox empty or not found. Exiting..."
    rm -f /tmp/keybox.xml
    exit 1
fi

extractPriKey() {
    xmlstarlet sel -t -m "//Key[@algorithm=\"$1\"]" -v "PrivateKey" "$keybox" | sed 's/^[[:space:]]*//' > /tmp/prikey
    openssl pkcs8 -topk8 -nocrypt -in /tmp/prikey | grep -v "PRIVATE KEY" | sed ':a;N;$!ba;s/\n//g'
    rm -f /tmp/prikey
}

extractCert() {
    xmlstarlet sel -t -m "//Key[@algorithm=\"$1\"]/CertificateChain" -v "Certificate[$2]" "$keybox" | grep -v "CERTIFICATE" | sed 's/^[[:space:]]*//' | sed ':a;N;$!ba;s/\n//g'
}

echo "+    private static final class Keybox {"
echo "+        public static final class EC {"
echo "+            public static final String PRIVATE_KEY = \"$(extractPriKey 'ecdsa')\";"
echo "+            public static final String CERTIFICATE_1 = \"$(extractCert 'ecdsa' '1')\";"
echo "+            public static final String CERTIFICATE_2 = \"$(extractCert 'ecdsa' '2')\";"
echo "+            public static final String CERTIFICATE_3 = \"$(extractCert 'ecdsa' '3')\";"
echo "+            public static final String CERTIFICATE_4 = \"$(extractCert 'ecdsa' '4')\";"
echo "+        }"
echo "+        public static final class RSA {"
echo "+            public static final String PRIVATE_KEY = \"$(extractPriKey 'rsa')\";"
echo "+            public static final String CERTIFICATE_1 = \"$(extractCert 'rsa' '1')\";"
echo "+            public static final String CERTIFICATE_2 = \"$(extractCert 'rsa' '2')\";"
echo "+            public static final String CERTIFICATE_3 = \"$(extractCert 'rsa' '3')\";"
echo "+            public static final String CERTIFICATE_4 = \"$(extractCert 'rsa' '4')\";"
echo "+        }"
echo "+    }"

rm -f /tmp/keybox.xml
