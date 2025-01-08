#!/bin/bash

# Funktion til at lave ping
function pingnow(){
read -p "Hvad vil du ping?: " pingvalg
ping $pingvalg 
}

# Funktion til at lave nslookup
#function nslookupnow(){

#}

# Funktion til at lave tracert
#function tracertnow(){

    
#}

# Besked ved kørsel af script

echo "Hvad vil du gerne teste?:"

echo "1 - Ping (Ping en IP eller domain)"
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










}
