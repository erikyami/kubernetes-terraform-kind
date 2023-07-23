## Cluster Kubernetes

Pré-requisitos:

- [docker](https://www.docker.com/)
- [terraform](https://www.terraform.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)


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

### Arquivo `providers.tf`
Este arquivo informa para o terraform configurações para os providers.

### Arquivo `variables.tf`
Este arquivo configura variáveis para serem utilizadas por outros arquivos.

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
cajuina-control-plane   Ready    control-plane   83s   v1.26.3
cajuina-worker          Ready    <none>          62s   v1.26.3
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