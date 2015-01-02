: 'Script is to create key and csr files for the domain which are maintiained in separate file.'

#!/bin/bash

red='\e[0;31m'
blue='\e[0;34m'
nc='\e[0m'

country=.
state=.
locality=.
orgname=.
orgunit=.
companyname=.
email=.

printf "Subject values to be passed while creating csr\n
${blue}country=.
state=.
locality=.
orgname=.
orgunit=.
companyname=.
email=.${nc}

Select from options below
0 - Continue with given Subject values
1 - Change subject values and continue\n"
read bool

if [ $bool -eq 1 ]
then
	printf "Enter new subject values:\nCountry (2 letter code) [US]="
	read country

	while [ `echo $country | wc -L` -ne 2 ]		                          #Check if country name is equal to 2 characters
	do
		printf "${red}Country Name should be 2 Characters e.g., US.\n${blue}Enter New one=${nc}"
		read country
	done

	printf "State [Enter . for empty value]="
	read state
	printf "Locality [Enter . for empty value]="
	read locality
	printf "Organisation Name [Enter . for empty value]="
	read orgname
	printf "Organisation Unit [Enter . for empty value]="
	read orgunit
	printf "Company Name (max 64 letter) [Enter . for empty value]="
	read companyname
	echo $companyname
	
	if [ "$companyname"=="" ]						#check if company name is not null
	then
		companyname=.
	fi

	printf "Email-Id (max 64 letter) [Enter . for empty value]="
	read email

	printf "\n\n${blue}Applying new subject values\n\n${nc}"

	for line in `cat ./domains`
	do
		echo "--------------------------------------------------------$line-----------------------------------------------------------"
		openssl genrsa -des3 -out $line.key -passout file:./pass 2048			#for generating key. Password is taken from 'pass' file.
		
		openssl req -nodes -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country/ST=$state/L=$locality/O=$orgname/OU=$orgunit/CN=$companyname"							#for generating csr with user input subject values. Password is taken from 'pass' file.
		if [ `echo $?` -eq 0 ]
		then
			printf "${blue}KEY and CSR for $line is generated successfully.${nc}\n"
		else
			printf "\n${red}Key generated successfully. Error while creating CSR.${nc}\n\n"
		fi
	done

elif [ $bool -eq 0 ]
then
	for line in `cat ./domains`
	do
		echo "--------------------------------------------------------$line-----------------------------------------------------------"
		openssl genrsa -des3 -out $line.key -passout file:./pass 2048			#for generating key. Password is taken from 'pass' file.

		openssl req -nodes -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country /ST=$state /L=$locality /O=$orgname /OU=$orgunit /CN=$companyname"				#for generating csr with default subject values. Password is taken from 'pass' file.

		if [ `echo $?` -eq 0 ]
		then
			printf "${blue}KEY and CSR for $line is generated successfully.${nc}\n\n"
		else
			printf "${red}Key generated successfully. Error while creating CSR.${nc}\n"
		fi
	done

else
	printf "${red}Invalid Option. Please select from above.${nc}\n"
fi
