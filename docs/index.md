---
title: docs
permalink: /docs/
---

Source
------

There is a private repo at <https://github.com/freephile/qb>

### Collaborators

1.  Lex Sulzer <https://github.com/lexsulzer>
2.  Steve Pieper <https://github.com/pieper>
3.  Jean Christophe Fillion-Robert <https://github.com/jcfr>
4.  Yaron Koren <https://github.com/yaronkoren>

ToDo
----

### QB

1.  Conference call with Lex

    1.  Press Release

2.  Make sure the mail system is working (add extra configuration for MediaWiki [1] to tie in with clients mail system?) or set this up as a hosting feature with SendGrid/et al. [2] as the underlying service shared by all domains on a plan

3.  Create website similar to <https://fantasktic.com>

4.  Get rid of **EMPTY_WIKI_NAME** in group_vars/all/config... what is it for? I assume it's some kind of chicken and egg thing, but I don't think we need it.

5.  Add support for separating wiki host from db host. See <https://gist.github.com/halberom/0663ef9933360fcf7141> for gist on how to use 'gather_facts' on one group of hosts (e.g. db servers) to fill out a template for another set of hosts (web servers).

6.  replace usage of **MYSQL_WIKI_PASSWORD** with actual random password; or user supplied password (found in ./roles/install_mediawiki and ./roles/create_new_wiki_on_db_host)

7.  Test and determine best email solution. We **do** have Pear mail installed . What about Swiftmailer?

8.  Activate the 'install lua sandbox' task

### SPL Project

1.  Review Ansible Galaxy roles for code re-use. There are no MediaWiki roles, and no mod_vhost_alias roles.

2.  ~~Add gatewayed hosts for accessing partners web1 and web2~~ Not possible with old version of SSH running on Partners network

3.  extract out the Droplet create/destroy - it has proved too cumbersome in practice to go from provisioning to configuration in one playbook

    1.  To do this, compare what is in launch.yml now with <https://gist.github.com/leucos/2c361f7d4767f8aea6dd> and also what we have in src/ansible-do-api
    2.  Cleanup / discard what is in src/qb.1

    3.  Merge ansible-digitalocean with qb

    4.  Use different branches for development rather than separate repos/remotes

