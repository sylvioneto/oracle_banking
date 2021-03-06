# Oracle Banking
Use the terraform module in this repository to create infrastructure resources required to run Oracle Banking.

This IaC will create:
- Network
- Public and Private subnets
- Security rules
- Database System with FCUBS database
- Kubernetes cluster

# Usage

## Terraform
```hcl
provider "oci" {
  region           = "ca-toronto-1"

  // from your Oracle Cloud account
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa"
  user_ocid        = "ocid1.user.oc1..aaaaaaabbbbbbbbbbbbbb"
  fingerprint      = "99:99:99:32:f7:07:e1:a1:31:c1:29:12:b8:99:63:b6"

  // api key
  private_key_path = "C:\\github\\oracle_banking\\keys\\oracleidentitycloudservice_sylvio.pedroza.pem"
}

module "fcubs_sandbox" {
  source = "git::https://github.com/sylvioneto/oracle_banking.git//terraform"

  compartment_id      = "ocid1.compartment.oc1..aaaaaaaacccccccccccccc"
  domain              = "sneto.ca"
  environment         = "sandbox"
  ssh_public_key_path = "C:\\Users\\sylvi\\Downloads\\github\\oracle_banking\\keys\\ssh-key0.key.pub"
}
```

## Helm

### Pre req
```
$ kubectl apply -f helm\namespaces.yaml
$ kubectl apply -f helm\oke-admin-service-account.yaml
```

### Ingress Controller
```
$ helm repo update
$ helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 3.23.0 -n nginx -f helm/ingress-nginx.yaml
```

