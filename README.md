# openvpn-k8s

search openvpn
```bash
helm search repo stable/openvpn
```

download repo
```bash
helm fetch --untar stable/openvpn
```

create a volume
```yaml
kubectl apply -f - << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: openvpn
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 2M
  hostPath:
    path: "/usr/pv/openvpn"
EOF
```

deploy openvpn
```bash
helm upgrade -i openvpn stable/openvpn -f openvpn/values.yaml
```
---

create new key
```bash
# Update the name
KEY_NAME=<name>

POD_NAME=$(kubectl get pods -l app=openvpn -o jsonpath='{.items[0].metadata.name}')
IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
kubectl exec -it ${POD_NAME} -- /etc/openvpn/setup/newClientCert.sh ${KEY_NAME} ${IP}
kubectl exec -it ${POD_NAME} -- cat "/etc/openvpn/certs/pki/${KEY_NAME}.ovpn" > ${KEY_NAME}.ovpn
```

revoke the key
```bash
# Update the name
KEY_NAME=<name>

POD_NAME=$(kubectl get pods -l app=openvpn -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it ${POD_NAME} -- /etc/openvpn/setup/revokeClientCert.sh ${KEY_NAME}
```
---

```bash
POD_NAME=$(kubectl get pods -l app=openvpn -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it ${POD_NAME} -- openssl crl -in /etc/openvpn/certs/pki/crl.pem -text -noout
```

