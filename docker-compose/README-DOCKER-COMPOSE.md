# JHipster generated Docker-Compose configuration

## Usage

Launch all your infrastructure by running: `docker-compose up -d`.

## Configured Docker services

### Service registry and configuration server:

- [JHipster Registry](http://localhost:8761)

### Applications and dependencies:

- bonContentService (microservice application)
- bonContentService's postgresql database
- bonContentService's elasticsearch search engine
- bonGateway (gateway application)
- bonGateway's postgresql database
- bonLivestockService (microservice application)
- bonLivestockService's postgresql database
- bonReplicaService (microservice application)
- bonReplicaService's postgresql database

### Additional Services:

- Kafka
- Zookeeper
- [JHipster Console](http://localhost:5601)
- [Zipkin](http://localhost:9411)
