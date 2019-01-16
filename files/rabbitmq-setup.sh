
wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq-erlang/debian xenial main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
sudo apt-get update -y
sudo apt-get install rabbitmq-server -y
sudo service rabbitmq-server start
sudo rabbitmq-plugins enable rabbitmq_management

