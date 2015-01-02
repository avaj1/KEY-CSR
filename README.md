### Key and CSR Generator

Incase their are multiple domains for each of which a key and csr is required, user cannot go on executing same commands everytime. Executing the script will create key and csr files for domains which are specified in different file named **domains**. Password for csr generation is specified in separate file **pass** to avoid being viewed under utilities like *ps*.

The Script will be loaded with default Subject values for csr genetration. User is asked to change subject values and generate csr.
Following are default Subject Values:
* country=.
* state=.
* locality=.
* orgname=.
* orgunit=.
* companyname=.
* email=.

User is provided with option to input subject values. User is required to follow constraints applied over input of subject values.

##### Running the script

No root privileges in order to run the script. No excutable permissions given, hence use bash inorder to run the script. Download the zip and extract it. Go to the extracted directoy and run the command

$ bash create_key+csr.sh
