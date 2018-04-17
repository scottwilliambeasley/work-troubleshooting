#!/bin/bash

getPingResult() {

        ping -c 1 $interface 1>/dev/null;

        if [ $? -eq 0 ]; then
                canPing="responsive"
        else
                canPing="unresponsive"
        fi

        echo $canPing;
}

getInterfaceType () {

        echo $interface | grep -P '^10\.|^127|^(172\.(1[6-9]|2[0-9]|3[01]\.))|^(192\.168\.)' 1>/dev/null 2>&1

        if [ $? -eq 0 ]; then
                interfaceType="Private"
        else
                interfaceType="Public"
        fi

        echo $interfaceType;

}

showConnectionResults () {

        echo "";

        setterm -term linux -back red;
                echo -n "$interfaceType Interface - $interface";
        setterm -default;

        echo "";

        echo "ICMP  : $canPing";
        echo "SSH   : $sshStatus";
        echo "HTTP  : $httpStatus";
        echo "HTTPS : $httpsStatus";
        echo "RDP   : $rdpStatus";
        echo "MYSQL : $mysqlStatus";
        echo "MSSQL : $mssqlStatus";
}

for interface in "$@"; do

        canPing=$(getPingResult $interface)
        interfaceType=$(getInterfaceType $interface)

        nmapResult=$(nmap -Pn -p 22,80,443,3306,1433,3389 $interface);
                sshStatus=$(echo    "$nmapResult" | grep '22/tcp'   | awk '{print $2}' );
                httpStatus=$(echo   "$nmapResult" | grep '80/tcp'   | awk '{print $2}' );
                httpsStatus=$(echo  "$nmapResult" | grep '443/tcp'  | awk '{print $2}' );
                rdpStatus=$(echo    "$nmapResult" | grep '3389/tcp' | awk '{print $2}' );
                mysqlStatus=$(echo  "$nmapResult" | grep '3306/tcp' | awk '{print $2}' );
                mssqlStatus=$(echo  "$nmapResult" | grep '1433/tcp' | awk '{print $2}' );

        showConnectionResults;

done

