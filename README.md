## Cluster Kubernetes

Criar um cluster local Kubernetes `kind` utilizando `Terraform` para fazer o provisionamento.

Será utilizando o Kubernetes na versão 1.29.1

Pré-requisitos:

- [docker](https://www.docker.com/)
- [terraform](https://www.terraform.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

No Laboratório irei utilizar o Debian GNU/Linux 12 (bookworm) como referência:

```bash 
root@srv-debian:~# lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 12 (bookworm)
Release:        12
Codename:       bookworm
```

Instalando pacotes necessários:

```bash
apt update && apt install make curl -y
```

### Docker Engine

Instalando o Docker Engine:

- [Script de Instalação](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)

```bash
sudo apt update && sudo apt install -y curl
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
```

Verificando a versão:

```bash
docker --version
Docker version 25.0.3, build 4debf41
```

### Terraform

Instalação do Terraform:

- [Roteiro de Instalação](https://developer.hashicorp.com/terraform/install?product_intent=terraform#Linux)

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Verificando a versão:

```bash
terraform --version
Terraform v1.7.3
on linux_amd64
```

### Kubectl

Instalação do kubectl

- [Roteiro de Instalação](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)

```bash
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl
```

```bash
# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

```bash
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

```bash
sudo apt-get update
sudo apt-get install -y kubectl
```

Verificando a versão:

```bash
kubectl version --client
Client Version: v1.29.1
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
```


## Arquivo `Makefile`
Utilizado para facilitar a execução de comandos terraform.

Exemplo:
O comando `make plan` tem o mesmo efeito de `terraform -chdir=./provision plan`

|Comando | Equivalente |
|------ | ------ |
|make plan | terraform -chdir=./provision plan | 
|make init | terraform -chdir=./provision init |
|make create | terraform -chdir=./provision apply |
|make destroy | terraform -chdir=./provision destroy |


## Diretório `provision`
Os arquivos terraform ficam no diretório `provision`.

### Arquivo `version.tf`
Este arquivo possui o bloco `terraform` para indicar quais os providers necessários e quais suas versões.

| Provider | Versão |
| ------- | :----: |
| tehcyx/kind | 0.2.1 |
| hashicorp/kubernetes | 2.25.2 |
| hashicorp/helm | 2.12.1 |

### Arquivo `providers.tf`
Este arquivo informa para o terraform configurações para os providers.

|Provider|
|:------|
| kind |
| kubernetes |
| helm |

### Arquivo `variables.tf`
Este arquivo configura variáveis para serem utilizadas por outros arquivos.

Nome | Descriçao | Valor padrão configurado
-----| :-------: | ------
cluster_name | Nome do Cluster | cajuina
cluter_k8s_version | Versão do Kubernetes a ser instalado | kindest/node:v1.29.1

### Arquivo `cluster.tf`
Este é o "principal" arquivo para a criação do cluster.
É definido um cluster com o nome definido pela variável `cluster_name` que foi setada no arquivo `variables.tf`

## Utilização:

Baixar as dependências do Terraform:
`make init`

O comando bem sucedido deve retornar em sua mensagem o seguinte trecho:

    Terraform has been successfully initialized!

Para verificar o que será realizado:
`make plan`

Para criar o cluster:
`make create`

Responda a pergunta com `yes`

```
Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
``` 

O resultado com sucesso deve trazer a mensagem:

        kind_cluster.default: Creating...
        kind_cluster.default: Still creating... [10s elapsed]
        kind_cluster.default: Still creating... [20s elapsed]
        kind_cluster.default: Still creating... [30s elapsed]
        kind_cluster.default: Still creating... [40s elapsed]
        kind_cluster.default: Creation complete after 45s [id=cajuina-]

        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.



Verificar o cluster criado:

```
kubectl get nodes
```

```

NAME                    STATUS   ROLES           AGE   VERSION
cajuina-control-plane   Ready    control-plane   12m   v1.29.1
cajuina-worker          Ready    <none>          11m   v1.29.1
```

Removendo cluster:
`make destroy`

```
Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

```
kind_cluster.default: Destroying... [id=cajuina-]
kind_cluster.default: Destruction complete after 1s

Destroy complete! Resources: 1 destroyed.
```
