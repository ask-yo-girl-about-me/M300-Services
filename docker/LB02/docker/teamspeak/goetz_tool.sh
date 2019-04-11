#!/bin/bash

options=(
    "build" \
    "run" \
	"show_logs" \
    "Quit"
)


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

PS3='Please enter your choice: '
select opt in "${options[@]}"
do
	doit "${opt}"
done
