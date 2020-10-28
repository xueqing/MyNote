# install pre-requisite
sudo apt-get install -y vim git gitk git-gui curl

# config git account
## generate ssh key
ssh-keygen -t rsa -C "your_email@example.com"
## start ssh-agent
eval $(ssh-agent -s)
## add key
ssh-add ~/.ssh/id_rsa
## add ssh key in ~/.ssh to your git account
## clone a project to test
git config --global user.name kiki
git config --global user.email xxx # todo

# config git for easy use
git config --global alias.cpick cherry-pick
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.ss 'stash save'
git config --global alias.sp 'stash pop'
git config --global alias.unstage 'reset HEAD --'

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
## install erlang dependency
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install -y erlang
## install mq
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get install -y rabbitmq-server
## create user
sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin '.*' '.*' '.*'
sudo rabbitmqctl list_user_permissions admin

# install gcc/g++-4.8
sudo apt-get install -y gcc-4.8 gcc-4.8-multilib g++-4.8 g++-4.8-multilib
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5.4 40
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 40
# switch version
sudo update-alternatives --config gcc
# delete version options
# sudo update-alternatives --remove gcc /usr/bin/gcc-4.5