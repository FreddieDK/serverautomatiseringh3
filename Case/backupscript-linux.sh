#!/bin/bash

# Script til backup af filer på bash CLI'er

# Variabel til standard source af filer 
standard_kilde="/home"

# Variabel til standard destination af filer
standard_destination="/etc/backup/serverbackups"

# Variabler til nuværende tidspunkt og navn på maskine
tid=$(date +%d-%m-%Y-%H-%M)
hostnavn=$(hostname -s)

# Argument til at kunne vælge en anden ønsket destination
if [[ "$1" == "-destination" ]]; then
    read -p "Indtast den ønskede destination: " destination
elif [[ "$1" == "-kilde" ]]; then
    read -p "Indtast den ønskede kilde: " kilde
else
    # Hvis $1 ikke var -destination eller -kilde,
    # så brug standardværdier i første omgang.
    destination="$standard_destination"
    kilde="$standard_kilde"
fi

# Tjekker andet argument
if [[ "$2" == "-destination" ]]; then
    read -p "Indtast den ønskede destination: " destination
elif [[ "$2" == "-kilde" ]]; then
    read -p "Indtast den ønskede kilde: " kilde
fi

# Hvis ingen argumenter er indtastet, vælg standarde
: "${destination:=$standard_destination}"
: "${kilde:=$standard_kilde}"

echo "Destination er: $destination"
echo "Kilde er: $kilde"





# Arkiver/zip en kopi af filerne til valgte lokation med hostnavn og tidspunkt i navnet
zip -rv "$destination/backup_($hostnavn-$tid).zip" "$kilde"


## logs



# Hjælp kommando funktion
Help()
{
   
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "g     Print the GPL license notification."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
   echo
}