### Key and CSR Generator

Incase their are multiple domains for each of which a KEY and CSR is required, user cannot go on executing same commands everytime. Executing the script will create key and csr files for domains which are specified in different file named **domains**. Password for csr generation is specified in separate file **pass** to avoid being viewed under utilities like *ps*.

Script further includes generation of PFX files.

##### Script will start by asking user to proceed with CSR or PFX generation.

###### For CSR Generation

There are two cases in which one can generate csr. In each case user is asked to input subject values and follow constraints applied over input of subject values. At end new directory will be created with the title ***csrday-month-year-second*** and all csr files will be transfered in it leaving behind all key files.
* Use different Company Name than Domain Name
* Continue with Domain Name as Company Name

*Note: Currently subject values are applied to all the domains. Future commits shall include ways to offer applying values to individual domains or all of them at once.*

###### For PFX Generation

If you proceeds with these you need to make sure that, there are respective CRT ad KEY files present in the directory for the domains one needs PFX. Rest all is taken care by the script. It reads through all crt files for the domains and respective key file, if matched generates the pfx for the domain. Unlike CSR, a new directory will be created with title *pfxday-month-year-second* and all pfx files will be transfered in it.

##### Running the script

No root privileges in order to run the script. No excutable permissions given, hence use bash inorder to run the script. Download the zip and extract it. Go to the extracted directoy and run the command

$ bash generate.sh
