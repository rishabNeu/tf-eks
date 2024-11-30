# tf-eks
Using Terraform (IaC) for creating EKS infrastructure on AWS


## Talk to Cluster
- Need a bastion host deployed in public subnet
- Need to install aws cli and also configure it with dev user creds
- Need to install kubectl
- Need to run command to update the kubeconfig with the newly deployed EKS Cluster
```
# install kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client


# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update


# command to update the eks cluster's info in kubeconfig
aws eks --region <region-name> update-kubeconfig --name <cluster-name>

# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version


```