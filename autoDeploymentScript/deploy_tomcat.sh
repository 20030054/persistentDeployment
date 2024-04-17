#!/bin/bash

# Prompt the user for the node name
read -p "Enter the name of the node to deploy the Tomcat web application: " node_name

# Prompt the user for the number of replicas
read -p "Enter the number of replicas for the deployment: " replicas

# Create a YAML file for the deployment
cat <<EOF >deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment
spec:
  replicas: $replicas
  selector:
    matchLabels:
      app: tomcat
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - $node_name
      containers:
      - name: tomcat-container
        image: tomcat:latest
        ports:
        - containerPort: 8080
EOF

# Create the deployment using kubectl
kubectl create -f deployment.yaml
