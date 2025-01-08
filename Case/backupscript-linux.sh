#!/bin/bash

# Script til backup af filer på bash CLI'er

# Man-page // help 
/backup.man

# Variabel til standard source af filer 
standard_kilde="/home"

# Variabel til standard destination af filer
standard_destination="/etc/backup/serverbackups"

# Variabler til nuværende tidspunkt og navn på maskine
tid=$(date +%d-%m-%Y-%H-%M)
hostnavn=$(hostname -s)

# Tjekker første Argument for enten destination eller kilde lokation
if [[ "$1" == "-destination" ]]; then
    read -p "Indtast den ønskede destination: " destination
elif [[ "$1" == "-kilde" ]]; then
    read -p "Indtast den ønskede kilde: " kilde
# Vælg standarde kilde eller destination hvis ikke valgt i argument
else
    destination="$standard_destination"
    kilde="$standard_kilde"
fi

# Tjekker andet argument for enten destination eller kilde lokation
if [[ "$2" == "-destination" ]]; then
    read -p "Indtast den ønskede destination: " destination
elif [[ "$2" == "-kilde" ]]; then
    read -p "Indtast den ønskede kilde: " kilde
fi

# Hvis ingen argumenter er indtastet, vælg standarde destination og kilde fra variabler 
: "${destination:=$standard_destination}"
: "${kilde:=$standard_kilde}"


# Arkiver/zip en kopi af filerne til valgte lokation med hostnavn og tidspunkt i navnet
zip -rv "$destination/backup_($hostnavn-$tid).zip" "$kilde"







