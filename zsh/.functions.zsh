# docker compose with optional
function dc {
    if [ -z "$1" ]; then
        docker compose
    else 
        docker compose -f "./docker-compose-$1.yml"
    fi
}
