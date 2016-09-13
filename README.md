Quality Box
=======================

Provision virtual machines locally (Vagrant+VirtualBox) or in the cloud (Digital Ocean droplets) using Ansible for orchestration.  The Quality Box will be optimized for production hosting of MediaWiki


* Launch a droplet
* Destroy droplet
* Provision the machine


Installation
------------

* Install [Vagrant](https://www.vagrantup.com/)
* Optionally Install [VirtualBox](https://www.virtualbox.org/) if you want a GUI for your local virtual machine
* Install [Ansible 2.0](http://docs.ansible.com/ansible/intro_installation.html)
* Make sure your python path is configured correctly. For example:

```
    # On Ubuntu
    export PYTHONPATH=/usr/local/lib/python2.7/site-packages
    # On OS X
    export PYTHONPATH=/Library/Python/2.7/site-packages
```

* Copy vars.yml.dist to vars.yml and change the variables to your need.

Local Development
-----------------

* Change to the directory where you cloned this repo
* Issue a 'vagrant up'
* 'vagrant ssh' to get into the virtual machine

Digital Ocean configuration
---------------------------

Create a new API key on the [API access page](https://cloud.digitalocean.com/api_access). 
Add the api_token to `vars.yml`.


Playbooks
=========

launch.yml
----------

Launch and provision a new server on Digital Ocean.

```
    ansible-playbook -i hosts launch.yml
```

What this Playbook do for you?

- configure swap file
- install ufw, fail2ban
- configure ufw allow ports for SSH
- make sshd more secure: 
  - PermitRootLogin=no
  - PasswordAuthentication=no
  - AllowGroups=sudo
- config sudoers
- A WHOLE LOT MORE that needs to be documented

destroy.yml
-----------

Destroys a server on Digital Ocean.

```
    ansible-playbook -i hosts destroy.yml
```

provision.yml
-------------

Once you have an inventory file (mv hosts.example hosts and edit to your liking), you can use the provision.yml to roll out all the features of Quality Box

```
    ansible-playbook provision.yml --extra-vars 'wiki_hostname=wiki.example.com apache_user=www-data'
```


ensure_python.yml
-----------------

(do not use) For 16.04 support which comes with Python 3 by default while Ansible requires Python 2


Known issues
------------

* dopy 0.3.7 is broken (error "name 'DoError' is not defined").
  Downgrade use version 0.3.5 using `pip install dopy==0.3.5`.

* digital_ocean_domain is broken (error "'Domain' object has no attribute 'id'") when you run the plabook the second time.
  Keep the "DNS name" empty to avoid this error.
