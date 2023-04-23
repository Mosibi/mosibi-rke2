# Hubble User Interface

Create a Traefik IngressRoute for the Hubble UI. After applying it, you can connect to it from within the cluster.

```lang=yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: hubble-ui-ingress
  namespace: kube-system
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host(`hubble.example.com`)
    services:
      - kind: Service
        name: hubble-ui
        port: 80
```

When you need to connect to the Hubble UI from outside your cluster, you could use a `kubectl port-forward` construction, or use a SSH tunnel. 

This example creates an SSH tunnel via the master (192.168.122.126) to the external loadbalancer ip address of the Traefik Ingress Controller (192.168.122.240).

```lang=shell
ssh -L 8080:192.168.122.240:80 192.168.122.126
```

From your host you should now be able to connect to the Hubble UI: `curl -H 'Host: hubble.example.com' http://localhost:8080`

Add hubble.example.com to the `localhost` entry in /etc/hosts and you can connect to http://hubble.example.com:8080 in a browser.