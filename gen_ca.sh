while getopts d: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
    esac
done

[[ -z $domain ]] && { echo "Domain must be set with -d parameter"; exit; }

filename="${email//[@\.]/_}"
domainfilename="${domain//[\.]/_}"

echo "Generating CA for ${domain}"

echo ca_${domainfilename}.key
openssl genrsa \
-aes256 \
-out ca_${domainfilename}.key \
4096

echo ca_${domainfilename}.crt
openssl req \
-new \
-x509 \
-days 3650 \
-key ca_${domainfilename}.key \
-out ca_${domainfilename}.crt \
-subj "/C=SE/ST=Stockholm/L=/O=${domain}/OU=/CN=${domain}"
