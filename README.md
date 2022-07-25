# infra
This part of project contains code for creating k8s infra in yandex cloud. 

---
## Usage

copy example and set your variables
```
cp terraform.tfvars.example terraform.tfvars
```

for running infra-layer
```bash
terraform init
terraform get
terraform plan
terraform apply -auto-approve
```

for running dns-layer
```bash
terraform -chdir=terraform/dns-layer init
terraform -chdir=terraform/dns-layer plan
terraform -chdir=terraform/dns-layer apply -auto-approve
```

for destroying
```bash
terraform -chdir=terraform/dns-layer destroy -auto-approve
terraform destroy -auto-approve
```

---
## Installation

* terraform - [https://learn.hashicorp.com/tutorials/terraform/install-cli](https://learn.hashicorp.com/tutorials/terraform/install-cli).
* yandex.cloud provider - [https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs).
* yandex cli - [https://cloud.yandex.ru/docs/cli/operations/install-cli](https://cloud.yandex.ru/docs/cli/operations/install-cli).

## License
[MIT](https://choosealicense.com/licenses/mit/)