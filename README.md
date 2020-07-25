# bonParent

Independent parent project for holding common configuration and documentation for its children:
* https://github.com/frostmarked/bonGateway
* https://github.com/frostmarked/bonReplicaService
* https://github.com/frostmarked/bonLivestockService
* https://github.com/frostmarked/bonContentService

## Overview

Im going to create an over-engineered website for my cows!<br/>
Why? Learning by doing!

Eventually it will reside on https://bonlimousin.com and https://limousin.se <br/>
but so far nothing is there...<br/>
But! My production k8s cluster (or is it a development cluster??) is up and running on Scaleway<br>
http://bongateway.bonlimousin.393a4c58-1580-4f08-89d7-15f104acfc8e.nodes.k8s.fr-par.scw.cloud/

[JHipster](https://www.jhipster.tech/) and [JHipster JDL](https://www.jhipster.tech/jdl) will be the backbone in powering the below sketch of the planned architecture.<br/>
https://github.com/frostmarked/bonParent/blob/master/com-bonlimousin-jhipster-jdl.jdl

Hopefully I will make time to keep the documentation up-to-date of my findings during development with JHipster, good and OFI (opportunity for improvement). Also going to keep the project and its code as open as possible. 
Currently a few kubernetes files (secrets, config-maps) that is not in any repository.

The plan is to stay as close as possible to default and best practice, according to JHipster docs.<br/>
But every now and then Ill probably try something different. See [Slightly different trail](#differenttrail)

![Sketch of planned architecture](docs/balsamiq/overview.png)

## Projects
Purpose of each project and maybe a few notes about tech, beyond what can be read at [JHipster](https://www.jhipster.tech/) 

Sonar Cloud is setup for all projects
https://sonarcloud.io/organizations/frostmarked/projects

### Bon Gateway
UI that displays my cattle to the public.

Signed in mode for specfic users that get access to enhanced data and functions.

BFF (Backend-for-frontend) setup so that the APIs can provide aggregated data from the downstream services.

https://github.com/frostmarked/bonGateway

![](https://github.com/frostmarked/bonGateway/workflows/Bon%20Gateway%20CI/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=frostmarked_bonGateway&metric=alert_status)](https://sonarcloud.io/dashboard?id=frostmarked_bonGateway)

### Bon Replica Service
Provides a clone of data from the central swedish registry for domestic animals.

https://github.com/frostmarked/bonReplicaService

![](https://github.com/frostmarked/bonReplicaService/workflows/Bon%20Replica%20Service%20CI/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=frostmarked_bonReplicaService&metric=alert_status)](https://sonarcloud.io/dashboard?id=frostmarked_bonReplicaService)

### Bon Livestock Service
Additional data about cows that is of more or less interest. e.g. images etc

https://github.com/frostmarked/bonLivestockService

![](https://github.com/frostmarked/bonLivestockService/workflows/Bon%20Livestock%20Service%20CI/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=frostmarked_bonLivestockService&metric=alert_status)](https://sonarcloud.io/dashboard?id=frostmarked_bonLivestockService)

### Bon Content Service
Very small and simple CMS that can hold some kind of newsworthy text.

https://github.com/frostmarked/bonContentService

![](https://github.com/frostmarked/bonContentService/workflows/Bon%20Content%20Service%20CI/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=frostmarked_bonContentService&metric=alert_status)](https://sonarcloud.io/dashboard?id=frostmarked_bonContentService)

## Slightly different trail
<a name="differenttrail"></a>

### Parent project
This project, bonParent, i think is a better way of keeping track of shared files for and from JHipster that dont belong in any specfic project. It also give me a place to gather my documentation that is not project specfic. And as a bonus I could build all project using standard maven mechanics. Why would I do that? Well, in the future I plan to create end-to-end tests in this project.

### Kubernetes
One database to rule them all. By default I get 4 postgresql and then my computer dies... <br/>
Locally and in production ill be using one db with 4 schemas.<br/>
Prod environmet is hosted by https://www.scaleway.com/ and provides managed kubernetes and managed postgresql.<br/>
https://github.com/frostmarked/bonParent/tree/master/k8s

PullPolicy is set to always. Not sure if that is necessary or good.<br>
Anyway, the plan was to always run version latest and just redploy by doing
```
kubectl rollout restart deployment/bongateway -n bonlimousin
```
if it exists a newer version

### Docker-compose for bonGateway
WIP: Made my own docker-compose file for running all docker images except the gateway in some hybrid mode so they can communicate. Still need some testing ...<br/>
Why? Lazy way of starting all others apps so development can begin and end faster. 

### GraphQL
Currently the plan is to make use of GraphQL. The schema is a pure translation of the websites public OAS. That is built using [Doing API-First development](https://www.jhipster.tech/doing-api-first-development/).

Using https://github.com/IBM/openapi-to-graphql/ for translation of OAS.

Using https://www.apollographql.com/docs/angular/ as client-side lib<br>
plus https://graphql-code-generator.com/ for generating typescript from graphql schema

Using https://www.graphql-java-kickstart.com/spring-boot/ as server-side lib<br>
plus https://github.com/kobylynskyi/graphql-java-codegen/tree/master/plugins/maven for generating java from schema

**Note** 
GraphQl with kickstart breaks regular test environment.
Handle for now according to issue on github
https://github.com/graphql-java-kickstart/graphql-spring-boot/issues/230
```
spring:
  autoconfigure:
    exclude:
      - graphql.kickstart.spring.web.boot.GraphQLWebAutoConfiguration
      - graphql.kickstart.spring.web.boot.GraphQLWebsocketAutoConfiguration
```

and use @GraphQLTest annotation on test class

### Only admins can register new users
Disabled public registration of new users. The website will have a signed in mode eventually but I only want certain people to have access.<br/>
By toggling a boolean spring property its back to default.<br/>
TODO: Future version should have some kind of invite solution.

### Maven CI Friendly Versions
Implemented https://maven.apache.org/maven-ci-friendly.html

### GitHub Actions
Modified the result from
```
jhipster ci-cd
```

The pipeline take different routes depending on if its triggered by a release or not.<br/>
Except for difference in versioning of artifact and image the release flow will rollout a new version to given kubernetes cluster.

### Liquibase with spring profile prod
Puh... the app did not start... why why why???

You might think it did not start due to something with eureka and the discovery client. 
After all the last bit of information you get from the log is:  
```
2020-07-25 09:16:18.793  INFO 1 --- [nfoReplicator-0] com.netflix.discovery.DiscoveryClient    : Saw local status change event StatusChangeEvent [timestamp=1595668578792, current=UP, previous=STARTING]
2020-07-25 09:16:18.806  INFO 1 --- [nfoReplicator-0] com.netflix.discovery.DiscoveryClient    : DiscoveryClient_BONGATEWAY/bongateway:f33e529ccc6fdd5eebba10e2679c4082: registering service...
2020-07-25 09:16:19.099  INFO 1 --- [nfoReplicator-0] com.netflix.discovery.DiscoveryClient    : DiscoveryClient_BONGATEWAY/bongateway:f33e529ccc6fdd5eebba10e2679c4082 - registration status: 204
2020-07-25 09:16:19.205  INFO 1 --- [           main] c.b.gateway.config.WebConfigurer         : Web application configuration, using profiles: prod
2020-07-25 09:16:19.206  INFO 1 --- [           main] c.b.gateway.config.WebConfigurer         : Web application fully configured
2020-07-25 09:16:27.795  INFO 1 --- [trap-executor-0] c.n.d.s.r.aws.ConfigClusterResolver      : Resolving eureka endpoints via configuration
2020-07-25 09:16:42.797  INFO 1 --- [trap-executor-0] c.n.d.s.r.aws.ConfigClusterResolver      : Resolving eureka endpoints via configuration
2020-07-25 09:16:43.523  WARN 1 --- [scoveryClient-0] c.netflix.discovery.TimedSupervisorTask  : task supervisor timed out

java.util.concurrent.TimeoutException: null
	at java.base/java.util.concurrent.FutureTask.get(Unknown Source)
	at com.netflix.discovery.TimedSupervisorTask.run(TimedSupervisorTask.java:68)
	at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
	at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
	at java.base/java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
	at java.base/java.lang.Thread.run(Unknown Source)

```

Dont be fooled like me...
Its actually liquibase that found a lock. 
But! the default setup from jhipster makes that very important piece of info go away in silence. 
Or should I blame Spring Boot? or Liquibase?...
Anyway setting logging in prod profile to DEBUG solved the mystery.

```
2020-07-25 09:25:29.166  INFO 1 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangeloglock
2020-07-25 09:25:29.172  INFO 1 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT COUNT(*) FROM public.databasechangeloglock
2020-07-25 09:25:29.180  INFO 1 --- [           main] liquibase.executor.jvm.JdbcExecutor      : SELECT LOCKED FROM public.databasechangeloglock WHERE ID=1
2020-07-25 09:25:29.187  INFO 1 --- [           main] l.lockservice.StandardLockService        : Waiting for changelog lock....
```

Probably the container/app got terminated in a bad state. Unlock Liquibase with:
```
UPDATE DATABASECHANGELOGLOCK SET LOCKED=false, LOCKGRANTED=null, LOCKEDBY=null where ID=1;
```

From now on I will explicitly set logging level in prod profile to: 

```
logging:
  level:
    ROOT: INFO
    io.github.jhipster: INFO
    com.bonlimousin.gateway: INFO
    liquibase: INFO
```

## What in the name of some norse god!?
**Why did I use camelCase in jdl basename???**<br/>
I should have used lower case and gotten rid of case sensitivity confusions<br>
and sometimes its just ugly...

## Build
GitHub Actions will be the main carrier of builds.<br>
Every now or then when I build locally be sure to give it some extra memory...
```
./mvnw -Pprod verify jib:dockerBuild -DargLine="-Xmx1024m"
```

And to publish the images to docker hub
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

How is it going?
```
kubectl get pods -n bonlimousin
```
