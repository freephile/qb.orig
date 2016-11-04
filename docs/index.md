---
title: QualityBox
permalink: /
---

Intro
-----

The QualityBox is a complete solution for hosting a MediaWiki installation similar to what is used to run Wikipedia. There are other options for installing MediaWiki on your own server, like <code>sudo apt-get install mediawiki</code>. But that is just a starting point whereas QualityBox is the full endpoint. By leveraging the Ansible orchestration tool, QualityBox allows you to provision virtual machines locally (using Vagrant + VirtualBox) or in the cloud (e.g. Digital Ocean droplets).  Isn't QualityBox duplicating the MediaWiki-Vagrant system? No. MediaWiki-Vagrant will allow you to quickly build a development instance while the Quality Box is optimized for production hosting of MediaWiki.  For MediaWiki consultants, this turbo-charges your DevOps **and** Delivery.  For organizations wishing to deploy MediaWiki, QualityBox eliminates the many hurdles along the way. QualityBox opens up the pathway to better support, training, integration or extension by the same people and organizations that develop QualityBox.


Source
------

The source code can be found on GitHub at <https://github.com/freephile/qb>

### Collaborators
Some initial collaborators include:
* [Jean Christophe Fillion-Robert] (https://github.com/jcfr)
* [Cindy Cicalese] (https://www.mediawiki.org/wiki/User:Cindy.cicalese)
* [Yaron Koren] (https://github.com/yaronkoren)
* [Steve Pieper] (https://github.com/pieper)
* [Lex Sulzer] (https://github.com/lexsulzer)

Motivation
----------

Why does QualityBox exist?  Because MediaWiki is an awesome piece of software that powers one of the greatest achievements of the Internet: Wikipedia.  The MediaWiki software is ***freely*** licensed under the GPL, so naturally thousands of organizations use it locally for intranets, documentation websites, fan sites etc.  It's heavily used by the software development industry itself.  But the software has grown in complexity as it has added features over time; thus making it very difficult to deploy for even experienced software developers or system administrators.  Not only is it hard to deploy (nb. the one-click installers fall short), but there are so many aspects that need to be added to a MediaWiki installation to make it "fully furnished" so that an organization can begin using it.  

You need to add at least a "starter pack" [set of templates] (https://www.mediawiki.org/wiki/Template_repository). You need a long list of extensions; and while roughly a dozen excellent ones are distributed with MediaWiki in the default tarball, there are approximately 50 must-have extensions included with QualityBox.  You need content in the Help namespace (aka documentation). No software is great without great documentation.  Plus lots of other [features] (/features/) like security, monitoring, scalability and enterprise support to make it complete.

So [eQuality Technology] (https://eQuality-Tech.com) launched QualityBox to address these needs.  And it's free as in freedom. (Freedom comes with a price: You must share back your code -- according to the terms of the QualityBox [license] (https://github.com/freephile/qb/blob/master/LICENSE).)  QualityBox makes it easy for top-notch free software consultants to offer MediaWiki hosting to their clients. QualityBox makes it easy for organizations, who respect freedom and value collaboration, to deploy QualityBox in their own infrastructure or clouds.  It's our goal that QualityBox will make MediaWiki as prevalent as WordPress is for blogs and Drupal is for websites.  There is no way that an organization should even consider SharePoint for more than 60 seconds when QualityBox is so much more.

See also:
* [MediaWiki Stakeholder's Group](http://mwstake.org/mwstake/wiki/Main_Page)
* [MediaWiki Usage Report 2015] (https://www.mediawiki.org/wiki/MediaWiki_Usage_Report_2015)


ToDo
----

### QB
1. Right now, working on a new branch to integrate the [MediaWikiFarm extension] (https://www.mediawiki.org/wiki/Extension:MediaWikiFarm)
* [install] (https://github.com/wikimedia/mediawiki-extensions-MediaWikiFarm/blob/master/docs/installation.rst)

2.  Make sure the mail system is working (add extra configuration for MediaWiki [1] to tie in with clients mail system?) or set this up as a hosting feature with SendGrid/et al. [2] as the underlying service shared by all domains on a plan

4.  Get rid of **EMPTY_WIKI_NAME** in group_vars/all/config... what is it for? I assume it's some kind of chicken and egg thing, but I don't think we need it.

5.  Add support for separating wiki host from db host. See <https://gist.github.com/halberom/0663ef9933360fcf7141> for gist on how to use 'gather_facts' on one group of hosts (e.g. db servers) to fill out a template for another set of hosts (web servers).

6.  replace usage of **MYSQL_WIKI_PASSWORD** with actual random password; or user supplied password (found in ./roles/install_mediawiki and ./roles/create_new_wiki_on_db_host)

7.  Test and determine best email solution. We **do** have Pear mail installed . What about Swiftmailer?

8.  Activate the 'install lua sandbox' task

9. Add support for other distros (RHEL/Centos); especially by looking at the [meza] (https://github.com/enterprisemediawiki/meza)

### Equality Technology

1.  Create website similar to <https://fantasktic.com> to showcase that we can migrate MediaWiki

2. Discussions with Lex

    1.  Press Release

### Back Burner

1.  Create documentation of features (deployability, software, extensions like [mw:Extension:Semantic_Glossary/Example Semantic Glossary](/mw:Extension:Semantic_Glossary/Example_Semantic_Glossary "wikilink")
    1.  Create PowerPoint / slides
2.  DONE Add vagrant deployment option (See [Vagrant](/Vagrant/))
3.  Add Search and [PdfHandler](https://www.mediawiki.org/wiki/Extension:PdfHandler) extensions
4.  Add DNSMasq (or equivalent) <http://www.nickhammond.com/vagrant-and-ansible-for-local-development/> <https://help.ubuntu.com/community/Dnsmasq> to make resolver easier for .dev or .local domains
5.  Add Docker option <https://docs.ansible.com/ansible/intro_inventory.html#non-ssh-connection-types> although the images provided by docker would need heavy customization, so the case for doing this is not yet clear. Perhaps a service option where 'sandbox' was the service tier would make sense however if it didn't contain the differentiating factors that make QualityBox attractive, then how would the sandbox sell the service?
6.  create the distinction between creating a db host and web host (e.g. remove 'install apache' from the qualitybox role)
7. Add Admin UI; maybe by adding the '[WikiFarm] (https://www.mediawiki.org/wiki/Extension:WikiFarm)' extension.


Goal
----

My goal is to create an automated and repeatable way to specify and deploy a "base" box which can be deployed on a number of cloud providers: namely VirtualBox for local development; Digital Ocean for ease of use and cost; AWS for larger enterprise customers who prefer to use Amazon. Future providers might include VMware.

The base box should have

1.  Ubuntu Linux 16.04 (gui/no-gui)
2.  Apache
3.  MariaDB (alternative to MySQL)
4.  PHP (and extensions)
5.  memcached
6.  jenkins?
7.  munin
8.  monit
9.  etckeeper
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


[1] <https://www.mediawiki.org/wiki/Manual>:\$wgSMTP

[2] [Email Marketing](https://freephile.org/wiki/Email_Marketing)

[3] <http://referata.com/wiki/Referata:FAQ#Does_Referata_support_secure_HTTP_.28.22HTTPS.22.29.3F>

[4] <http://referata.com/wiki/Referata:About>

[5] <http://referata.com/wiki/Referata:Features>

[6] [Using Inventory Directories and Multiple Inventory Sources](https://docs.ansible.com/ansible/intro_dynamic_inventory.html)
