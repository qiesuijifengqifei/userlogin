#!/bin/bash
echo "docker exec startup.sh"
echo "source /etc/bash_completion" >> /root/.bashrc 
docker completion bash > /etc/bash_completion.d/docker
