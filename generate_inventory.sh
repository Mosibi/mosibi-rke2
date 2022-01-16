#!/bin/bash

MASTERS=(rke2-master1)
WORKERS=(rke2-worker1 rke2-worker2 rke2-worker3)

echo "[rke2_servers]"
for _N in ${MASTERS[@]}; do
	_ADDR=$(virsh domifaddr "${_N}" |awk '/ipv4/ {print $NF}'|awk -F\/ '{print $1}')
	echo $_N ansible_host=${_ADDR}
done

echo " "
echo "[rke2_agents]"
for _N in ${WORKERS[@]}; do
	_ADDR=$(virsh domifaddr "${_N}" |awk '/ipv4/ {print $NF}'|awk -F\/ '{print $1}')
	echo $_N ansible_host=${_ADDR}
done

echo " "
echo "[rke2_cluster:children]"
echo "rke2_servers"
echo "rke2_agents"
