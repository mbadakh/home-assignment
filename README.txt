# STEP 1:
# provision EC2 instance to hold my non-containerized gitlab server: specs: m5xlarge
- install dependencies
- install gitlab ce server as a systemd service
- sign in using root
- set up a new user with admin priviledges
- create an empty git repository

sources: 
  - https://about.gitlab.com/install/#debian

---
# STEP 2:
# provision EC2 instance to host my non containerized gitlab-runner (USED TO RUN PIPELINES) specs: t2micro
- install dependecies
- add gitlab-runner repo
  - curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
- activate installation and update
  - sudo apt-get install gitlab-runner
  - sudo apt-get update
  - sudo apt-get install gitlab-runner
- register runner
  - sudo gitlab-runner register
  - paste url and token from gitlab server
  - choose shell executor

sources: 
  - install runner: https://docs.gitlab.com/runner/install/linux-repository.html
  - register runner: https://docs.gitlab.com/runner/register/

---
# STEP 3:
# set up container registery + credentials to access it
- skipped this step in order to complete vault integration in time. will complete if extra time remains


---
# STEP 4:
# provision an ec2 instance to host my vault server + set up a key value pair to hold my container registry authentication

# install vault
- install dependencies 
- install vault
# configure server
- write deployment server config file vault-config.hcl
- vault server -config=vault-config.hcl
- vault operator init -key-shares=1 -key-threshold=1
- export VAULT_TOKEN=MY-TOKEN
- vault operator unseal: unseal token
- expose port 8200 in security groups
# setup secret
- set up secret: vault kv put secret/docker-hub-token key=value
- define read policy specific path read only

sources:
  - install vault server: https://developer.hashicorp.com/vault/docs/install && https://www.hashicorp.com/official-packaging-guide
  - configure server: https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-dev-server
  - define admin policy: https://developer.hashicorp.com/vault/tutorials/policies/policies
  - set up secret: https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-first-secret

---
# STEP 5
# build python flask application + dockerfile
- i decided to make a flask application that has button, when pressed fetches a token from vault and displays it dynamically:
  - code app
  - integrate with vault:
    - wanted to deploy the app on ec2 instance, and fetch secret in vault from web application, but not enough time to complete
  - code dockerfile
  - upload to git repository

---
# STEP 6 
# build pipeline
- install vault agent and set up authentication with server
- pull repository
- build new image
- set up vault on runner with proper roles and policies:
  - create policy that permits read capabilities to a specific endpoint /secret/docker-hub-token
  - create role to that policy, 60 seconds, specific issuer, specific user...
  - create jwt authentication endpoint
- get registry token from vault
- push to gitlab container registry


sources:
  - set up vault agent: https://www.bogotobogo.com/DevOps/Terraform/Hashicorp-Vault-agent.php
  - set up vault integration for gitlab ci/cd: https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/ 
