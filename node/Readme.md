after run the node_pre.sh, now you can use the following command as root to join the cluster:

kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>