4.  add directory ownership/perms so as to [avoid running composer as root](https://getcomposer.org/doc/faqs/how-to-install-untrusted-packages-safely.md)

    1.  Reference: <https://www.mediawiki.org/wiki/Composer/For_extensions> and <https://www.semantic-mediawiki.org/wiki/Help:Using_Composer>

5.  Decide on the correct wiki farm/family layout <https://www.mediawiki.org/wiki/Manual:Wiki_family>

6.  Deploy full QB to "wiki.slicer.org" host on Digital Ocean
    1.  Finish the user setup and Fix user problems
        1.  consolidate use of ssh_user

        2.  create qb user as the 'deploy' user. This should be as simple as: create the qb user, create the authorized_keys file, add to the sudo group, provision as qb.

7.  Security See **security** sections below

    1.  Finish the Apache configuration (wiki.example.com should have proper directory and apache config)
    2.  Review list of extensions and add any missing extensions as either 'global' or 'local'
        1.  Extensions included (by Cindy)
        2.  Extensions in slicer.wiki.org (mandatory)
        3.  Extensions in freephile.org (QB pro-forma)
        4.  [Extensions wanted](/Extensions_wanted "wikilink") (should add)
        5.  <https://www.mediawiki.org/wiki/Extension:Site_Settings> site settings for client management of certain aspects? (don't even know if it's compatible)

8.  Copy code/backup to QB from web2
9.  Test what's working and what's not (wiki and any extensions)
10. Upgrade from 1.26 to 1.27 - internalize that to Ansible
    1.  [Review deprecated settings](https://www.mediawiki.org/wiki/Category:MediaWiki_configuration_settings_removed_in_version_1.27.0) for occurences in LocalSettings.php

### Back Burner

1.  Create documentation of features (deployability, software, extensions like [mw:Extension:Semantic_Glossary/Example Semantic Glossary](/mw:Extension:Semantic_Glossary/Example_Semantic_Glossary "wikilink")

    1.  Create PowerPoint / slides

2.  Add vagrant deployment option (See [docs/Vagrant](/docs/Vagrant "wikilink"))

3.  Add Search and [PdfHandler](https://www.mediawiki.org/wiki/Extension:PdfHandler) extensions
4.  Add DNSMasq (or equivalent) <http://www.nickhammond.com/vagrant-and-ansible-for-local-development/> <https://help.ubuntu.com/community/Dnsmasq> to make resolver easier for .dev or .local domains
5.  Add Docker option <https://docs.ansible.com/ansible/intro_inventory.html#non-ssh-connection-types> although the images provided by docker would need heavy customization, so the case for doing this is not yet clear. Perhaps a service option where 'sandbox' was the service tier would make sense however if it didn't contain the differentiating factors that make QualityBox attractive, then how would the sandbox sell the service?
6.  create the distinction between creating a db host and web host (e.g. remove 'install apache' from the qualitybox role)

Subpages
--------

Goal
----

My goal is to create an automated and repeatable way to specify and deploy a "base" box which can be deployed on a number of cloud providers: namely VirtualBox for local development; Digital Ocean for ease of use and cost; AWS for larger enterprise customers who prefer to use Amazon. Future providers might include VMware.

The base box should have

1.  Ubuntu Linux 16.04 (gui/no-gui)
2.  Apache
3.  MySQL (or MariaDB)
4.  PHP (and extensions)
5.  memcached
6.  jenkins?
7.  munin?
8.  monit
9.  etckeeper?
10. git
11. ssh
12. ansible

Depending on the provider, there may be extra configurations or requirements

1.  Guest additions if provider is VirtualBox (not needed for AWS)

Provision
---------

The process should look like (initially I was focused on Vagrant first, but now I'm deploying to DO first, and we'll add Vagrant support later. See the certbot project for what looks like an advanced usage of Vagrant)

~~~~ {.bash}
cd ~/vagrant
vagrant box add quality-box /~/Downloads/quality-Wiki.box
vagrant init quality-box
vagrant up
~~~~

The QualityBox is based on a prebuilt image (nb: not true - unless we adopt Lex's approach. At the moment, we install a base Ubuntu, and modify that.) that we've made rather than recreating the box step by step for each installation. See [Creating a base box](https://www.vagrantup.com/docs/boxes/base.html)

Pricing / Costs
---------------

### Vendor Costs

If using Docker, pricing depends on whether it's cloud or premise, and ranges from \$15/mo for a single node to \$300/mo per node for 24x7 support. Keep in mind that several "nodes" may be needed to complete a service which is scalable, modular and spans production and pre-production. Developer nodes are free.

### Comparisons

Referata.com does not support HTTPS[3]. And, it has a limited set of extensions [4]. There are 4 plans [5] that range in price from (free), \$20, \$50 and \$80/mo. The free tier is especially not remarkable. The only plans that offer a domain name are \$50 and \$80 with no mention of the RAM and CPU dedicated (hint: it is slow). Speaking with Yaron, the QualityBox should be priced at \$300/mo

Inventory
---------

We'll (probably?) have both static hosts (our own that we want to refer to explicitly) and dynamic hosts (clients' servers which we can refer to by naming convention or id) to operate on. This is sometimes referred to as a 'hybrid cloud'. With Ansible, you can specify an inventory directory where multiple sources are found. Executable files are treated as dynamic sources. [6]

### Python Script

The **digital_ocean.py** script that comes with Ansible is a useful tool to interact with the DigitalOcean API to retrieve data about your droplets.

You can list your DigitalOcean droplets with the following:

` ~/bin/ansible/contrib/inventory/digital_ocean.py --list --api-token INSERT_TOKEN_HERE`

Use `~/bin/ansible/contrib/inventory/digital_ocean.py --help` to see the command options.

Note that you can also export your DO_API_TOKEN, or put it in a vars file. There is even an `--env -e` option to display the environment/DO_API_TOKEN if you've exported it.

Because we can use the script to tell us about the inventory in an ansible compatible way, the best bet for creating and managing droplets would be

1.  have one playbook create a bunch of droplets
2.  run **digital_ocean.py** to generate a hosts file
3.  run another playbook in tandem with that hosts file to turn all those droplets into QualityBoxes

### Dashboard

<https://cloud.digitalocean.com/droplets>

Log
---

I've used just Ansible (no Vagrant) to provision and destroy boxes at Digital Ocean.

I downloaded and installed the latest (v1.8.4) of Vagrant since my earlier version didn't recognize the latest version of VirtualBox

The installation of vagrant is in `C:\Users\Greg\projects\spl`

The first time you setup the box, you need to run `vagrant halt` and `vagrant up` to re-read the customizations... but actually I'm not sure of that. I don't think there are any customizations in the scripts provided by Lex. The MediaWiki-Vagrant setup that I did for MG was customized.

Over a year ago, I forked[7] the Orain/ansible-playbook [8] to begin an ansible based MediaWiki wiki farm aka QualityBox. Now I'm 453 commits behind them. But their playbook is heavily customized for their specific wikifarm. It is not a generic setup. I've done nothing to make my fork more generic. Also, I have not introduced the specific [features](/features "wikilink") that I think would add value to a generic setup to create an enterprise "distribution" of SMW.

Recipe Notes
------------

The [Apache2 module](https://docs.ansible.com/ansible/apache2_module_module.html) will enable/disable Apache modules

The [Domain Module](https://docs.ansible.com/ansible/digital_ocean_domain_module.html) will create the DNS records for you at DO

How do I create certificates?? There is a Letsencrypt module in the "[Web Infrastructure Modules](https://docs.ansible.com/ansible/list_of_web_infrastructure_modules.html)" that can be used. Just need to think creatively how to use it? (chicken/egg problem)

> 1.  this won't work because you can't get a cert for a domain that isn't yours
>
> greg@eqt:\~/certificates\$ \~/bin/letsencrypt/letsencrypt-auto --domain wiki.slicer.org --apache certonly --dry-run

Do we want to enable an interwiki table to facilitate transclusion between wikis?

Need to update group_vars/all/default_extensions (or add qb_extensions)

~~~~ {.bash}
grep -Po '(?<=name: ")[^"]*' ./mediawiki-tools-ansible-wikifarm/group_vars/all/default_extensions |sort
~~~~

1.  Arrays
2.  Cargo
3.  Cite
4.  CodeEditor
5.  CustomNavBlocks
6.  DataTransfer
7.  DynamicPageList
8.  ExternalData
9.  HeaderTabs
10. HierarchyBuilder
11. HitCounters
12. ImageMap
13. InputBox
14. JSBreadCrumbs
15. LdapAuthentication
16. LDAPAuthorization
17. Lingo
18. MagicNoCache
19. Maps
20. OpenIDConnect
21. ParserFunctions
22. PipeEscape
23. Piwik
24. PluggableAuth
25. ReplaceText
26. SafeDelete
27. Scribunto
28. SemanticDependency
29. Semantic Extra Special Properties
30. SemanticForms
31. SemanticGlossary
32. Semantic Maps
33. Semantic MediaWiki
34. SemanticRating
35. Semantic Result Formats
36. SemanticTitle
37. SimpleMathJax
38. SimpleSAMLphp
39. SimpleTooltip
40. SyntaxHighlight_GeSHi
41. TitleIcon
42. UrlGetParameters
43. UserFunctions
44. Variables
45. VIKI
46. VikiSemanticTitle
47. VikiTitleIcon
48. WhosOnline
49. Widgets
50. WikiEditor

For each complex extension like Visual Editor, install dependencies

Other Notes
-----------

I might need to expose a Miga data viewer of the CSV data to view the details of the [Private:SPL](/Private:SPL "wikilink") infrastructure. <http://migadv.com/usage/>

[1] <https://www.mediawiki.org/wiki/Manual>:\$wgSMTP

[2] [Private:Email_Marketing](/Private:Email_Marketing "wikilink")

[3] <http://referata.com/wiki/Referata:FAQ#Does_Referata_support_secure_HTTP_.28.22HTTPS.22.29.3F>

[4] <http://referata.com/wiki/Referata:About>

[5] <http://referata.com/wiki/Referata:Features>

[6] [Using Inventory Directories and Multiple Inventory Sources](https://docs.ansible.com/ansible/intro_dynamic_inventory.html)

[7] <https://github.com/freephile/ansible-playbook>

[8] <https://github.com/Orain/ansible-playbook>