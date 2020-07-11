# bonParent

Independent parent project for holding common
* config
* build
* docs

## Build

```
./mvnw -Pprod verify jib:dockerBuild -DargLine="-Xmx1024m"
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

