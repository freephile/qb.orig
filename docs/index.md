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

* Jean Christophe Fillion-Robert {% include icon-github.html username="jcfr" %}
* [Cindy Cicalese](https://www.mediawiki.org/wiki/User:Cindy.cicalese)
* Yaron Koren {% include icon-github.html username="yaronkoren" %}
* Steve Pieper {% include icon-github.html username="pieper" %}
* Greg Rundlett {% include icon-github.html username="freephile" %}
* Lex Sulzer {% include icon-github.html username="lexsulzer" %}

Motivation
----------

Why does QualityBox exist?  Because MediaWiki is an awesome piece of software that powers one of the greatest achievements of the Internet: [Wikipedia](https://www.wikipedia.org).  The MediaWiki software is ***freely*** licensed under the GPL, so naturally thousands of organizations use it locally for intranets, documentation websites, fan sites etc.  It's heavily used by the software development industry itself.  But like any [modern internet application](https://upload.wikimedia.org/wikipedia/commons/5/51/Wikipedia_webrequest_flow_2015-10.png), the software has grown in complexity over time; thus making it very difficult to deploy for even experienced software developers or system administrators.  Not only is it hard to deploy (nb. the one-click installers fall short), there are also many many aspects that need to be added to a MediaWiki installation to make it "fully furnished"; to a point where you can just "move right in" and begin using it.  

You need to add at least a "starter pack" [set of templates](https://www.mediawiki.org/wiki/Template_repository). You need a long list of extensions; and while roughly a dozen excellent ones are distributed with MediaWiki in the default tarball, there are approximately 50 must-have extensions integrated into the QualityBox. No software is great without great documentation, so we include all the essential Help (aka documentation). Plus, QualityBox includes lots of other [features](/features/) like security, monitoring, scalability and enterprise support to make it complete.  We're even planning on optional add-on packs for specific usage scenarios like setting up a contact directory.  And it needs to be beautiful, flexible and graphically rich - so we have the best themes that make QualityBox both mobile-first and more intuitive; and pre-load it with a scalable vector graphic icon set and integrate it with [MediaWiki Commons](https://commons.wikimedia.org).

So [eQuality Technology](https://eQuality-Tech.com) launched QualityBox to address these needs.  And it's free as in freedom. (Freedom comes with a price: If you modify and re-distribute the code, you must share back your code -- according to the terms of the QualityBox [license](https://github.com/freephile/qb/blob/master/LICENSE).)  QualityBox makes it easy for top-notch free software consultants to offer MediaWiki hosting to their clients. QualityBox makes it easy for organizations, who respect freedom and value collaboration, to deploy QualityBox in their own infrastructure or clouds.  It's our goal that QualityBox will make MediaWiki as prevalent as WordPress is for blogs and Drupal is for websites.  Or to put it another way: there is no way that an organization should even consider Microsoft SharePoint for more than 60 seconds when QualityBox is so much more.

See also:

* [MediaWiki Stakeholder's Group](http://mwstake.org/mwstake/wiki/Main_Page)
* [MediaWiki Usage Report 2015](https://www.mediawiki.org/wiki/MediaWiki_Usage_Report_2015)

Goal
----

My goal is to create an automated and repeatable way to specify and deploy a "base" box which can be deployed on a number of cloud providers: namely VirtualBox for local development; Digital Ocean for ease of use and cost; AWS for larger enterprise customers who prefer to use Amazon. Future providers might include VMware.  Already we have both a VirtualBox local target and a DigitalOcean cloud target; and can deploy virtually anywhere we have SSH access to.

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

The process should look like

~~~~ {.bash}
cd ~/vagrant
vagrant box add quality-box /~/Downloads/quality-Wiki.box
vagrant init quality-box
vagrant up
~~~~

(See the certbot project for what looks like an advanced usage of Vagrant)

The QualityBox is based on a bare-bones Ubuntu distribution, and we modify that. We will probably begin packaging our base box to speed deploy times but that's not on the critical path for us because we create once, while managing nodes is much more important in the long run. See [Creating a base box](https://www.vagrantup.com/docs/boxes/base.html)

Pricing / Costs
---------------

### Vendor Costs

If using Docker, pricing depends on whether it's cloud or premise, and ranges from \$15/mo for a single node to \$300/mo per node for 24x7 support. Keep in mind that several "nodes" may be needed to complete a service which is scalable, modular and spans production and pre-production. Developer nodes are free.

### Comparisons

Referata.com is a great place to host a wiki for minimal cost.  And they deserve all the respect in the world. However, they currently do not support HTTPS <sup>[3](#footnote3)</sup>. And, it has a limited set of extensions <sup>[4](#footnote4)</sup>. There are 4 plans <sup>[5](#footnote5)</sup> that range in price from (free), \$20, \$50 and \$80/mo. The free tier is especially not remarkable. The only plans that offer a domain name are \$50 and \$80 with no mention of the RAM and CPU dedicated (hint: it is slow). Speaking with Yaron, the QualityBox should be priced at \$300/mo  Hopefully Referata will soon be offering QualityBox hosting.

Inventory
---------

We'll (probably?) have both static hosts (our own that we want to refer to explicitly) and dynamic hosts (clients' servers which we can refer to by naming convention or id) to operate on. This is sometimes referred to as a 'hybrid cloud'. With Ansible, you can specify an inventory directory where multiple sources are found. Executable files are treated as dynamic sources. <sup>[6](#footnote6)</sup>

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
> greg@eqt:\~/certificates\$ \~/bin/letsencrypt/letsencrypt-auto --domain wiki.example.org --apache certonly --dry-run

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

Footnotes
-----------

<a name="footnote1">[1]</a> <https://www.mediawiki.org/wiki/Manual:$wgSMTP>  
<a name="footnote2">[2]</a> [Email Marketing](https://freephile.org/wiki/Email_Marketing)  
<a name="footnote3">[3]</a> <http://referata.com/wiki/Referata:FAQ#Does_Referata_support_secure_HTTP_.28.22HTTPS.22.29.3F>  
<a name="footnote4">[4]</a> <http://referata.com/wiki/Referata:About>  
<a name="footnote5">[5]</a> <http://referata.com/wiki/Referata:Features>  
<a name="footnote6">[6]</a> [Using Inventory Directories and Multiple Inventory Sources](https://docs.ansible.com/ansible/intro_dynamic_inventory.html)
