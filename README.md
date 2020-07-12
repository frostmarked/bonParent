# bonParent

Independent parent project for holding common
* config
* build
* docs

## Build

```
./mvnw -Pprod verify jib:dockerBuild -DargLine="-Xmx1024m"
```

```
docker image tag bongateway frostmark/bongateway
docker push frostmark/bongateway
docker image tag boncontentservice frostmark/boncontentservice
docker push frostmark/boncontentservice
docker image tag bonlivestockservice frostmark/bonlivestockservice
docker push frostmark/bonlivestockservice
docker image tag bonreplicaservice frostmark/bonreplicaservice
docker push frostmark/bonreplicaservice
```

## Run

### docker-compose
Intended for local testing

### kubernetes
Common config of most. 
Prepaired for setup of configmap and secrets for different cloud managed k8s and db

Use bonlimousin k8s context on Scaleway cluster
```
export KUBECONFIG_SAVED=$HOME/.kube/config
export KUBECONFIG=$KUBECONFIG_SAVED:$HOME/myfolder/myprojects/bonlimousin_com/jhipworkspace/bonParent/k8s/scaleway/kubeconfig-k8s-bonlimousin.yml
kubectl config use-context admin@ksbonlimousin
```

Redeploy the apps. Pull policy is set to always
```
kubectl rollout restart deployment/bongateway -n bonlimousin
kubectl rollout restart deployment/boncontentservice -n bonlimousin
kubectl rollout restart deployment/bonlivestockservice -n bonlimousin
kubectl rollout restart deployment/bonreplicaservice -n bonlimousin
```

```
kubectl get pods -n bonlimousin
```
