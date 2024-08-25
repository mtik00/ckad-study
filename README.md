# CKA/D Study Environment

## Dependencies

k3d:

```shell
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
```
kubectl:

```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
Helm:

```shell
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## k3d

Create the cluster with:

```shell
k3d cluster create ckad-study --api-port 6550 -p "8081:80@loadbalancer" --agents 2
```

When you're done, delete the cluster:

```shell
k3d cluster delete ckad-study
```
