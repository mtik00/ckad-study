# CKA/D Study Environment

## Dependencies

Install the dependencies with [devbox](https://www.jetify.com/devbox/docs/installing_devbox/)

```shell
devbox install
```
## k3d

Create the cluster with:

```shell
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" --agents 2
```


