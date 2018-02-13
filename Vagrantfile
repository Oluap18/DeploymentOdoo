# -*- mode: ruby -*-
# vi: set ft=ruby :

#PUBLIC_KEY=File.read(File.expand_path('~/.ssh/id_rsa.pub')).strip

# define the number of Google Cloud instances to create
$num_vms = 4

Vagrant.configure("2") do |config|
   config.vm.box = "google/gce"
   
   (1..$num_vms).each do |i|
      config.vm.define "vm#{i}" do |node|
        node.vm.provider :google do |google|
          google.name = "vm#{i}"
          google.tags = ['http-server', 'https-server']
        end
      end
    end

  # Google clound VM instances properties
   config.vm.provider :google do |google, override|
      google.google_project_id = "group6-182510"
      google.google_client_email = "810361359414-compute@developer.gserviceaccount.com"
      google.google_json_key_location = "~/Desktop/SDB/Odoo/TP2/group6-key.json"
      google.zone="europe-west1-d"
      google.image = "ubuntu-1604-xenial-v20171212"
      google.machine_type = "n1-standard-8"

      override.ssh.username = "paulo"
      override.ssh.private_key_path = "~/.ssh/id_rsa"
   end

   config.vm.provision "shell", inline: <<-SHELL
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
     sudo apt-key fingerprint 0EBFCD88
     sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
     sudo apt-get -y update
     sudo apt-get -y install docker-ce
     sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-'uname -s'-'uname -m' -o /usr/local/bin/docker-compose
     sudo chmod +x /usr/local/bin/docker-compose
    SHELL
end