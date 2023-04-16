# Install RKE2 with Cilium enabled
In this repository you will find the information how to install [RKE2](https://docs.rke2.io/), also known as Rancher Government, with [Cilium](https://cilium.io/) as CNI. The virtual hardware will be installed using [Terraform](https://www.terraform.io/) and the [Libvirt provider](https://github.com/dmacvicar/terraform-provider-libvirt).

The cluster installation is executed using the Ansible code from [Rancher Federal](https://github.com/rancherfederal/rke2-ansible). I cloned that git repo and already created a cluster configuration (my-cluster) with the settings I prefer.

# Steps
* Install the machines
  * `terraform init`
  * `terraform plan`
  * `terraform apply`
* Generate inventory file
  * `sudo ./generate_inventory.sh > rke2-ansible/inventory/my-cluster/hosts.ini`
* Install cluster
  * `cd rke2-ansible`
  * `ansible-galaxy collection install -r requirements.yml`
  * `ansible-playbook site.yml -i inventory/my-cluster/hosts.ini`

# Extra info
The Cilium configuration can be modified in rke2-ansible/manifests/cilium.yaml. In rke2-ansible/inventory/my-cluster/group_vars the RKE2 configuration can be altered.

As root, execute the following commands on the master to include the Rancher binary location in your PATH and get kubectl command completion working

```lang=shell
ln -s /etc/rancher/rke2/rke2.yaml ${HOME}/.kube/config
chmod 600 ${HOME}/.kube/config
ln -s /var/lib/rancher/rke2/agent/etc/crictl.yaml /etc/crictl.yaml

RANCHER_BINDIR=$(echo /var/lib/rancher/rke2/data/*/bin)
export PATH="${PATH}:${RANCHER_BINDIR}"
kubectl completion bash > ~/.kube/completion.bash.inc
source <(kubectl completion bash)

echo "export PATH=${PATH}" >> ${HOME}/.bashrc
echo 'source ${HOME}/.kube/completion.bash.inc' >> ${HOME}/.bashrc
```
