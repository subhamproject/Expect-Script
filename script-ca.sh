#!/bin/bash

SSL_PATH="$(dirname $(realpath "$0"))/ssl"

function create_ca() {
openssl req -new -x509 -keyout $SSL_PATH/ca-key -out $SSL_PATH/ca-cert -days 3650
}

create_ca




#!/bin/bash

SSL_PATH="$(dirname $(realpath "$0"))/ssl"

function create_ca() {
openssl req -new -x509 -keyout $SSL_PATH/ca-key -out $SSL_PATH/ca-cert -days 3650
}

create_ca



rcxdev@rcxdev:~/expect-script-testing$ cat service
#!/bin/bash

SERVICE=$1
SSL_PATH="$(dirname $(realpath "$0"))/ssl"

function create() {
for I in "$@"
do
echo "Creating for this CN: $I"
openssl req -out $SSL_PATH/sha1.csr -new -newkey rsa:2048 -nodes -keyout  $SSL_PATH/sha1.key
openssl x509 -req -days 3650 -in  $SSL_PATH/sha1.csr -CA  $SSL_PATH/ca-cert -CAkey  $SSL_PATH/ca-key -CAcreateserial -out  $SSL_PATH/$I.crt -sha256
openssl rsa -aes256 -in  $SSL_PATH/sha1.key -out  $SSL_PATH/client.key
cat  $SSL_PATH/client.key  $SSL_PATH/$I.crt >   $SSL_PATH/$I.pem
openssl pkcs12 -export -out  $SSL_PATH/$I.p12 -in  $SSL_PATH/$I.crt -inkey  $SSL_PATH/client.key -passin pass:rcxdev -passout pass:rcxdev
keytool -importkeystore -srckeystore  $SSL_PATH/$I.p12 -srcstoretype pkcs12 -destkeystore  $SSL_PATH/$I.jks -deststoretype JKS
keytool -keystore  $SSL_PATH/$I.jks -alias CARoot -import -file  $SSL_PATH/ca-cert
keytool -changealias -alias "1" -destalias $I -keystore  $SSL_PATH/$I.jks
done
}

create $SERVICE






#!/bin/bash

PASS=password
COUNTRY=IND
STATE=TGA
LOCALITY=Hyderabad
ORG=Ryth
OUUNIT=DevSecOps
MAIL=devops@gmail.com
CCCN=dev.com
SSL_PATH="$(dirname $(realpath "$0"))/ssl"

[ ! -d $SSL_PATH ] && mkdir -p $SSL_PATH

[ -z $(which expect) ] && { echo "Please install expect tool using 'apt-get install expect' and try again" ; exit 1 ; }



function create_cacert() {
[ ! -f $SSL_PATH/ca-key ] && [ ! -f $SSL_PATH/ca-cert ] && $(dirname $(realpath "$0"))/auto_ca.exp $PASS $COUNTRY $STATE $LOCALITY $ORG $OUUNIT $CACN $MAIL
}

function create_jks() {
for SERVICE in $(cat service_list.txt)
do
CN=$SERVICE
[ ! -f $SSL_PATH/$SERVICE.jks ] && $(dirname $(realpath "$0"))/auto_service_jks.exp $PASS $COUNTRY $STATE $LOCALITY $ORG $OUUNIT $CN $MAIL || continue
done
}


[ ! -f $SSL_PATH/ca-key ] && [ ! -f $SSL_PATH/ca-cert ] && create_cacert
create_jks

