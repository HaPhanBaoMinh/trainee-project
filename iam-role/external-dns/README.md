# external-dns 

Download external-dns manifest
```
helm install external-dns \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=external-dns-dev \
  oci://registry-1.docker.io/bitnamicharts/external-dns
```

Create IAM policy for external-dns
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "*"
    }
  ]
}
```

```bash
aws iam create-policy \
  --policy-name ExternalDNSPolicy \
  --policy-document file://externaldns-policy.json
```

Attach IAM policy to the service account
```bash
eksctl create iamserviceaccount \
  --name external-dns \
  --namespace default \
  --cluster opwat-trainee-project-cluster \
  --attach-policy-arn arn:aws:iam::026090549419:policy/ExternalDNSPolicy \
  --approve \
  --override-existing-serviceaccounts \
  --region ap-southeast-1 
``` 

Install external-dns
```bash
helm upgrade --install external-dns \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=external-dns-dev \
  --set serviceAccount.name=external-dns \
  oci://registry-1.docker.io/bitnamicharts/external-dns 
```
