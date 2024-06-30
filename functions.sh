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
    docker inspect "${container}" | jq -r '.[].NetworkSettings.Ports.[]' | jq '.[].HostPort' | uniq
}

durl() {
    container=$(get_container_name "$1")
    res=$(docker inspect "${container}"| jq -r '.[].NetworkSettings.Ports.[]' | jq '.[].HostPort' | uniq)

    declare -a array

    while IFS= read -r line; do
        array+=(${line:1:-1})
    done <<< "$res"

    echo $array
    port=$(printf "%s\n" "${array[@]}" | fzf)
    url="http://localhost:"
    url+=$port
    echo $url
    xdg-open $url >/dev/null

}

dl () {
    container=$(get_container_name "$1")

    docker logs "${container}"
}

dlf () {
    container=$(get_container_name "$1")

    docker logs "${container}" -f
}

get_container_name(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    fi
    docker ps --format '{{.Names}}' | fzf
}
