#!/bin/bash
#Hier sind ist die Ausgabe die wir sehen, wenn wir das Bash script starten.
options=(
    "build" \
    "run" \
	"show_logs" \
    "Quit"
)

#Hier sind die Funktionen definiert. Dies bedeutet die Optionen die wir oben angegeben haben, haben im Hintergrund einen Befehl und diese werden hier erstellt.
function doit {
    case "$1" in
        "build")
            docker build -t tslb02 .
            ;;
        "run")
            docker-compose -f docker-compose.yml up -d
            ;;
		"show_logs")
            docker-compose -f docker-compose.yml logs -f
            ;;
        "Quit")
            echo "exit"
            exit 0
            ;;
        *)
            echo "unknown option"
            ;;
    esac
}
#Hier wird eingerichtet, wenn was passiert.
PS3='Please enter your choice: '
select opt in "${options[@]}"
do
	doit "${opt}"
done
