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

durl() {
    container=$(get_container_name "$1")

    res=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}};{{end}}' "${container}")
    IFS=";" read -rA ports <<< "$res"

    declare -a array
    for a in $ports; do
        array+=(`echo $a | cut -d'/' -f1`)
    done
    port=$(printf "%s\n" "${array[@]}" | fzf)
    url="http://localhost:"
    url+=$port
    echo $url
    xdg-open $url >/dev/null

}

get_container_name(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    fi
    docker ps --format '{{.Names}}' | fzf
}
