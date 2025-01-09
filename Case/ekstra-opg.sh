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
        if [[ $dnsvalg == null ]]; then
            nslookup $domainvalg 1.1.1.1 
        else
            nslookup $domainvalg $dnsvalg
        fi
    }

    #Funktion til at lave tracert
    function tracertnow(){
        read -p "Hvad vil tjekke routningen til? " tracertvalg
        tracepath -m 15 $tracertvalg
    }

    # Besked ved kørsel af script

    echo "Hvad vil du gerne teste?:"

    echo "1 - Tjek server-status (Ping en IP eller domain)"
    echo "2 - Nslookup (Tjek om dns fungere)"
    echo "3 - Tracert (Tjekke om fejl på routning til en bestemt lokation)"
    echo "4 - Alle (Køre alle funktioner i script)"

    read valg

    # Valg af funktion-kørsel

    if [[ "$valg" == "1" ]]; then
        echo "Du har valgt ping funktionen"
        pingnow
    elif [[ "$valg" == "2" ]]; then
        echo "Du har valgt nslookup funktionen"
        nslookupnow
    elif [[ "$valg" == "3" ]]; then
        echo "Du har valgt tracert funktionen"
        tracertnow
    elif [[ "$valg" == "4" ]]; then
        echo "Du har valgt at køre alle funktioner i scriptet"
        pingnow
        nslookupnow
        tracertnow
    else
        echo "Dette er ikke en gyldig valgmulighed"
    fi 

