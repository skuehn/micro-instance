#!/bin/bash
# Tunnel to the micro instance on port 8080

# Force exit code 0 when terminated
trap 'exit 0' SIGINT SIGQUIT SIGTERM

LOCAL_TUNNEL_PORT=8080
SSH_KEY=$(terraform output ssh_key)
VPN_HOST=$(terraform output instance_hostname)

function connect {
    ssh -vv -oStrictHostKeyChecking=no -i ${SSH_KEY} -D ${LOCAL_TUNNEL_PORT} -C -q -N -l ubuntu ${VPN_HOST}    
}

ATTEMPT=1
MAX_ATTEMPTS=3
while [ ${ATTEMPT} -lt ${MAX_ATTEMPTS} ]; do
    connect
    if [ $? == 0 ]; then
        echo "connection completed successfully. exiting" > /dev/stderr
	exit 0
    else
        echo "connection failed sleeping 10 seconds and retrying. Attempt ${ATTEMPT} of ${MAX_ATTEMPTS}." > /dev/stderr
	sleep 10s
	ATTEMPT=$((ATTEMPT + 1))
    fi
done

exit 1
