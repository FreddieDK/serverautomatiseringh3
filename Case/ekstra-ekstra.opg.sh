#!/bin/bash

# Kort eksempel til øvelse af CASE // Switch

clear
read -p "Hvilet land vil du kende tiden til?: " land

case $land in
    Danmark)
        clear
        echo "Tiden i Danmark er: $(zdump Europe/Copenhagen | awk '{print $5}')"
    ;;

    Spanien)
        clear
        echo "Tiden i Spain er: $(zdump Europe/Madrid | awk '{print $5}')"
    ;;

    Japan)
        clear
        echo "Tiden i Japan er: $(zdump Asia/Tokyo | awk '{print $5}')"
    ;;

    Canada)
        clear
        echo "Tiden I Canada er: $(zdump Canada/Central | awk '{print $5}')"
    ;;

    *)
        clear
        echo "Tiden for $land kendes ikke.."
    ;;
esac