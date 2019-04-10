#!/bin/bash
ENV_FILE=.env
source ${ENV_FILE}

stackCommonServicesFile=docker-compose.stack_common-services.yml
stackBuildFile=docker-compose.stack_build.yml
stackRunFile=docker-compose.stack_run.yml

options=(
    "init_swarm" \
    "create_docker_network" \
    "create_docker_secrets" \
    "createLDAPCerts.sh" \
    "build_CAS" \
    "build_CAS_hard" \
    "run_CAS" \
    "run_CAS_hard" \
    "removeStacks" \
    "removeContainers" \
    "show_logs_build_CAS" \
    "show_logs_run_CAS" \
    "show_logs_cas-traefik" \
    "edit_docker-compose.common-services_template.yml" \
    "edit_docker-compose.build_template.yml" \
    "edit_docker-compose.run_template.yml" \
    "edit_.env" "edit_traefik.toml" \
    "edit_cas-mysql_createCASUser.sql" \
    "edit_keycloak-mysql_createKeycloakUser.sql" \
    "edit_create_docker_secrets.sh" \
    "edit_ldap/image/environment/default.startup.yaml" \
    "edit_keycloak-proxy/configs/proxy-cas-server-cors-config.yml" \
    "edit_keycloak-proxy/configs/proxy-cas-client-cors-config.yml" \
    "Quit"
)

function createComposeFile {
    source ${ENV_FILE}
    if [ "$ENABLE_DOCKER_SWARM" = true ] && [ "$1" != "compose" ]; then
        commonServicesSecretConfig=docker-compose.common-services_template_secretStore.yml
        buildSecretConfig=docker-compose.build_template_secretStore.yml
        runSecretConfig=docker-compose.run_template_secretStore.yml
    else
        commonServicesSecretConfig=docker-compose.common-services_template_secretFile.yml
        buildSecretConfig=docker-compose.build_template_secretFile.yml
        runSecretConfig=docker-compose.run_template_secretFile.yml
    fi
    docker-compose -f docker-compose.common-services_template.yml -f ${commonServicesSecretConfig} config > ${stackCommonServicesFile}
    docker-compose -f docker-compose.build_template.yml -f ${buildSecretConfig} config > ${stackBuildFile}
    docker-compose -f docker-compose.run_template.yml -f ${runSecretConfig} config > ${stackRunFile}
}

function evalParams () {
    containers=""
    while (( "$#" )); do
        if [ "$1" == "hard" ]; then
            buildHardOptions="--force-rm --no-cache --pull"
        elif [ "$1" == "build_CAS" ]; then
            composeFile=${stackBuildFile}
        elif [ "$1" == "run_CAS" ]; then
            composeFile=${stackRunFile}
        else
            containers+=$1" "
        fi
        shift
    done
}

function createDockerNetwork () {
    source ${ENV_FILE}
    docker network rm ${DOCKER_NETWORK_NAME} 2> /dev/null
    if [ "$ENABLE_DOCKER_SWARM" = true ]; then
        docker network create --driver=overlay --attachable ${DOCKER_NETWORK_NAME}
    else
        docker network create --driver=bridge --attachable ${DOCKER_NETWORK_NAME}
    fi
}

function buildContainer () {
    evalParams $@
    docker-compose -f ${stackCommonServicesFile} build ${buildHardOptions}
    docker-compose -f ${composeFile} build ${buildHardOptions} ${containers}
}

function startContainer () {
    evalParams $@
    source ${ENV_FILE}
    if [ "$ENABLE_DOCKER_SWARM" = true ]; then
        docker stack deploy -c ${stackCommonServicesFile} ${DOCKER_STACK_NAME_COMMON_SERVICES}
        if [ "${composeFile}" == "${stackBuildFile}" ]; then
            stackName=${DOCKER_STACK_NAME_BUILD_CAS}
        elif [ "${composeFile}" == "${stackRunFile}" ]; then
            stackName=${DOCKER_STACK_NAME_RUN_CAS}
        fi
        docker stack deploy -c ${composeFile} ${stackName}
    else
        docker-compose -f ${stackCommonServicesFile} up -d
        docker-compose -f ${composeFile} up -d $containers
    fi
}

function removeStacks () {
    docker stack rm ${DOCKER_STACK_NAME_COMMON_SERVICES}
    docker stack rm ${DOCKER_STACK_NAME_BUILD_CAS}
    docker stack rm ${DOCKER_STACK_NAME_RUN_CAS}
}

function removeContainers () {
    createComposeFile compose
    docker-compose -f ${stackCommonServicesFile} -f ${stackBuildFile} -f ${stackRunFile} rm -sf
}

function showLogs () {
    evalParams $@
    source ${ENV_FILE}
    if [ "$ENABLE_DOCKER_SWARM" = true ]; then
        echo -e "\033[1;31mto show logs in swarm mode use \"docker service logs -f SERVICENAME\"\033[0m"
    else
        docker-compose -f ${stackCommonServicesFile} -f ${composeFile} logs -f $containers
    fi
}

