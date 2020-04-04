#!/bin/bash
# Tunnel to the micro instance on port 8080

# Force exit code 0 when terminated
trap 'exit 0' SIGINT SIGQUIT SIGTERM

LOCAL_TUNNEL_PORT=8080
SSH_KEY=$(terraform output ssh_key)
VPN_HOST=$(terraform output instance_hostname)

ssh -vv -oStrictHostKeyChecking=no -i ${SSH_KEY} -D ${LOCAL_TUNNEL_PORT} -C -q -N -l ubuntu ${VPN_HOST}
