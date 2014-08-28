deploy_gitlab
=============

install a gitlab on ubuntu server, base on https://gitlab.com/gitlab-org/cookbook-gitlab/tree/master but use knife solo instead

1. upload your public key to your server `ssh-copy-id ubuntu@ip`

2. git clone this project, and bundle install

3. `knife solo prepare ubuntu@ip` this will install chef on server, and also will generate a file named ip.json

4. change nodes/ip.json(refering nodes/vagrant.json)

5. `knife solo cook ubuntu@ip`

6. if all go well, open url in your browser (http://ip), the default username and password is root/5iveL!fe
