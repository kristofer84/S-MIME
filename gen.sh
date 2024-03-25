while getopts s:e:f:d: flag
do
    case "${flag}" in
        s) serial=${OPTARG};;
        e) email=${OPTARG};;
        f) fullname=${OPTARG};;
        d) domain=${OPTARG};;
    esac
done

[[ -z $email ]] && { echo "Email must be set with -e parameter"; exit; }
[[ -z $serial ]] && { echo "Serial number must be set with -s parameter"; exit; }
[[ -z $fullname ]] && { echo "Full name must be set with -f parameter"; exit; }
[[ -z $domain ]] && { echo "Domain must be set with -d parameter"; exit; }

filename="${email//[@\.]/_}"
domainfilename="${domain//[\.]/_}"

echo $filename
echo $serial
echo $fullname
echo $domain

openssl genrsa \
-aes256 \
-out ./smime/${filename}_private_key.key \
4096

openssl req \
-new \
-key ./smime/${filename}_private_key.key \
-out ./smime/${filename}_private_key.csr \
-subj "/C=SE/ST=Stockholm/L=/O=${domain}/OU=/CN=${fullname}/emailAddress=${email}"

openssl x509 \
-req \
-days 3650 \
-in ./smime/${filename}_private_key.csr \
-CA ca_${domainfilename}.crt \
-CAkey ca_${domainfilename}.key \
-set_serial $serial \
-out ./smime/${filename}_smime.crt \
-addtrust emailProtection \
-addreject clientAuth \
-addreject serverAuth \
-trustout \
-extfile /usr/lib/ssl/openssl.cnf \
-extensions smime

openssl pkcs12 \
-export \
-in ./smime/${filename}_smime.crt \
-inkey ./smime/${filename}_private_key.key \
-out ./smime/${filename}_smime.p12
