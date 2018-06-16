#!/usr/bin/env bash

set_url() {
    read -p "Enter url path >>> /" url_path
    if [ "$url_path" ]; then
        sed -i "/location/s/connect/$url_path/" conf.d/default.conf
    fi
}

generate_ports() {
    ports_count=3
    port_min=1024
    port_max=65535

    # Generate array of random ports
    for i in { 1.."$ports_count" }; do
        ports+=( $(( $RANDOM % ( $port_max - $port_min ) + $port_min )) )
    done
}

set_ports() {
    generate_ports

    for port in ${ports[@]}; do
        # Generate string with ports for knockd.conf
        knockd_ports="${knockd_ports}${port},"
        # Generate string with ports for docker-compose.yml
        docker_compose_ports="${docker_compose_ports}\"${port}:${port}\"\n      - "
        # Add server block with port to nginx
        sed -i "s/KNOCKD_PORT/$port/" conf.d/default.conf
        cat << EOF >> conf.d/default.conf

server {
    listen $port;
    location = /knockd {
        return 302 \$scheme://\$host:KNOCKD_PORT/knockd;
    }
}
EOF
    done

    # Replace port for last redirect
    sed -i "s/:KNOCKD_PORT\/knockd//" conf.d/default.conf
    # Replace ports string in knockd.conf
    knockd_ports="$(echo "$knockd_ports" | sed 's/,$//')"
    sed -i "s/KNOCKD_PORTS/$knockd_ports/" knockd.conf
    # Replace ports string in docker-compose.yml
    docker_compose_ports="$(echo "$docker_compose_ports" | sed 's/\\n      - $//')"
    sed -i "s/KNOCKD_PORTS/$docker_compose_ports/" docker-compose.yml
}

set_url
set_ports
