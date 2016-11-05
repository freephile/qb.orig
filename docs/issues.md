---
title: issues
permalink: /issues/
---

Open Issues
----

See <https://github.com/freephile/qb/issues> for open issues.


Report a Bug
------------

Please post any bugs or work items to the [issue queue](https://github.com/freephile/qb/issues) at GitHub


ToDo
----

*The items below will shortly be transferred to the [issue queue](https://github.com/freephile/qb/issues)*

### QB

1. Right now, working on a new branch to integrate the [MediaWikiFarm extension](https://www.mediawiki.org/wiki/Extension:MediaWikiFarm)
* [install](https://github.com/wikimedia/mediawiki-extensions-MediaWikiFarm/blob/master/docs/installation.rst)

2.  Make sure the mail system is working (add extra configuration for MediaWiki [1] to tie in with clients mail system?) or set this up as a hosting feature with SendGrid/et al. [2] as the underlying service shared by all domains on a plan

4.  Get rid of **EMPTY_WIKI_NAME** in group_vars/all/config... what is it for? I assume it's some kind of chicken and egg thing, but I don't think we need it.

5.  Add support for separating wiki host from db host. See <https://gist.github.com/halberom/0663ef9933360fcf7141> for gist on how to use 'gather_facts' on one group of hosts (e.g. db servers) to fill out a template for another set of hosts (web servers).

6.  replace usage of **MYSQL_WIKI_PASSWORD** with actual random password; or user supplied password (found in ./roles/install_mediawiki and ./roles/create_new_wiki_on_db_host)

7.  Test and determine best email solution. We **do** have Pear mail installed . What about Swiftmailer?

8.  Activate the 'install lua sandbox' task

9. Add support for other distros (RHEL/Centos); especially by looking at the [meza](https://github.com/enterprisemediawiki/meza)

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
7. Add Admin UI; maybe by adding the '[WikiFarm](https://www.mediawiki.org/wiki/Extension:WikiFarm)' extension.

