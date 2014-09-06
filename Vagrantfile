# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, :inline => 'sudo su vagrant -c /vagrant/bootstrap.sh'
end
