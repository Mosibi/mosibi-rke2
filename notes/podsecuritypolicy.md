# Configure a fully open PodSecurityPolicy for the default namespace

The default configured PodSecurityPolicy does not allow to run containers as root, which is a very good choise ofcourse. The following policy however, allows containers in the `default` namespace to run as root. This is just an example, **never ever use this in a production environment!**

```lang=yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: allow-all
  annotations:
    seccomp.security.alpha.kubernetes.io/allowedProfileNames: '*'
spec:
  privileged: true
  allowPrivilegeEscalation: true
  allowedCapabilities:
    - '*'
  volumes:
    - '*'
  hostNetwork: true
  hostPorts:
    - min: 0
      max: 65535
  hostIPC: true
  hostPID: true
  runAsUser:
    rule: 'RunAsAny'
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'RunAsAny'
  fsGroup:
    rule: 'RunAsAny'

---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: allow-all-clusterrole
rules:
  - apiGroups: ['policy']
    resources: ['podsecuritypolicies']
    verbs:     ['use']
    resourceNames:
      - allow-all

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: allow-all-rolebinding
  namespace: dmz
roleRef:
  kind: ClusterRole
  name: allow-all-clusterrole
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: system:authenticated
```
