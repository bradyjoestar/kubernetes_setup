go get github.com/kubernetes-incubator/cri-tools/cmd/crictl

kubeadm init

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply --pod-network-cidr=10.244.0.0/16 -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
