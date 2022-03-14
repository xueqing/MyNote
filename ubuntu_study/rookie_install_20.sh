# env: ubuntu 20.04

# install pre-requisite
sudo apt-get install -y vim git gitk git-gui curl net-tools

# config git account
## generate ssh key
ssh-keygen -t rsa -C "hj.chen@bmi-tech.com"
## start ssh-agent
eval $(ssh-agent -s)
## add key
ssh-add ~/.ssh/id_rsa
## add ssh key in ~/.ssh to your git account
## clone a project to test
git config --global user.name kiki
git config --global user.email hj.chen@bmi-tech.com # todo

# config git for easy use
git config --global alias.cpick cherry-pick
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.ss 'stash save'
git config --global alias.sl 'stash list'
git config --global alias.sp 'stash pop'
git config --global alias.unstage 'reset HEAD --'
git config --global alias.pullo 'pull origin'
git config --global alias.pusho 'push origin'

# install ssh-server for remote access
sudo apt-get install -y openssh-server

# install wireshark
sudo apt-get install -y wireshark
sudo groupadd wireshark
sudo chgrp wireshark /usr/bin/dumpcap
sudo chmod 4755 /usr/bin/dumpcap
sudo gpasswd -a kiki wireshark

# install mysql
sudo apt-get install -y mysql-server mysql-client

# install phpmyadmin
sudo apt-get install -y phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
## open localhost/phpmyadmin
## error: the mbstring extension is missing. please check your php configuration
## sudo apt-get -y install php-mbstring php-gettext
## sudo service apache2 restart

# install redis server
sudo apt-get install -y redis-server

# install RabbitMQ
## 1. Install RabbitMQ Server
## Install all necessary packages.
sudo apt-get install wget apt-transport-https -y
## Install RabbitMQ repository signing key.
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
## Add the RabbitMQ repository.
echo "deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang-22.x" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
## Install RabbitMQ Server.
sudo apt-get install rabbitmq-server -y --fix-missing
## Check status of the RabbitMQ service.
sudo systemctl status rabbitmq-server
## 2. Enable RabbitMQ Management Dashboard
## The management dashboard allows interaction with the processes and control activities on the server.
sudo rabbitmq-plugins enable rabbitmq_management
## Default user guest can only log in via localhost. Create an administrator account to access the dashboard. Make sure you modify the SecurePassword to your own password.
## create user
sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'
sudo rabbitmqctl list_user_permissions admin
## After enabling the plugins for the web management portal, you can go to your browser and access the page by through http://your_IP:15672. Example: http://192.0.2.11:15672.
## Login with admin as your username and your SecurePassword as your password. Make sure you modify the SecurePassword to your own password.

# install gcc/g++
sudo apt-get install -y gcc g++
## switch version
# sudo update-alternatives --config gcc
## delete version options
# sudo update-alternatives --remove gcc /usr/bin/gcc-4.5

# install docker
sudo apt-get install -y docker.io
## create docker user-group
sudo groupadd docker
## add kiki to docker user-group
sudo gpasswd -a kiki docker
## update docker user-group
newgrp docker
## test
docker version

# install gvm, namely go version manager
## install dependencies
sudo apt-get install -y curl git mercurial make binutils bison gcc build-essential
## download script https://github.com/moovweb/gvm/blob/master/binscripts/gvm-installer
chmod +x gvm-installer
./gvm-installer
## Go 1.5+ removed the C compilers from the toolchain and replaced them with one written in Go.
## Obviously, this creates a bootstrapping problem if you don't already have a working Go install.
## In order to compile Go 1.5+, make sure Go 1.4 is installed first.
## if error "Could not find bison" happens, exec `sudo apt-get install -y bison`
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
## install other versions for golang
gvm install go1.15
gvm install go1.17
## choose golang version
gvm use go1.17 [--default]
## list go versions
gvm list
## list all go versions available for download
gvm listall
## completely remove gvm and all installed Go versions and packages
# gvm implode