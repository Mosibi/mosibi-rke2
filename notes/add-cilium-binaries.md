# Use the following commands to download the cilium and hubble binaries

```lang=shell
wget https://github.com/cilium/cilium-cli/releases/download/v0.13.2/cilium-linux-amd64.tar.gz
wget https://github.com/cilium/hubble/releases/download/v0.11.3/hubble-linux-amd64.tar.gz

tar xvzf hubble-linux-amd64.tar.gz
tar xvzf cilium-linux-amd64.tar.gz
```

After the above you should be able to see the hubble and cilium status

```lang=shell
export HUBBLE_SERVER="$(kubectl -n kube-system get svc hubble-relay -o=jsonpath='{.spec.clusterIP}'):80"
./hubble status
./cilium status
```
