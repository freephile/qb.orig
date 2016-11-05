---
title: security
permalink: /security/
---

Security
--------

### Users and QB Provisioning

Requirements:

1.  A means for Ansible to connect (greg)
2.  A means for Vagrant to conect (vagrant)
3.  A control user to standardize documentation and procedures (qb)
4.  A list of users to add to the QB

Ansible is agentless and connects to hosts using ssh in order to execute all it's magic. See <https://docs.ansible.com/ansible/intro_inventory.html#list-of-behavioral-inventory-parameters> for the list of variables at issue when connecting to hosts. Root logins are not required (but you obviously need sudo to do anything important.) It's recommended to simply use `ssh-agent bash; ssh-add ~/.ssh/id_rsa` Although the 'ssh' in `ansible_ssh_user` is deprecated, you'll still find lots of usage of that variable.

Thus, we need at least one key to initially connect to a host. We also want to provision the QB such that there is a "control user" (qb) that our documentation can refer to. We also want to be able to provision the QB with a list of users who may be members of the client organization who will want command-line access to the QB.

The precedence rules for the `user` parameter are<sup>[1](#footnote1)</sup>:

1.  `ansible_ssh_user` (now known as `ansible_user`) in inventory or as *extra_vars*
2.  `remote_user` or `user` YAML attributes in a playbook file
3.  `-u (--user)` ansible-playbook argument
4.  `ANSIBLE_REMOTE_USER` environment variable
5.  `remote_user` parameter in `ansible.cfg` file
6.  and last but not least, it will default to the username of the current user (aka \$USER)

Ansible has an ["Authorized Key" module](https://docs.ansible.com/ansible/authorized_key_module.html) which is used for adding or removing keys. There is also the User module

For the list of users, we will maintain a folder/file tree where we can add the public keys to both add and revoke access to the QB. Something like this <sup>[2](#footnote2)</sup>

~~~~ {.yaml}
tasks:
- name: Manage Authorized Keys | Allow
  authorized_key: user=targetUser key=”{{ lookup(‘file’, item) }}” state=present
  with_fileglob: pubkeys/allow/*

- name: Manage Authorized Keys | Deny
  authorized_key: user= targetUser key=”{{ lookup(‘file’, item) }}” state=absent
  with_fileglob: pubkeys/deny/*
~~~~

But the problem with this code is that it does not iterate over the names of users (there is a single 'targetUser' for each run). It would be better to match the name of each user with the key for each user (e.g. pair 'bob' with /pubkeys/allow/bob.id_rsa.pub')

In launch.yml we use the **digital_ocean:** module (https://github.com/ansible/ansible-modules-core/blob/devel/cloud/digital_ocean/digital_ocean.py) which has the {{ssh_pub_key}} option/argument which the value should be the public SSH key you want to add to your account. Note the **digital_ocean:** module has two *command* options (droplet|ssh) to indicate whether you are deploying a droplet, or deploying a key. Correspondingly, the *name* option is either the name of the droplet, or the name of the key you are deploying. By default, the module *waits* for the server to be running and we double the *wait_timeout* to 600 seconds <sup>[3](#footnote3)</sup>

With tasks/security.yml we use the **user:** module and {{ssh_user}} which is defined in vars.yml as "{{ lookup('env', 'USER') }}" to create the home directory for the user running ansible (greg) and using his id_rsa.... We eliminated the redundant {{ssh_pub_key}} and {{do_ssh_pub_key}} etc.

### Security and the OS

The QB hardens the Operating System level to provide security at the box/node/network level.

1.  Restrict SSH logins to use certificates only
2.  Deny root logins
3.  Install and configure a firewall (UFW)
4.  Install and configure fail2ban
5.  Automatically run OS and package security updates with `[[/Unattended_upgrades|unattended-upgrades]]` <ref>

In a typical MONTH there are dozens for security updates that should be applied. These need to happen automatically.

> `Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 4.4.0-34-generic x86_64)`
>
> `* Documentation:  `[`https://help.ubuntu.com/`](https://help.ubuntu.com/)
>
> ` System information as of Wed Sep 21 16:15:53 UTC 2016`
>
> ` System load:  0.0                Processes:           129`
> ` Usage of /:   74.7% of 39.25GB   Users logged in:     0`
> ` Memory usage: 27%                IP address for eth0: 198.199.121.96`
> ` Swap usage:   0%                 IP address for eth1: 10.136.17.129`
>
> ` Graph this data and manage this system at:`
> `   `[`https://landscape.canonical.com/`](https://landscape.canonical.com/)
>
> `42 packages can be updated.`
> <span style="color:red;">`30 updates are security updates.`</span>

</ref>

### Security and the Webserver

The QB is designed to use **HTTPS everywhere** (not [the extension](https://www.eff.org/https-everywhere), but rather the concept). With that in mind, we're provisioning TLS Certificates using the [Certbot](https://certbot.eff.org/) client of the [letsencrypt](https://letsencrypt.org/) project. There is an 'extras' module for letsencrypt <https://docs.ansible.com/ansible/letsencrypt_module.html> Although we can automate certificates on a live server (one that has an A record in DNS), we need a manual step to prove ownership of any server that is not public. The manual step is to create a TXT record in the public DNS for the domain in question.<sup>[4](#footnote4)</sup> Finish the implementation of not just installation of the Certbot, but also the ability to create and verify private hosts

Footnotes
---------

<sup>[1](#footnote1)</sup> <https://github.com/mitchellh/vagrant/pull/5044>  
<sup>[2](#footnote2)</sup> <https://brokenbad.com/better-handling-of-public-ssh-keys-using-ansible/>  
<sup>[3](#footnote3)</sup> Two environment variables can be used, DO_API_KEY and DO_API_TOKEN  
<sup>[4](#footnote4)</sup> <https://tools.ietf.org/html/draft-ietf-acme-acme-02#section-7.4>  