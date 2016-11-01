---
title: docs TLS
permalink: /docs/TLS/
---

aka SSL or HTTPS We want to be able to offer secure web services. We intend to use free certificates from the "Let's Encrypt" project.

Ansible Role
------------

I've written a role **ansible-certbot** that installs certbot in /opt

Pre Requisites
--------------

Do the DNS first. You can't use certbot until the host your targeting is the same in public DNS because that's the way it works.

To use the role
---------------

1.  copy your public key to 'authorized_keys' on the target
2.  make sure the target is in your ansible hosts file
3.  run the role `ansible-playbook certbot.yml`

We can either incorporate the role into a larger playbook; or run it independently.

Install Certificates
--------------------

You can now use certbot like so (however it will fail because there is no A record for this IP)

~~~~ {.bash}
/opt/certbot/certbot-auto --domain wiki.slicer.org --apache certonly --dry-run
./certbot-auto --apache -d freephile.org --agree-tos --email info@equality-tech.com
~~~~

Post Installation
-----------------

Once we have certs in place, we'll need to renew them frequently (they expire in 90 days). A cron job will do the trick

~~~~ {.bash}
#### Renew our LetsEncrypt certificates automatically every 3 months because they expire every 90 days
05 04 01 */3 * root /opt/certbot/certbot-auto renew
~~~~

More
----

See <https://certbot.eff.org/#ubuntutrusty-apache> for more on certbot and <https://github.com/geerlingguy/ansible-role-certbot> for more on the certbot installer role

### Checking Ciphers

As far as getting good TLS support from 14.04

~~~~ {.bash}
nmap --script +ssl-enum-ciphers equality-tech.com
~~~~
