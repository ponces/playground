#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

tee $TMPDIR/checkKB.py >/dev/null << 'EOF'
import requests
import sys
import xml.etree.ElementTree as ET
from cryptography import x509

'''
Usage: checkKB.py keybox.xml
Checks the EC and RSA certificates against the official CRL
Example output:
  EC Cert SN: 43cf4aa6e5d9744dd436d9d5ef1391cd
  RSA Cert SN: ad3b740cccc9369f89240dbc5284cb10
  Keybox is revoked!
'''

crl = requests.get('https://android.googleapis.com/attestation/status', headers={'Cache-Control':'max-age=0'}).json()

certs = [elem.text for elem in ET.parse(sys.argv[1]).getroot().iter() if elem.tag == 'Certificate']

def parse_cert(cert):
    cert = "\n".join(line.strip() for line in cert.strip().split("\n"))
    parsed = x509.load_pem_x509_certificate(cert.encode())
    return f'{parsed.serial_number:x}'

ec_cert_sn, rsa_cert_sn = parse_cert(certs[0]), parse_cert(certs[3])

print(f'\nEC Cert SN: {ec_cert_sn}\nRSA Cert SN: {rsa_cert_sn}')

if any(sn in crl["entries"].keys() for sn in (ec_cert_sn, rsa_cert_sn)):
    print('\nKeybox is revoked!')
else:
    print('\nKeybox is still valid!')
EOF

keybox="$1"

if [ ! -f "$keybox" ]; then
    keybox="$TMPDIR/keybox.xml"
    if [[ "$1" == "http"* ]]; then
        curl -sfL "$1" -o "$keybox"
    else
        echo "$1" > "$keybox"
    fi
fi

if [ ! -f "$keybox" ] || [ ! -s "$keybox" ]; then
    echo "Keybox empty or not found. Exiting..."
    rm -f $TMPDIR/keybox.xml
fi

python $TMPDIR/checkKB.py "$keybox"
rm -f $TMPDIR/checkKB.py
rm -f $TMPDIR/keybox.xml
