#!/bin/bash

set -e

NAMESPACE="mesenv"

kubectl scale deployments -n $NAMESPACE filebrowser --replicas=0
kubectl delete deployment filebrowser -n $NAMESPACE
kubectl delete service filebrowser -n $NAMESPACE
kubectl delete pvc filebrowser-data-$NAMESPACE -n $NAMESPACE
kubectl delete pv filebrowser-data-$NAMESPACE
kubectl delete ingressroute filebrowser -n $NAMESPACE
kubectl delete middleware filebrowser -n $NAMESPACE

rm -rf /opt/environment/filebrowser
mkdir -m 0777 -p /opt/environment/filebrowser

kubectl apply -f - << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  name: filebrowser
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: filebrowser
      app.kubernetes.io/instance: filebrowser
  template:
    metadata:
      labels:
        app.kubernetes.io/name: filebrowser
        app.kubernetes.io/instance: filebrowser
    spec:
      containers:
      - args: []
        image: filebrowser/filebrowser
        name: filebrowser
        command:
            - /filebrowser
            - --baseurl=/filebrowser
        volumeMounts:
        - mountPath: /srv
          name: filebrowser-data
      dnsConfig:
        searches:
        - cmf.criticalmanufacturing.com
      hostname: filebrowser
      restartPolicy: Always
      volumes:
      - name: filebrowser-data
        persistentVolumeClaim:
          claimName: filebrowser-data-$NAMESPACE
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  name: filebrowser
  namespace: $NAMESPACE
spec:
  ports:
  - name: "8080"
    port: 8080
    protocol: TCP
    targetPort: 80
  selector:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolume
metadata:
  labels:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  name: $NAMESPACE-filebrowser-data
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 10Gi
  hostPath:
    path: /opt/environment/filebrowser
  persistentVolumeReclaimPolicy: Retain
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  labels:
    app.kubernetes.io/name: filebrowser-data
    app.kubernetes.io/instance: filebrowser-data
  name: filebrowser-data-$NAMESPACE
  namespace: $NAMESPACE
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  selector:
    matchLabels:
        app.kubernetes.io/name: filebrowser-data-$NAMESPACE
        app.kubernetes.io/instance: filebrowser-data-$NAMESPACE
  storageClassName: ""
---
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  labels:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  name: filebrowser
  namespace: $NAMESPACE
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: PathPrefix(\`/filebrowser\`) && !PathPrefix(\`/apps/\`)
    middlewares:
    - name: filebrowser
      namespace: $NAMESPACE
    services:
    - kind: Service
      name: filebrowser
      namespace: $NAMESPACE
      port: 8080
---
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  labels:
    app.kubernetes.io/name: filebrowser
    app.kubernetes.io/instance: filebrowser
  name: filebrowser
  namespace: $NAMESPACE
spec:
  stripPrefix:
    prefixes:
    - /filebrowser
EOF

sleep 2

while true; do
  sleep 2
  kubectl logs $(kubectl get pod -n $NAMESPACE | grep filebrowser | cut -d' ' -f 1) -n $NAMESPACE --follow
done
