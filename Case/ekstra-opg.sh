#!/bin/bash

# Funktion til at lave ping
function pingnow(){
read -p "Hvad vil du tjekke? (Ping IP el. Domain): " pingvalg
    if ping -c 1 $pingvalg > /dev/null; then
        echo "Server svare!"
    else
        echo "Server svare ikke.."
    fi
}

# Funktion til at lave nslookup
function nslookupnow(){
read -p "Hvilket domain vil du tjekke?: " domainvalg
read -p "Hvillken dns server vil du bruge?: (Standard 1.1.1.1) " dnsvalg
    if [[ $dnsvlag == null ]]; then
        nslookup $domainvalg 1.1.1.1 
    else
        nslookup $domainvalg dnsvalg
    fi
}

# Funktion til at lave tracert
#function tracertnow(){

    
#}

# Besked ved kørsel af script

echo "Hvad vil du gerne teste?:"

echo "1 - Tjek server-status (Ping en IP eller domain)"
echo "2 - nslookup (Tjek om dns fungere)"
echo "3 - tracert (Tjekke om fejl på routning til en bestemt lokation)"

read valg

# Valg af funktion-kørsel

if [[ "$valg" == "1" ]]; then
    pingnow
elif [[ "$valg" == "2" ]]; then
    nslookupnow
elif [[ "$valg" == "3" ]]; then
    tracertnow
else
    echo "Dette er ikke en gyldig valgmulighed"
fi 

