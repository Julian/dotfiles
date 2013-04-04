# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.provision :shell, :inline => 'sudo su vagrant -c /vagrant/bootstrap.sh'
end
