
#### Scripts for generating own S/MIME keys

Run ./gen_ca.sh to create the CA and then ./gen.sh to create individual keys

gen_ca.sh requires the following parameters:  
`-d domain`  

gen.sh requires the following parameters:  
`-d domain`  
`-e email`  
`-f Full name`  
`-s Serial number`  

Example:
```
./gen_ca.sh -d abc.com
./gen.sh -d abc.com -e f1.l1@abc.com -s 1 -f "Firstname1 Lastname1"
./gen.sh -d abc.com -e f2.l2@abc.com -s 2 -f "Firstname2 Lastname2"
```
Then copy the created p12-file to you phone and install the certificate.