function doit {
    case "$1" in
        "init_swarm")
            echo "init_swarm"
            docker swarm init
            ;;
        "create_docker_network")
            echo "create cas network"
            createDockerNetwork
            ;;
        "create_docker_secrets")
            echo "create_docker_secrets"
            ./create_docker_secrets.sh
            ;;
        "createLDAPCerts.sh")
            echo "createLDAPCerts.sh"
            ./createLDAPCerts.sh
            ;;
        "build_CAS")
            echo "build CAS ${*:2}"
            createComposeFile
            buildContainer build_CAS ${*:2}
            startContainer build_CAS ${*:2}
            ;;
        "build_CAS_hard")
            echo "build CAS hard ${*:2}"
            createComposeFile
            buildContainer build_CAS hard ${*:2}
            docker stack rm ${DOCKER_STACK_NAME_BUILD_CAS} 2> /dev/null
            # sleeping a while to delete docker stack
            sleep 20
            startContainer build_CAS hard ${*:2}
            ;;
        "run_CAS")
            echo "run CAS ${*:2}"
            createComposeFile
            buildContainer run_CAS ${*:2}
            startContainer run_CAS ${*:2}
            ;;
        "run_CAS_hard")
            echo "run CAS hard ${*:2}"
            createComposeFile
            buildContainer run_CAS hard ${*:2}
            docker stack rm ${DOCKER_STACK_NAME_RUN_CAS} 2> /dev/null
            # sleeping a while to delete docker stack
            sleep 20
            startContainer run_CAS hard ${*:2}
            ;;
        "removeStacks")
            echo "removeStacks"
            removeStacks
            ;;
        "removeContainers")
            echo "removeContainers"
            removeContainers
            ;;
        "show_logs_build_CAS")
            echo "show logs build CAS ${*:2}"
            showLogs build_CAS ${*:2}
            ;;
        "show_logs_run_CAS")
            echo "show logs run CAS ${*:2}"
            showLogs run_CAS ${*:2}
            ;;
        "show_logs_cas-traefik")
            echo "show logs cas-traefik"
            less +F traefik/log/traefik.log
            ;;
        "edit_docker-compose.common-services_template.yml")
            echo "edit_docker-compose-build_template.yml"
            vi docker-compose.common-services_template.yml
            ;;
        "edit_docker-compose.build_template.yml")
            echo "edit_docker-compose.build_template.yml"
            vi docker-compose.build_template.yml
            ;;
        "edit_docker-compose.run_template.yml")
            echo "edit_docker-compose.build_template.yml"
            vi docker-compose.run_template.yml
            ;;
        "edit_.env")
            echo "edit_.env"
            vi .env
            ;;
        "edit_traefik.toml")
            echo "edit_traefik.toml"
            vi traefik/traefik.toml
            ;;
        "edit_cas-mysql_createCASUser.sql")
            echo "edit_cas-mysql_createCASUser.sql"
            vi cas-mysql/createCASUser.sql
            ;;
        "edit_keycloak-mysql_createKeycloakUser.sql")
            echo "edit_keycloak-mysql_createKeycloakUser.sql"
            vi keycloak-mysql/createKeycloakUser.sql
            ;;
        "edit_create_docker_secrets.sh")
            echo "edit_create_docker_secrets.sh"
            vi create_docker_secrets.sh
            ;;
        "edit_ldap/image/environment/default.startup.yaml")
            echo "edit_ldap/image/environment/default.startup.yaml"
            vi ldap/image/environment/default.startup.yaml
            ;;
        "edit_keycloak-proxy/configs/proxy-cas-server-cors-config.yml")
            echo "edit_keycloak-proxy/configs/proxy-cas-server-cors-config.yml"
            vi keycloak-proxy/configs/proxy-cas-server-cors-config.yml
            ;;
        "edit_keycloak-proxy/configs/proxy-cas-client-cors-config.yml")
            echo "edit_keycloak-proxy/configs/proxy-cas-client-cors-config.yml"
            vi keycloak-proxy/configs/proxy-cas-client-cors-config.yml
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

function print_usage {
    echo -e "Usage: admin_tool.sh [option] [OPTIONAL_DOCKER_TO_BUILD (default: all) docker-service]\n" \
            "option:  -b        to build containers and build CAS in docker cas_build_stack\n" \
            "         -bh       to build containers and build CAS in docker cas_build_stack (build --force-rm --no-cache --pull)\n" \
            "         -r        to build containers and run CAS in docker cas_run_stack\n" \
            "         -rh       to build containers and run CAS in docker cas_run_stack (build --force-rm --no-cache --pull) \n" \
            "         -lb       to docker service logs from cas_build_stack \n" \
            "         -lr       to docker service logs from cas_run_stack\n"
}

if (( $# == 0 ))
then
    if (( $OPTIND == 1 ))
    then
        PS3='Please enter your choice: '
        select opt in "${options[@]}"
        do
            doit "${opt}"
        done
    fi
fi

case "$1" in
    "-b")
        doit build_CAS ${*:2}
        ;;
    "-bh")
        doit build_CAS_hard ${*:2}
        ;;
    "-r")
        doit run_CAS ${*:2}
        ;;
    "-rh")
        doit run_CAS_hard ${*:2}
        ;;
    "-lb")
        doit show_logs_build_CAS ${*:2}
        ;;
    "-lr")
        doit show_logs_run_CAS ${*:2} 
        ;;
    "-h")
        print_usage
        exit 0
        ;;
    *)
        echo -e "argument error \n"
        print_usage
        exit 1
        ;;
esac
