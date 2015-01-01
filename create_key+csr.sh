:' Script is to create key and csr files for the domain which are maintiained in separate file.'

#!/bin/bash

red='\e[0;31m'
blue='\e[0;34m'
nc='\e[0m'

country=.
state=.
locality=.
orgname=.
orgunit='Domain Control Validated'
companyname=AllNaturalThin.com
email=.

printf "Subject values to be passed while creating csr
${red}country=.
state=.
locality=.
orgname=.
orgunit='Domain Control Validated'
companyname=AllNaturalThin.com
email=.${nc}

Select from options below
0 - Continue with given Subject values
1 - Change subject values and continue\n"
read bool

if [ $bool -eq 1 ]
then
	printf "Enter new subject values:\nCountry="
	read country
	printf "State="
	read state
	printf "Locality="
	read locality
	printf "Organisation Name="
	read orgname
	printf "Organisation Unit="
	read orgunit
	printf "Company Name="
	read companyname
	printf "Email-Id="
	read email
	echo "Applying values"

	for line in `cat ./domains`
	do
		echo "--------------------------------------------------------$line-----------------------------------------------------------"
		openssl genrsa -des3 -out $line.key -passout pass:$passwd 2048
		printf "\n${blue}KEY for $line is generated successfully.${nc}\n"
		
		openssl req -nodes -new -key $line.key -out $line.csr -passin pass:$passwd -subj "/C=$country /ST=$state /L=$locality /O=$orgname /OU=$orgunit /CN=$companyname"
		if [ `echo $?` -eq 0 ]
		then
			printf "${blue}CSR for $line is generated successfully.${nc}\n"
		else
			printf "\n${red}Error while creating CSR.${nc}\n\n"
		fi
	done

elif [ $bool -eq 0 ]
then
	for line in `cat ./domains`
	do
		echo "--------------------------------------------------------$line-----------------------------------------------------------"
		printf "\n${blue}KEY for $line is generated successfully.${nc}\n"
		openssl genrsa -des3 -out $line.key -passout file:./pass 2048

		if [ `echo $?` -eq 0 ]
		then
			printf "${blue}CSR for $line is generated successfully.${nc}\n\n"
		else
			printf "${red}Error while creating CSR.${nc}\n"
		fi
		
		openssl req -nodes -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country /ST=$state /L=$locality /O=$orgname /OU=$orgunit /CN=$companyname"
	done

else
	printf "${red}Invalid Option. Please select from above.${nc}\n"
fi
