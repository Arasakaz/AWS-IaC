<!-- GitLab Server -->
# GitLab Server

```bash
openssl genrsa -out "/etc/gitlab/ssl/X.X.X.X.key" 2048
sudo openssl req -net -key "/etc/gitlab/ssl/X.X.X.X.key" -out "/etc/gitlab/ssl/X.X.X.X.csr"
openssl x509 -req -days 365 -in "/etc/gitlab/ssl/X.X.X.X.csr" --signkey "/etc/gitlab/ssl/X.X.X.X.key" -out "/etc/gitlab/ssl/X.X.X.X.crt" -extfile <(printf "subjectAltName=IP:X.X.X.X")
```

<!-- GitLab Runners -->
# GitLab Runners
Gitlab runners are used by Gitlab to carry out tasks and procedures. Follow the short guide below on how to install, set up and register our runner software.

## Install GitLab runner
```bash
curl -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/deb/gitlab-runner_amd64.deb"
sudo dpkg -i gitlab-runner_amd64.deb
SERVER=10.30.1.100
PORT=443
sudo mkdir /etc/gitlab-runner/certs
CERTIFICATE=/etc/gitlab-runner/certs/${SERVER}.crt
sudo openssl s_client -connect ${SERVER}:${PORT} -showcerts </dev/null 2>/dev/null | sed -e '/-----BEGIN/,/-----END/!d' | sudo tee "$CERTIFICATE" >/dev/null
```

## Register runner
We now need to register our runner in the Gitlab front end. To do this:
1. Navigate to our project page [here](https://10.30.1.100/foundation/terraform)
2. On the toolbar (left edge of page) select 'Settings' -> 'CI/CD'
3. Click the 'Expand' button on the 'Runners' section
4. Select the 'New project runner' button
5. Select the options as needed, ensuring to select the 'Run untagged jobs' checkbox
6. Click the 'Create runner' button
7. Copy the token from the next page for the following command:
```bash
TOKEN=< insert token here >
sudo gitlab-runner register --url https://10.30.1.100 --token $TOKEN --tls-ca-file="$CERTIFICATE"
```
### Verify connection
```bash
echo | sudo openssl s_client -CAfile /etc/gitlab-runner/certs/10.30.1.100.crt -connect 10.30.1.100:443 -servername 10.30.1.100
```

## Install Terraform, Ansible, Packer
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
sudo apt-get update && sudo apt-get install packer
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
sudo systemctl daemon-reload
```

## Copy Terraform mirror and SSH keys from old volume to new volume
This section was applied when downsizing EBS volumes of the old runners, and copying over critical files. The old volume was detached from the old instance, and attached to the new instance via the AWS console, while both instances are stopped. After re-running the new instance, the command `lsblk` should list the old volume attached under `nvme1n1p1` though this may differ.
```bash
sudo mkdir /mnt/volume
sudo mount /dev/nvme1n1p1 /mnt/volume/
sudo cp -r /mnt/volume/home/gitlab-runner/terraform-mirror /home/gitlab-runner/
sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/
sudo cp -r /mnt/volume/home/gitlab-runner/.ssh /home/gitlab-runner/
sudo chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.ssh/
```