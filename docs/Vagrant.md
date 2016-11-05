---
title: Vagrant
permalink: /Vagrant/
---

The QualityBox comes with a Vagrantfile so that you can simply 'vagrant up' in the source directory. The full build will take approximately 45 minutes, but it's a one time procedure until you destroy the box.  If we develop a 'base box' (pre-built box image) for the QualityBox, then initial build times will decrease accordingly.


Pre-requisites
--------------

You must have [VirtualBox](https://freephile.org/wiki/VirtualBox "wikilink") installed, and Vagrant to run `vagrant up`.

How
---

provision.yml originally had `remote_user: root`<sup>[1](#footnote1)</sup> which caused permission errors as Vagrant tried to switch to the root user (or was it the vagrant user?) during the build. In any event, once this setting was removed from provision.yml, the build succeeded. The development of Vagrant's ssh configuration has been active over the 2015, 2016 period and due to the multiple ways in which 'user' can be specified, as well as scoping and precedence rules <sup>[2](#footnote2)</sup>, can lead to a very confusing / buggy implementation. Hopefully we've solved these issues in QualityBox.

1.  <http://tjelvarolsson.com/blog/how-to-create-automated-and-reproducible-work-flows-for-installing-scientific-software/>
2.  see <https://stackoverflow.com/review/suggested-edits/13372986> for a method to add your own key.
3.  <https://docs.ansible.com/ansible/guide_vagrant.html>
4.  <https://www.vagrantup.com/docs/provisioning/ansible_intro.html>
5.  <https://www.vagrantup.com/docs/provisioning/ansible.html>

Vagrant automatically adds a key that it creates in your .vagrant directory (e.g. .vagrant/machines/default/virtualbox/private_key) Vagrant will automatically create the 'vagrant' user with sudo privs and key-based login to the local machine. We just need to be sure that our playbooks can run against the virtual machine with our Ansible deploy user (currently \$USER, but should be 'qb').

Run "locally" or from the control host?
---------------------------------------

Note that Vagrant offers both 'ansible' and 'ansible_local' provisioners <sup>[3](#footnote3)</sup>. The first executes ansible from the control host. The latter ('local') executes Ansible from the guest and will attempt to install Ansible when not present.

Also, you do not have to **only** run 'vagrant up --provision' to re-provision a host. You can run ad-hoc ansible commands by utilizing the specific hosts file created by the initial `vagrant up` e.g.

    ansible-playbook --private-key=.vagrant/machines/qualitybox/virtualbox/private_key -u vagrant -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --become provision.yml

However, when doing this you may be skipping over prior steps which define certain variables. In that case, you should add `--extra-vars` on the command-line.

    ansible-playbook --private-key=.vagrant/machines/qualitybox/virtualbox/private_key -u vagrant -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --become provision.yml --start-at-task="setup" --extra-vars 'wiki_hostname=wiki.example.com apache_user=www-data'

Options
-------

There are many options you can pass in the Vagrantfile corresponding to ansible-playbook options. One is 'sudo' (boolean; default: false) which is equivalent to the newer 'become' option. Another is 'sudo_user' which is the user that should execute the commands. I suppose this is how we would setup 'qb' as the deploy user <sup>[4](#footnote4)</sup>. I wrote a 'provision.sh' script to try to create \$USER on the guest, but it turns out the Vagrantfile is being run by 'root' (thus I got an error that the 'root' user already exists). As of Vagrant 1.7.3, it is no longer necessary to disable the keypair creation when using the auto-generated inventory (at least not in terms of 'security'). You'll see references to the legacy insecure key. and `config.ssh.insert_key = false` but new Vagrant generates and inserts a 'secure' key<sup>[5](#footnote5)</sup> [This SO post](https://stackoverflow.com/questions/32748585/ssh-into-a-vagrant-machine-with-ansible) gets right to the heart of the matter when trying to figure out the differences between how Vagrant connects and how Ansible connects to the 'guest'

SSH Configuration
-----------------

`vagrant ssh-config`<sup>[6](#footnote6)</sup> will output a valid configuration for ssh directly into the guest without needing to invoke vagrant at all (aka `vagrant ssh`). This also allows you to confirm that your provisioning scripts are looking for the right key in the right place. And last but certainly not least, this is how you would run Ansible "manually", outside of Vagrant, against your Vagrant guest. This is a quicker way to run an Ansible playbook without having to do a full 'vagrant provision'<sup>[7](#footnote7)</sup>

Manual Plays
------------

Say you have a play that you want to test on your Vagrant box.

~~~~ {.yaml}
- name: This is a play at the top level of a file
  hosts: all
  # become: true

  tasks:

  - name: say hi
    tags: foo
    shell: echo "hi..."

  - name: Install unattended-upgrades
    package:
      name={{item}}
      state=latest
      update_cache=yes
      force=yes
    with_items:
      - unattended-upgrades

  - name: Overwrite /etc/apt/apt.conf.d/10periodic
    template: src=10periodic.j2 dest=/etc/apt/apt.conf.d/10periodic owner=root group=root mode=0644
~~~~

Assuming you have `-o IdentitiesOnly=yes` in your `ansible.cfg` file to avoid the 'host unreachable' errors, you can invoke `ansible-playbook --private-key=.vagrant/machines/qualitybox/virtualbox/private_key -u vagrant -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory test.yml`

You can also test your connection with `ssh -o IdentitiesOnly=true -i .vagrant/machines/qualitybox/virtualbox/private_key -p 2222 vagrant@127.0.0.1`

ToDo
----

1.  Add any necessary shared folders between host and guest e.g. `rails.vm.synced_folder "~/src", "/home/vagrant/src"`

2.  Test for full functionality.

3.  Fix error <sup>[8](#footnote8)</sup> about adding 'root' user (which was really an attempt to add \$USER). This action was removed from the provision.sh script.

```bash
greg@laptop:~$ vagrant up --provision
```
>   Bringing machine 'qualitybox' up with 'virtualbox' provider...  
>   ==> qualitybox: Checking if box 'ubuntu/trusty64' is up to date...  
>   ==> qualitybox: A newer version of the box 'ubuntu/trusty64' is available! You currently  
>   ==> qualitybox: have version '20160907.0.0'. The latest is version '20160913.0.0'. Run  
>   ==> qualitybox: `vagrant box update` to update.  
>   ==> qualitybox: VirtualBox VM is already running.

Footnotes
---------

<a name="footnote1">[1]</a> <https://docs.ansible.com/ansible/intro_configuration.html#remote-user>  
<a name="footnote2">[2]</a> <https://github.com/mitchellh/vagrant/pull/5044>  
<a name="footnote3">[3]</a> <https://www.vagrantup.com/docs/provisioning/ansible_local.html>  
<a name="footnote4">[4]</a> <https://www.vagrantup.com/docs/provisioning/ansible_common.html>  
<a name="footnote5">[5]</a> <https://www.vagrantup.com/docs/provisioning/ansible.html>  
<a name="footnote6">[6]</a> <https://www.vagrantup.com/docs/cli/ssh_config.html>  
<a name="footnote7">[7]</a> <https://docs.ansible.com/ansible/guide_vagrant.html#running-ansible-manually>  
<a name="footnote8">[8]</a> see history