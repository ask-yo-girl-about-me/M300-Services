#!/bin/bash

options=(
    "build" \
    "build_hard" \
    "run" \
	"show_logs" \
    "Quit"
)


function doit {
    case "$1" in
        "build")
            docker-compose -f docker-compose.yml build
            ;;
        "build_hard")
            docker-compose -f docker-compose.yml build --force-rm --no-cache --pull
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

PS3='Please enter your choice: '
select opt in "${options[@]}"
do
	doit "${opt}"
done
