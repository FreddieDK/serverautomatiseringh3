#!/bin/bash

echo "Hvad vil du gerne teste?:"

echo "1 - Ping (Ping en IP eller domain)"
echo "2 - nslookup (Tjek om dns fungere)"
echo "3 - tracert (Tjekke om fejl på routning til en bestemt lokation)"

read valg


function pingnow(){


}

function nslookupnow(){

    
}

function tracertnow(){

    
}

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
