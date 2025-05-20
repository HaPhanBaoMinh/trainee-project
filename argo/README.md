# ArgoCD 

1. Install ArgoCD
```bash 
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -f values.yaml -n default

helm upgrade argocd argo/argo-cd -f values.yaml
```

Expose services
```bash 
kubectl port-forward svc/argocd-server 8080:443
```

Change the password
```bash 
argocd login <ARGOCD_SERVER> --username admin --password <OLD_PASSWORD>
argocd account update-password 
```

2. Install ArgoCD updater 

Create iam policy for argocd-image-updater
```bash
aws iam create-policy \
  --policy-name argocd-image-updater-policy \
  --policy-document file://argocd-image-updater-policy.json
```

Create role for argocd-image-updater
```bash
aws iam create-role \
  --role-name argocd-image-updater-role \
  --assume-role-policy-document file://argocd-image-updater-trust-policy.json
```

Create service account 
```bash 
eksctl create iamserviceaccount \
  --name argocd-image-updater \
  --namespace argocd \
  --cluster opwat-trainee-project-cluster \
  --attach-policy-arn arn:aws:iam::026090549419:policy/argocd-image-updater-policy \
  --approve \
  --override-existing-serviceaccounts \
  --region ap-southeast-1 
```

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd-image-updater argo/argocd-image-updater -f argocd-image-updater-values.yaml
```

3. Config SOPS
Create KMS key
```bash
aws kms create-key \
  --description "SOPS KMS key" \
  --key-usage ENCRYPT_DECRYPT \
  --output json

aws kms put-key-policy \
  --key-id c93bf4da-0437-47d4-bdbe-86af63801a7a \
  --policy-name default \
  --policy file://sops-kms-key-policy.json
```

```
aws iam create-policy \
  --policy-name ArgoCDKMSDecryptPolicy \
  --policy-document file://kms-decrypt-policy.json
```

```
eksctl create iamserviceaccount \
  --name argocd-repo-server \
  --namespace default \
  --cluster opwat-trainee-project-cluster \
  --attach-policy-arn arn:aws:iam::026090549419:policy/ArgoCDKMSDecryptPolicy \
  --approve \
  --override-existing-serviceaccounts
```

.sops.yaml
```yaml
creation_rules:
  - encrypted_regex: '^(data|stringData)$'
    kms: ""
``` 

```yaml
sops -e -i secret.yaml
```
