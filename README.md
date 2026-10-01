This project deploys an intelligent observability stack on Amazon EKS. Rather than relying solely on Prometheus to fire raw alerts during cluster degradation, this architecture integrates the K8sGPT Operator to automatically diagnose Kubernetes misconfigurations in real-time. It intercepts system failures, queries an LLM backend for root cause analysis (RCA), and routes context-rich remediation steps directly to engineering queues to drastically reduce Mean Time To Recovery (MTTR).

## 1. Provision the Cluster and Operators

Initialize Terraform and provision the EKS cluster, VPC, and Helm releases for both Prometheus and K8sGPT.
```bash
cd terraform
terraform init
terraform apply -auto-approve
2. Authenticate and Configure AI
Update your local kubeconfig to interact with the new control plane:
aws eks --region ap-south-1 update-kubeconfig --name sre-aiops-cluster

Inject your AI provider credentials and configure the K8sGPT analyzer:

Bash
cd ../kubernetes
# Edit k8sgpt-secret.yaml with your API key and Slack webhook first
kubectl apply -f k8sgpt-secret.yaml
kubectl apply -f k8sgpt-config.yaml
3. Trigger Autonomous RCA
Deploy a deliberately misconfigured application to trigger a cluster failure:
kubectl apply -f broken-workload.yaml

Instead of manually digging through kubectl describe pod logs, query the autonomous diagnostics:
kubectl get results -n default -o yaml

K8sGPT will intercept the pod failure, identify the missing secret, and output the exact remediation commands required to restore service, mirroring the output routed to the configured Slack queue.

4. Cleanup
Destroy the infrastructure to halt all AWS billing:

cd ../terraform
terraform destroy -auto-approve
