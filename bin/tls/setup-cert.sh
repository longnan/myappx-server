#!/bin/sh

certdir="tls"

# create certdir
mkdir $certdir

# setup a CA key
if [ ! -f "$certdir/myappx-ca-key.pem" ]; then
  openssl genrsa -out "${certdir}/myappx-ca-key.pem" 2048
fi

# setup a CA cert
openssl req -new -x509 -days 3650 \
  -subj "/C=CN/ST=China/L=Shanghai/O=MyAppx/OU=MyAppx/CN=MyAppx CA" \
  -key "${certdir}/myappx-ca-key.pem" \
  -sha256 -out "${certdir}/myappx-ca.pem"

# setup a host key
if [ ! -f "${certdir}/myappx-server-key.pem" ]; then
  openssl genrsa -out "${certdir}/myappx-server-key.pem" 2048
fi

# create a signing request (host server key)
extfile="${certdir}/extfile"
openssl req -new -key "${certdir}/myappx-server-key.pem" \
   -subj "/C=CN/ST=China/L=Shanghai/O=MyAppxServer/OU=MyAppxServer/CN=MyAppxServer CA" \
   -out "${certdir}/myappx-server.csr"
echo "subjectAltName = IP.1:127.0.0.1" >${extfile}

# create a host cert
openssl x509 -req -days 3650 \
   -in "${certdir}/myappx-server.csr" -extfile "${certdir}/extfile" \
   -CA "${certdir}/myappx-ca.pem" -CAkey "${certdir}/myappx-ca-key.pem" -CAcreateserial \
   -out "${certdir}/myappx-server-cert.pem"

# create client key and certificate
openssl genrsa -out "${certdir}/myappx-client-key.pem" 2048
openssl req -new -key "${certdir}/myappx-client-key.pem" -out "${certdir}/myappx-client.csr" -subj "/C=CN/ST=China/L=Shanghai/O=MyAppxClient/OU=MyAppxClient/CN=MyAppxClient CA"
openssl x509 -req -in "${certdir}/myappx-client.csr" -CA "${certdir}/myappx-ca.pem" -CAkey "${certdir}/myappx-ca-key.pem" -CAcreateserial -out "${certdir}/myappx-client.crt" -days 365

# generate client.p12 file which can be easily imported to OS.
openssl pkcs12 -export -inkey "${certdir}/myappx-client-key.pem" -in "${certdir}/myappx-client.crt" -certfile "${certdir}/myappx-ca.pem" -out "${certdir}/myappx-client.p12"

# cleanup
if [ -f "${certdir}/myappx-server.csr" ]; then
        rm -f -- "${certdir}/myappx-server.csr"
fi
if [ -f "${certdir}/myappx-client.csr" ]; then
        rm -f -- "${certdir}/myappx-client.csr"
fi
if [ -f "${extfile}" ]; then
        rm -f -- "${extfile}"
fi
