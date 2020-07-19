# openvpn-k8s

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/shubhamtatvamasi/openvpn-k8s)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/shubhamtatvamasi/openvpn-k8s?sort=semver)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/shubhamtatvamasi/openvpn-k8s/latest)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)
[![Docker Pulls](https://img.shields.io/docker/pulls/shubhamtatvamasi/openvpn-k8s)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)
[![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/shubhamtatvamasi/openvpn-k8s/latest)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/shubhamtatvamasi/openvpn-k8s)](https://hub.docker.com/r/shubhamtatvamasi/openvpn-k8s)

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
    storage: 10M
  hostPath:
    path: "/usr/pv/openvpn"
EOF
```

deploy openvpn
```bash
helm install openvpn ./openvpn

helm upgrade -i openvpn ./openvpn

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

