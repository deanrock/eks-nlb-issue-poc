pods=$(kubectl get pods | grep tcpdump | awk '{print $1}')

for pod in $pods
do
    kubectl cp $pod:/tmp/dump $pod.pcap
done
