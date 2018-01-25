# This script is meant to be used as a preliminary troubleshooting tool when a customer referencing an issue with their domain / DNS. 

#!/bin/bash

DOMAIN=$1
WHOIS_OUTPUT="$(whois $1)"


NONEXISTENT_DOMAIN="$(echo $WHOIS_OUTPUT | grep "No match")"

if [[ $NONEXISTENT_DOMAIN ]]; then
        echo "Nonexistent domain."
        exit 1
fi


#setting variables
REGISTRAR=$(echo "$WHOIS_OUTPUT" | grep "Registrar: " | sed -e 's/^[ \t]*//' )
CREATION_DATE=$(echo "$WHOIS_OUTPUT" | grep "Creation Date: " | sed -e 's/^[ \t]*//' )  
UPDATE_DATE=$(echo "$WHOIS_OUTPUT" | grep "Updated Date: " | sed -e 's/^[ \t]*//'  )
EXPIRY_DATE=$(echo "$WHOIS_OUTPUT" | grep "Registry Expiry Date: " | sed -e 's/^[ \t]*//'  )
DOMAIN_STATUS=$(echo "$WHOIS_OUTPUT" | grep "Domain Status: " | sed -e 's/^[ \t]*//'  )
NAME_SERVERS=$(echo "$WHOIS_OUTPUT" | grep "Name Server: " | sed -e 's/^[ \t]*//'  )
IP_ADDRESSES=$(dig "$DOMAIN" +short 2>&1 )
MAIL_SERVERS=$(dig MX "$DOMAIN" +short 2>&1 )

#formatting, printing output
echo ""
echo "---Registration Details---"
echo "$REGISTRAR"
echo "$CREATION_DATE"
echo "$UPDATE_DATE"
echo "$EXPIRY_DATE"

echo ""
echo "---Domain Status---"
echo "$DOMAIN_STATUS"

echo ""
echo "---Name Servers---"
echo "$NAME_SERVERS"

echo ""
echo "---IP addresses---"
echo "$IP_ADDRESSES"

echo ""
echo "---Mail Servers---"
echo "$MAIL_SERVERS"

