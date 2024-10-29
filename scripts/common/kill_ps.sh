#!/bin/bash

function kill_ps()
{
	local pname=$1
	pid=$(ps -ef | grep "${pname}" |grep -v grep |awk '{print $2}')

	if [[ -n $pid ]]; then
		for p in ${pid}; do
			kill -9 $p
            echo "Successful shutdown [${pname}]: ${p}"
		done
    else
        echo "No running processes: [${pname}]"
	fi
}