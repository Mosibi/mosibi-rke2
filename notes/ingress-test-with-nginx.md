# Create a deployment with nginx and expose it as a service

```lang=shell
kubectl create deployment nginx --image=nginx:latest
kubectl expose deployment nginx --port 80 --target-port 80
```

Create an ingress rule for the service nginx under hostname `web.example.com`

```lang=yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - host: web.example.com
    http:
      paths:
        - pathType: Prefix
          path: "/"
          backend:
            service:
              name: nginx
              port:
                number: 80
```

Test the ingress rule with the following commands

```lang=shell
NGINX_SVC_IP=$(kubectl get svc nginx -o=jsonpath='{.spec.clusterIP}')
curl -H 'Host: web.example.com' http://${NGINX_SVC_IP} -vvvL
```
