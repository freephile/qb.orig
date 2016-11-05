---
title: farm
permalink: /farm/
---

Farm Design
-----------

Our farm design is based on the principle that we want to be able to put multiple wikis on the same host, each being distinct wikis, sharing the same codebase. Since each organization (domain) Our entire installation should seem as 'normal' as possible to a regular Ubuntu server - even though it is configured and controlled by Ansible.

Each client organization may have more than one wiki, and we'd want to put them together, so wikis will be grouped by TLD first: Given and organization **ACME Widgets** having 3 top level domains of acme.org, acme.com, acme.net we would point the .net and .org domains to the Canonical domain of acme.com in the webserver. Thus only the canonical domain (acme.com) would be present on the filesystem in the server root. Within the organization, if they want multiple wikis, we will find multiple subdirectories for the organization:

    /var/www/       <== Apache server root
    |-- clients        <== Wiki instance directory (holds legitimate domains)
    |   `-- acme.com
    |       `-- wiki.acme.com
    |       `-- software.acme.com
    |       `-- research.acme.com

Each of these would be distinct virtual hosts with distinct wikis and databases. If there is no subdomain (ie. the canonical domain for the wiki is acme.com without 'wiki' or 'www', etc. then there will be a similar 'bare' subdirectory: acme.com/acme.com

Optionally, but not yet implemented, we could offer "project" wikis that are based on a subdirectory.  (With the impending implementation of MediaWiki Farm extension, this will be supported.) E.g.

    /var/www/
    |-- clients
    |   `-- acme.com
    |       `-- wiki.acme.com
    |       `-- software.acme.com
    |           `-- slicer                                <== https://software.acme.com/slicer/Main_Page
    |           `-- dicer                                 <== https://software.acme.com/dicer/Main_Page
    |           `-- chopper                            <== https://software.acme.com/chopper/Main_Page
    |       `-- research.acme.com

Questions
---------


Should we support **Aliases**? There is the form of differing sub-domains e.g. wiki.example.com and kb.example.com both representing the same thing; and/or the form of multiple TLDs representing the same thing, e.g. kb.acme.org kb.acme.com kb.acme.net. We'd need to ensure that DNS resolves for all aliases, and configure Apache with the alias.


If aliases are supported, we need to redirect to the **Canonical Name** e.g. given that wiki.example.com and kb.example.com represent one website, we need to know which is authoritative, and Alias the other.


### Mass Virtual Hosting

-   wiki.example.com
-   wiki.foundation.org
-   wiki.nasa.gov

Each wiki is an independent organization. Shared codebase. The impetus to use the farm configuration is to offer simple managed services. Can still offer customizations to each organization: custom logo, custom 'local' extensions. They can not choose to uninstall 'common' extensions which are part of the platform. Each wiki has it's own database or db prefix

### Sub-wikis

Sub-wikis represent additional complexity, features and cost (to be implemented shortly)

-   wiki.foundation.org/project1
-   wiki.foundation.org/project2
-   wiki.foundation.org/project3

Note: Cindy's solution uses this layout where 'WIKI_NAME' is equivalent to the first 'folder' in the request. `SetEnvIf Request_URI "^/([^/]+)" WIKI_NAME=$1`

Some organizations may want to have multiple wikis which also share certain aspects:

-   shared images (including branding)
-   shared user accounts (central auth or single login)
-   interwiki links

Sub wikis could present additional features, by aggregating wiki stats or administration

-   shared dashboards
-   shared logs
-   shared administrative links
-   federated search

Filesystem layout
-----------------

~~~~ {.Apache}
VirtualDocumentRoot "/var/www/clients/%-2/%0/w"
VirtualScriptAlias  "/var/www/clients/%-2/%0/cgi-bin"
~~~~

For wiki.example.com, the Document Root will be /var/www/clients/example.com/wiki.example.com comtaining a subdirectory **w** where 'w' is a symbolic link to /var/www/_mw/mediawiki and furthermore, 'mediawiki' itself is a symbolic link to the release version of the software (e.g. mediawiki-REL1_27) running for that client. Our layout would be <sup>[1](#footnote1)</sup>

    /var/www/
    |-- clients
    |   `-- example.com                     <== capable of holding multiple sites for a domain / client
    |       `-- wiki.example.com              <== the subdomain (which can still hold multiple (custom) software installs besides mediawiki)
    |           `-- w -> ../../../_mw/mediawiki <== the mediawiki codebase is at 'w'
    |-- html
    |   `-- index.html
    `-- _mw
        |-- farm
        |   |-- Debug.php
        |   |-- Email.php
        |   |-- GlobalExtensions.php
        |   |-- Keys.php
        |   |-- LocalExtensions.php
        |   |-- Permissions.php
        |   |-- Server.php
        |   `-- Upload.php
        |-- mediawiki -> mediawiki-REL1_27
        `-- mediawiki-REL1_27
            |-- api.php
            |-- autoload.php
            |-- cache
            |-- composer.json
            |-- composer.local.json-sample
            |-- composer.lock
            |-- COPYING
            |-- CREDITS
            |-- docs
            |-- extensions
            |   `-- README
            |-- FAQ
            |-- Gemfile
            |-- Gemfile.lock
            |-- Gruntfile.js
            |-- HISTORY
            |-- images
            |   `-- README
            |-- img_auth.php
            |-- includes
            |-- index.php
            |-- INSTALL
            |-- jsduck.json
            |-- languages
            |-- load.php
            |-- LocalSettings.php
            |-- maintenance
            |-- mw-config
            |-- opensearch_desc.php
            |-- package.json
            |-- phpcs.xml
            |-- profileinfo.php
            |-- Rakefile
            |-- README
            |-- README.mediawiki -> README
            |-- RELEASE-NOTES-1.27
            |-- resources
            |-- serialized
            |-- skins
            |   `-- README
            |-- StartProfiler.sample
            |-- tests
            |-- thumb_handler.php
            |-- thumb.php
            |-- UPGRADE
            |-- vendor
            |   |-- autoload.php
            |   |-- bin
            |   |-- composer
            |   |-- cssjanus
            |   |-- data-values
            |   |-- doctrine
            |   |-- jakub-onderka
            |   |-- jeroen
            |   |-- justinrainbow
            |   |-- liuggio
            |   |-- mediawiki
            |   |-- monolog
            |   |-- nikic
            |   |-- nmred
            |   |-- onoi
            |   |-- oojs
            |   |-- oyejorge
            |   |-- param-processor
            |   |-- phpdocumentor
            |   |-- phpspec
            |   |-- phpunit
            |   |-- psr
            |   |-- sebastian
            |   |-- serialization
            |   |-- squizlabs
            |   |-- symfony
            |   |-- webmozart
            |   |-- wikimedia
            |   `-- zordius
            `-- wiki.phtml


Farms in MediaWiki Vagrant
--------------------------

[Create a Wikifarm role for MediaWiki-Vagrant](https://phabricator.wikimedia.org/T54721) (Phabricator issue T54721)

MediaWiki-Vagrant uses a variation of the MWMultiVersion wikifarm configuration used by the WMF production wikis. This support was initially added two years ago with the introduction of role::centralauth. It was later made the default configuration system so that even when no roles are enabled and only a single wiki is provisioned that wiki uses the multi-wiki config system.

In MediaWiki-Vagrant there is a role Flow which depends on the role centralauth. After enabling Flow (and provisioning and waiting for an hour) you'll end up with a farm consisting of

-   dev.wiki.local.wmftest.net
-   login.wiki.local.wmftest.net
-   centralauthtest.wiki.local.wmftest.net
-   fr.wiki.local.wmftest.net
-   frwiktionary.wiki.local.wmftest.net
-   he.wiki.local.wmftest.net
-   zhwikivoyage.wiki.local.wmftest.net

For existing registered users on your localhost (dev.wiki.local.wmftest.net) you have to manage your global account in preferences. If you don't you get an error page at login.wiki.local.wmftest.net after log in and you have to go manually to dev.wiki.local.wmftest.net to find your wiki where you are logged in.

Wikis are added using the mediawiki::wiki Puppet resource via a role.

Farm Extensions
---------------

- <https://www.mediawiki.org/wiki/Extension:WikiFarm> looks interesting. However, it's old (not maintained)
- [Extension:MediaWikiFarm](https://www.mediawiki.org/wiki/Extension:MediaWikiFarm) Bingo!  This is what we are integrating into QualityBox

Footnotes
---------

<a name="footnote1">[1]</a> See [Unicode tricks](https://freephile.org/wiki/Unicode_tricks "wikilink") because this editor is not Unicode safe. In order to get ascii layout, use `--charset=asci` in your `tree` command.