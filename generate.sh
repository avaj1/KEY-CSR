: 'Script is to create key, csr and pfx files for the domain which are maintiained in separate file.'

#!/bin/bash

red='\e[0;31m'
blue='\e[0;34m'
nc='\e[0m'

function input_subjvalues
{
	printf "Enter new subject values:\nCountry (2 letter code) e.g., US [Press enter for empty string]="
	read country

	while [ `echo $country | wc -L` -gt 2 ]							#check is country name for 2 characters
	do
		printf "${red}Country Name should be 2 Characters e.g., US.\n${blue}Enter New one=${nc}"
		read country
	done

	printf "State [Press enter for empty string]="
	read state
	printf "Locality [Press enter for empty string]="
	read locality
	printf "Organisation Name [Press enter for empty string]="
	read orgname
	printf "Organisation Unit [Press enter for empty string]="
	read orgunit

	if [ $bool -eq 0 ]
	then
		while [	"$companyname" == "" ]
		do
			printf "Company Name (max 64 letter) [${red} Empty string not allowed.${nc}]="
			read companyname
		done
	fi

	printf "Email-Id (max 64 letter) [Press enter for empty string]="
	read email

	printf "\n\n${blue}Applying new subject values\n\n${nc}"
}

printf "${blue}Select from option below:\n0 - Start with KEY-CSR generation\n1 - Switch to PFX generation\n${nc}"
read ans

case $ans in
	0)
		printf "${blue}Select from options below:\n0 - Use different Company Name than Domain Name\n1 - Continue with Domain Name as Company Name\n${nc}"
		read bool

		if [ $bool -eq 1 ]
		then
			input_subjvalues

			for line in `cat ./domains`
			do	
				echo "--------------------------------------------------------$line-----------------------------------------------------------"
				openssl genrsa -des3 -out $line.key -passout file:./pass 2048			#for generating key. Password is taken from 'pass' file.
		
				if [ $country == "" ]
				then
					openssl req -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country  /ST=$state/L=$locality/O=$orgname/OU=$orgunit/CN=$line"									#for generating csr with default subject values. Password is taken from 'pass' file.
				else
					openssl req -nodes -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country/ST=$state/L=$locality/O=$orgname/OU=$orgunit/CN=$line"								#for generating csr with default subject values. Password is taken from 'pass' file.		
				fi

				if [ `echo $?` -eq 0 ]
				then
					printf "${blue}KEY and CSR for $line is generated successfully.${nc}\n"
				else
					printf "\n${red}Key generated successfully. Error while creating CSR.${nc}\n\n"
				fi
			done

		mkdir csr`date +%d-%m-%Y-%S`
		mv *.csr $_

		elif [ $bool -eq 0 ]
		then
			input_subjvalues
	
			for line in `cat ./domains`
			do
				echo "--------------------------------------------------------$line-----------------------------------------------------------"
				openssl genrsa -des3 -out $line.key -passout file:./pass 2048			#for generating key. Password is taken from 'pass' file.

				if [ $country == "" ]
				then
					openssl req -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country  /ST=$state /L=$locality /O=$orgname /OU=$orgunit /CN=$companyname"									#for generating csr with default subject values. Password is taken from 'pass' file.
				else
					openssl req -nodes -new -key $line.key -out $line.csr -passin file:./pass -subj "/C=$country/ST=$state/L=$locality/O=$orgname/OU=$orgunit/CN=$companyname"								#for generating csr with default subject values. Password is taken from 'pass' file.		
				fi

				if [ `echo $?` -eq 0 ]
				then
					printf "${blue}KEY and CSR for $line is generated successfully.${nc}\n\n"
				else
					printf "${red}Key generated successfully. Error while creating CSR.${nc}\n"
				fi
			done

		mkdir csr`date +%d-%m-%Y-%S`
		mv *.csr $_

		else
			printf "${red}Invalid Option. Please select from above.${nc}\n"
		fi
		;;

	1)
		for f in *
		do
			if [ `echo $f | grep ".crt"` ]
			then
#				echo "crt files" $f
				cn=`openssl x509 -in $f -noout -subject | sed -r 's|.*CN=(.*)|\1|; s|/[^/]*=.*$||'`

				if [ `echo $cn | grep "*"` ]
				then
					newcn=`echo $cn | tr -d '*.'`
					openssl pkcs12 -export -in $f -inkey $cn.key -out $newcn.pfx -password file:./pass -passin file:./pass	#Generation of pfx using respective domain key
				else
					openssl pkcs12 -export -in $f -inkey $cn.key -out $cn.pfx -password file:./pass -passin file:./pass	#Generation of pfx using respective domain key

				fi	

#				openssl pkcs12 -export -in $f -inkey $cn.key -out $cn.pfx -password file:./pass -passin file:./pass	#Generation of pfx using respective domain key
#				echo $cn.key

				if [ `echo $?` -eq 0 ]
				then
#					echo $cn
					printf "${blue}pfx for $cn is generated.${nc}\n"
				echo "----------------------------------------------------------------------------------------------"
				else
					rm $f.pfx
				fi

#			else
#				printf "${red}pfx cannot be generated using $f file.${nc}\n"
			fi	
		done

		mkdir pfx`date +%d-%m-%Y-%S`
		mv *.pfx $_ #$_ is last vairble passed to terminal

		;;
	*)
		echo invalid
		;;
esac
