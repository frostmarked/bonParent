#!/bin/bash
# Files are ordered in proper order with needed wait for the dependent custom resource definitions to get initialized.
# Usage: bash kubectl-apply.sh

usage(){
 cat << EOF

 Usage: $0 -f
 Description: To apply k8s manifests using the default \`kubectl apply -f\` command
[OR]
 Usage: $0 -g
 Description: To delete k8s manifests using the default \`kubectl delete -f\` command
[OR]
 Usage: $0 -a
 Description: To apply app k8s manifests using the default \`kubectl apply -f\` command
[OR]
 Usage: $0 -b
 Description: To delete app k8s manifests using the default \`kubectl delete -f\` command
[OR]
 Usage: $0 -c
 Description: To apply infra k8s manifests using the default \`kubectl apply -f\` command
[OR]
 Usage: $0 -d
 Description: To delete infra k8s manifests using the default \`kubectl delete -f\` command
[OR]
 Usage: $0 -k
 Description: To apply k8s manifests using the kustomize \`kubectl apply -k\` command
[OR]
 Usage: $0 -s
 Description: To apply k8s manifests using the skaffold binary \`skaffold run\` command

EOF
exit 0
}

logSummary() {
    echo ""
        echo "#####################################################"
        echo "Please find the below useful endpoints,"
        echo "JHipster Console - http://jhipster-console.bonlimousin.limousin.se"
        echo "Gateway - http://bongateway.bonlimousin.limousin.se"
        echo "#####################################################"
}

default() {
    suffix=k8s
    kubectl apply -f namespace.yml
    kubectl apply -f bonconfig-${suffix}/
    kubectl apply -f ../scaleway/bonconfig-${suffix}/
    kubectl apply -f registry-${suffix}/
    kubectl apply -f console-${suffix}/
    kubectl apply -f messagebroker-${suffix}/
    kubectl apply -f bongateway-${suffix}/
    kubectl apply -f boncontentservice-${suffix}/    
    kubectl apply -f bonlivestockservice-${suffix}/
    kubectl apply -f bonreplicaservice-${suffix}/
}

defaultdelete() {
    suffix=k8s        
    kubectl delete -f bongateway-${suffix}/
    kubectl delete -f boncontentservice-${suffix}/    
    kubectl delete -f bonlivestockservice-${suffix}/
    kubectl delete -f bonreplicaservice-${suffix}/
    kubectl delete -f messagebroker-${suffix}/
    kubectl delete -f console-${suffix}/
    kubectl delete -f registry-${suffix}/
    kubectl delete -f ../scaleway/bonconfig-${suffix}/
    kubectl delete -f bonconfig-${suffix}/
    kubectl delete -f namespace.yml
}

defaultinfra() {
    suffix=k8s
    kubectl apply -f namespace.yml
    kubectl apply -f bonconfig-${suffix}/
    kubectl apply -f ../scaleway/bonconfig-${suffix}/
    kubectl apply -f registry-${suffix}/
    kubectl apply -f console-${suffix}/
    kubectl apply -f messagebroker-${suffix}/
}

defaultdeleteinfra() {
    suffix=k8s
    kubectl delete -f messagebroker-${suffix}/
    kubectl delete -f console-${suffix}/
    kubectl delete -f registry-${suffix}/
    kubectl delete -f ../scaleway/bonconfig-${suffix}/
    kubectl delete -f bonconfig-${suffix}/
    kubectl delete -f namespace.yml
}

defaultapps() {
    suffix=k8s    
    kubectl apply -f bongateway-${suffix}/
    kubectl apply -f boncontentservice-${suffix}/    
    kubectl apply -f bonlivestockservice-${suffix}/
    kubectl apply -f bonreplicaservice-${suffix}/
}

defaultappsdelete() {
    suffix=k8s        
    kubectl delete -f bongateway-${suffix}/
    kubectl delete -f boncontentservice-${suffix}/    
    kubectl delete -f bonlivestockservice-${suffix}/
    kubectl delete -f bonreplicaservice-${suffix}/    
}

defaultrolloutapps() {
    kubectl rollout restart deployment/bongateway -n bonlimousin
    kubectl rollout restart deployment/boncontentservice -n bonlimousin
    kubectl rollout restart deployment/bonlivestockservice -n bonlimousin
    kubectl rollout restart deployment/bonreplicaservice -n bonlimousin
}

kustomize() {
    kubectl apply -k ./
}

scaffold() {
    // this will build the source and apply the manifests the K8s target. To turn the working directory
    // into a CI/CD space, initilaize it with `skaffold dev`
    skaffold run
}

[[ "$@" =~ ^-[abcdfgrks]{1}$ ]]  || usage;

while getopts ":abcdfgrks" opt; do
    case ${opt} in
    f ) echo "Applying default \`kubectl apply -f\`"; default ;;
    g ) echo "Deleting default \`kubectl delete -f\`"; defaultdelete ;;
    a ) echo "Applying apps \`kubectl apply -f\`"; defaultapps ;;
    b ) echo "Deleting apps \`kubectl delete -f\`"; defaultappsdelete ;;
    c ) echo "Applying infra \`kubectl apply -f\`"; defaultinfra ;;
    d ) echo "Deleting infra \`kubectl delete -f\`"; defaultdeleteinfra ;;
    r ) echo "Rollout restart default apps deplyments \`kubectl rollout restart\`"; defaultrolloutapps ;;
    k ) echo "Applying kustomize \`kubectl apply -k\`"; kustomize ;;
    s ) echo "Applying using skaffold \`skaffold run\`"; scaffold ;;
    \? | * ) usage ;;
    esac
done

logSummary
