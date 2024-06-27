#!/usr/bin/env sh

de() {
    container=$(get_container_name "$1")

    if [ "container" = "" ]; then return; fi

    docker exec -it "${container}" bash 2> /dev/null || docker exec -it "${container}" sh
}

ds() {
    container=$(get_container_name "$1")

    if [ "container" = "" ]; then return; fi

    docker stop "${container}"
}

drm() {
    container=$(get_container_name "$1")

    if [ "container" = "" ]; then return; fi

    docker rm "${container}"
}

dsrm() {
    container=$(get_container_name "$1")

    ds "${container}" && drm "${container}"
}

dp() {
    container=$(get_container_name "$1")

    docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}}  {{end}}' "${container}"
}

get_container_name(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    fi
    docker ps --format '{{.Names}}' | fzf
}
