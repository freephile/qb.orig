---
title: analysis
permalink: /analysis/
---

Solution Choices
----------------

There are choices for **How** to do the automation from Vagrant to Ansible and others. There are also choices about **Where** the QualityBox should be deployed first amongst a wide range of cloud providers. And not least, there are choices about **Who** to emulate in terms of the implementation.

### How

We decided to use Ansible, while also adding Vagrant as a provisioning tool for local development environments backed by the VirtualBox tool (still using Ansible for the provisioning). Ansible has been repeatedly confirmed as the best automation /orchestration tool. (Ryan Lane likes salt, but I guess what I'm really saying is that Ansible is far better than Puppet) That's not to say you can't use several tools in combination. Lex is using at least Vagrant and Ansible. See <http://devo.ps/blog/vagrant-docker-and-ansible-wtf/> for a quick overview and demo of how Vagrant, Ansible and Docker can be used in a complimentary fashion. See [Automation and orchestration tools](https://freephile.org/wiki/Automation_and_orchestration_tools "wikilink") for a more detailed discussion

### Where

#### Digital Ocean

There is a module in Ansible core for "talking" to Digital Ocean via the Digital Ocean API (v2) which was released in 2015<sup>[1](#footnote1)</sup>. Although it's **buggy** <sup>[2](#footnote2), </sup><sup>[3](#footnote3)</sup>, I was able to get it working directly on my host at DO. See [How To Use the DigitalOcean API v2 with Ansible 2.0 on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2-with-ansible-2-0-on-ubuntu-14-04) Again, [this core Ansible module](https://docs.ansible.com/ansible/digital_ocean_module.html) is a wrapper around Digital Ocean's API (v2) ([Docs](https://developers.digitalocean.com/documentation/v2/)). [code for the module](https://github.com/ansible/ansible-modules-core/blob/devel/cloud/digital_ocean/digital_ocean.py)

The visual account interface for your DO droplets is at <https://cloud.digitalocean.com/droplets> There you can see the droplets you've created, and do other things like see graphs.

### Who

#### MITRE / Dr. Cindy Cicalese

Dr. Cindy Cicalese is a leading MediaWiki developer with many custom extensions developed herself or in collaboration with the team she leads at MITRE in Washington, DC. mediawiki-tools-ansible-wikifarm (MTAW) has the most complete codebase for achieving goals very similar to our own [mediawiki-tools-ansible-wikifarm](https://github.com/wikimedia/mediawiki-tools-ansible-wikifarm). It has MediaWiki, in a farm config, with curated extensions, all configurable and deployable through Ansible. But, the more we got into developing a work-alike for Ubuntu instead of RHEL, the more it needed to be changed to meet our needs.

##### QualityBox v. MTAW


**OS**
MTAW deploys against RHEL/CentOS while QualityBox deploys on top of an Ubuntu base.


**structure**
MTAW places everything in it's own directory like a chroot. This would appear to be a benefit in that you can deploy this against an existing box; or as MTAW says:

> This directory hierarchy is self-contained, supporting migration between similarly configured hosts.

However, you can't really deploy something like a full LAMP stack and application on top of an existing host without managing port conflicts. You also can't just copy a directory to other hosts if any of the customization and optimization expands beyond a restricted set of services. Our goal with the QualityBox is that the system layout is what you'd expect logging into any generic Ubuntu host (e.g. /etc/apache2/conf.d, /var/lib/mysql). And, the QualityBox will have many additional tools, services and configurations optimized to offer a complete MediaWiki hosting environment. In short, QualityBox is NOT designed to be deployed on top of an existing host, but rather to create a perfect host.


**DB credentials**
MTAW uses variables for the db user/pass. We install MariaDB with 'changepassword' and then secure it using a randomly generated password that is stored in /root/.my.cnf

MTAW says:

> By default, MediaWiki and many of its extensions are installed from the Wikimedia Foundation git repository. However, in some cases dowloads of `large code bases from that repository through a firewall can stall, so the "group_vars/mw_hosts/config" file contains alternative URLs that are commented out to install from the github.com mirror. To switch to use the mirror, comment out the wikimedia URLs and uncomment the github URLs.`

It feels a bit kludgey to comment / uncomment lines in the group_vars/mw_hosts/config. Note: you should install from the mw repos if you're ever going to want to push or commit to mw. Otherwise (99.9%) you can use the github mirrors.

**solution**
You can't use 'when' in a YAML dict (group_vars/all/default_extensions) to alternate the provenance of the git repo. But, we could have two nearly identical files: `default_extensions_from_mw` and `default_extensions_from_github` with the URLs static. And then `group_vars/mw_hosts/config` would simply have a single variable for deciding if your preferred source is MW or GitHub: clone_from: github or mw and then install_extensions.yml would say EXTENSIONS: "{{ DEFAULT_EXTENSIONS_FROM_GITHUB }}" when clone_from = "github" would say EXTENSIONS: "{{ DEFAULT_EXTENSIONS_FROM_MW }}" when clone_from = "mw"

Having two nearly identical files would help keep those files in sync because they could easily be diffed.

**Certificates**
MTAW grabs certs from a 'certs' directory and the naming convention must match the name of the wiki you're creating. However, we will be using **certbot** (in combo with DNS).

**Ports**
MTAW directs all traffic on 443 through squid and port 80 is the purge/redirect port while Apache is listening on 8080 We're not installing squid (yet). Installing [squid](https://freephile.org/wiki/squid "wikilink") as a transparent 'Man in the Middle' HTTPS proxy would be a feature that is only useful in a corporate environment where you install a custom CA into each client browser and would allow for not just traffic acceleration over HTTPS, but also packet inspection.

**Interwiki**
For now we will ignore the interwiki sharing

**Cloning**
We are also ignoring the 'clone wiki' feature of MTAW which is essentially just a tar and copy of the whole 'ROOT_DIR' to another host. We will later focus on sizing the host and/or possibly migrating a wiki from one place to another but it's not important at the moment.


MTAW process:

1.  setup.yml
2.  deploy_db_hosts.yml
3.  add_db_client.yml -e "MW_HOST=host1" -l <host1>
4.  deploy_mw_hosts.yml
5.  install_mediawiki.yml -e "MW_RELEASE=REL1_26"
6.  install_extensions.yml -e "MW_RELEASE=REL1_26"
7.  install_skins.yml -e "MW_RELEASE=REL1_26"
8.  create_new_wiki.yml -e "MW_HOST=host1 WIKI_NAME=name"

The new wiki will be available at http://host1/name

For QB:

1.  is Launch.yml
2.  is contained in the QualityBox role (install_mariadb.yml) We'll need to separate this out to it's own role in order to be able to distinguish between a 'mw_host' and a 'db_host'
3.  adds iptables rules for mysql. QualityBox will add this feature when the database is accessible off localhost.
4.  The rest of the QualityBox setup is handled by `provision.yml`

#### LCC / Lex Sulzer

Lex and the [Linux Competency Center](http://www.linux-competence-center.ch/) in Switzerland are first-class. Lex is a really smart guy and his focus is on Semantic Wikis.

Lex put together a diagram and notes that illustrates the relationship of the tools and code that is used <https://smw-cindykate.com/main/File:Component_571935.png> <sup>[4](#footnote4)</sup>. Much of the LCC work relies on **[Ansible](https://freephile.org/wiki/Ansible "wikilink")**. There are also examples: <https://github.com/ansible/ansible-examples/blob/master/lamp_simple/roles/db/handlers/main.yml>

The backup system for LCC uses duplicity, which has documentation at <http://duplicity.nongnu.org/duplicity.1.html>

-   <https://github.com/LinuxCompetenceCenter>
-   <https://github.com/LinuxCompetenceCenter/ansible-role-lcc-smw-duplicity-restore> lcc-smw-duplicity-restore
-   <https://www.semantic-mediawiki.org/wiki/User:Lex#tab=SMW_Deployment_using_Vagrant_2FAnsible_2FCucumber>
-   <https://smw-cindykate.com/main/Component_947746#backup_local.sh> Backup Instruction "Encrypted, scheduled/ad hoc, full/incremental, local/offsite Duplicity backup"
-   <https://smw-cindykate.com/main/Component_947747#Browse_devwiki_from_your_workstation_.28host.29> Cookbook Instruction "How to turn an idea into a certified SMW extension"
-   The "[DNA and genesis of a new SMW on any Ubuntu server](https://smw-cindykate.com/main/Component_998879)" shows the full complement of scripts to bring up a SMW box
-   <https://smw-cindykate.com/main/Component_998880> Restore Instruction "Restore a SMW from a GnuPG-encrypted Duplicity backup set"

#### Jeff Geerling

<https://github.com/geerlingguy/ansible-for-devops/blob/master/dynamic-inventory/digitalocean/provision.yml>

#### Stuart Ellis

[Stuart Ellis](http://www.stuartellis.eu/) has a lot of ansible code His <https://github.com/stuartellis/stuartellis-ansible-cfg> includes a Vagrantfile that demonstrates using Ansible as a provider for Vagrant.

#### Patrick Heeney

Developed the [Protobox](http://getprotobox.com) The Protobox is a model for the QualityBox project on how far we could push customization in terms of sizing, deployment, features etc.  However, we'll need a much more controlled environment for supported (hosted) instances so exposing all this flexibility doesn't gain value for the SAAS model.

-   <https://github.com/protobox/protobox-docs/blob/master/about.md> static website in markdown
-   <http://getprotobox.com/docs/modules> What's interesting is that he is offering a bunch of choices for web server, PHP, HHVM, Mailcatcher, database server, Node and data stores
-   <https://github.com/protobox/protobox>

#### Juan Treminio

Juan is the developer of [PuPHPet](https://puphpet.com/) (like Protobox).  PuPHPet is a PHP front-end configurator for VirtualBox that can deploy (using Puppet) against several targets: RackSpace, DigitalOcean, Linode, AWS, Google and of course Localhost.  (Reminder: there is a VirtualBox plugin for each of these targets.)  https://github.com/puphpet/puphpet  When you consider the localhost target, PuPHPet is a web application that helps you write your Vagrantfile and also gives you a box image that corresponds to the OS you choose.

#### Steve Kuznetsov

<https://github.com/stevekuznetsov/origin-ci-tool/blob/master/oct/ansible/oct/playbooks/prepare/main.yml#L25-L36> I like his 'ensure this playbook is well-formed' task. Also, his whole repo may be a good example of using Vagrant with Ansible... OpenShift is a container platform by RedHat for using Docker etc.

#### MediaWiki Vagrant / MediaWiki Core Developers

Having used [MediaWiki-Vagrant](https://www.mediawiki.org/wiki/MediaWiki-Vagrant) for development purposes, I'm familiar with how awesome it is. It is not suitable for production hosting since it's aimed squarely at development. However, it could be used for the development box deployment; and also modified to create a production box equivalent. At the very least, it's an excellent example that has been created and vetted by the team at WikiMedia Foundation.

Also note: there is an [open issue](https://phabricator.wikimedia.org/T53782) for creating a GUI for MediaWiki-Vagrant just like Juan did with PuPHPet.

Footnotes
---------

<a name="footnote1">[1]</a> <https://www.digitalocean.com/company/blog/apiv2-officially-leaves-beta/>  
<a name="footnote2">[2]</a> <https://github.com/ansible/ansible-modules-core/issues/2509#issuecomment-195864794>  
<a name="footnote3">[3]</a> <https://stackoverflow.com/questions/36516659/doerror-using-ansble-with-digital-ocean>  
<a name="footnote4">[4]</a> <https://smw-cindykate.com/main/Component_987113>  