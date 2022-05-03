# yc-k8s-infra
This project contains code for creating k8s infra in yandex cloud. 

---
## Usage

copy example and set your variables
```
cp terraform.tfvars.example terraform.tfvars
```

for running 
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

for destroying
```bash
terraform destroy -auto-approve
```

---
## Installation

* terraform - [https://learn.hashicorp.com/tutorials/terraform/install-cli](https://learn.hashicorp.com/tutorials/terraform/install-cli).
* yandex.cloud provider - [https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs).

## License
[MIT](https://choosealicense.com/licenses/mit/)