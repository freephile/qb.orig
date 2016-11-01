---
title: docs business
permalink: /docs/business/
---

<li>
Respond to pent up developer demand in the WikiMedia Foundation / MediaWiki community

1.  E.g. [Provide a web interface for customizing an MediaWiki instance and provisioning it in the cloud or locally](https://phabricator.wikimedia.org/T53782) (phabricator issue T53782)
2.  See the [MediaWiki-Vagrant workboard](https://phabricator.wikimedia.org/project/view/627/) (phabricator)
3.  post/insert the QualityBox project into these various communities / forums / mailing lists e.g. <https://www.mediawiki.org/wiki/Project:WikiFarm> <https://www.mediawiki.org/wiki/Project:WikiFarm>

<li>
The MWF has not met the need / demand of it's own constituents because they are 3rd-party

1.  [Have a MediaWiki vagrant role "production" which mirrors WMF production](https://phabricator.wikimedia.org/T91787) (Phabricator issue T91787) started in Mar. 2015 Last updated at Nov. 2015
2.  [Examine ways to make using MediaWiki-Vagrant secure (or at least not wildly insecure) on a host exposed to the Internet](https://phabricator.wikimedia.org/T92971) Software Engineer working for MWF gets site hacked because he used the only tool available to him: MediaWiki-Vagrant; outside the coddled (fire)walls of the WMF labs.

> MW-Vagrant is the only way to set up MediaWiki (with all the trimmings – Parsoid, VisualEditor, background job runners, etc) without hours of effort and dependency hell [1]

</ol>
Funding / Marketing / Grow Community
------------------------------------

<li>
See about getting a grant from wikimedia for travel/presentation and/or getting sponsorship for the project itself <https://meta.wikimedia.org/wiki/Grants:TPS/Learn>

<li>
Nicolas Nallet and Sébastien Beyou developed the [MediaWiki Farm extension](/mw:Extension:MediaWikiFarm "wikilink") [2] [3]

<li>
Put links to QualityBox in various online resources where it should be listed: <https://en.wikibooks.org/wiki/Starting_and_Running_a_Wiki_Website/Hosted_Wikis>

</ol>
Business Strategy
-----------------

1.  Build partnership with Lex for development and marketing on a global scale <http://www.linux-competence-center.ch/Team.htm> <https://dataworking4you.com/>
2.  Build a solution that other agencies will want to use; make it free for them to use until they invite their clients to pay for it (like Pantheon does)
3.  **Build a site like Fantasktic** <https://fantasktic.com/wordpress-support/> **There are companies out there like Fantasktic who support WordPress. Who supports MediaWiki? We do**
    1.  Study other Wiki Hosting services. Be familiar with the competition and the marketplace [Comparison of wiki hosting services](/wp:Comparison_of_wiki_hosting_services "wikilink")
    2.  [wp:Wikia](/wp:Wikia "wikilink") know these from a strategy perspective, as well as a marketing perspective. How does QualityBox fill a need similar or distinct from these services. Know at least a superficial level how QualityBox service is better or different than these services - incorporate that into the marketing message (or "response" card).
    3.  [wp:Wikispaces](/wp:Wikispaces "wikilink")
    4.  [[wp:Wikidot]

4.  Model QualityBox plans and pricing like <https://wpengine.com/> WPEngine **We are the hosting solution for MediaWiki** WPEngine is the best managed WordPress hosting in the world. They have VC money and thousands of customers. Who does hosting for MediaWiki? We do.
5.  Create hosting solution for MediaWiki sites while using Pantheon as a partner for Drupal and Wordpress hosting
6.  How does CiviCRM fit into the picture?
7.  Market as complement to Slack and better alternative to Microsoft Scarepoint. Pricing could be per seat tiers like Slack pricing <https://slack.com/pricing>; or host size based
8.  [Rocket.chat](https://rocket.chat/) is both interesting as an example for packaging/automation across multiple platforms (see their github) **and** also as a service to use internally or as part of QualityBox

Alternatives
------------

### Debian Packages

You can now install 1.27 from Debian [4] Of course this only gives you the 'basic' extensions so it's not comparable, and it doesn't keep your installation updated etc. However, for some who are not ready for QualityBox, then it's a great alternative. You can browse the code at <https://phabricator.wikimedia.org/diffusion/MDEB/> or clone it from <https://phabricator.wikimedia.org/diffusion/MDEB/mediawiki-debian.git>

~~~~ {.bash}
sudo add-apt-repository ppa:legoktm/mediawiki-lts
sudo apt-get update
sudo apt-get install mediawiki
~~~~

Competitors
-----------

### Roots.io

The [Roots guys](https://roots.io/) are doing for WordPress a lot of what QualityBox is doing for MediaWiki

They are focused on the

1.  platform (Trellis) <https://github.com/roots/trellis>
2.  app (Bedrock)
3.  design/theme (Sage)

-   <https://discourse.roots.io/t/failure-to-establish-connection-when-provisioning-via-ansible-playbook-server-yml/6518>
-   [Doing 16.04 on Digital Ocean](https://discourse.roots.io/t/trellis-ubuntu-16-04-do/6551)

### BitNami

You'll never see QB at \$5/mo, but QB should look at what BitNami is doing in the Google Cloud platform as a comparison https://console.cloud.google.com/launcher/details/bitnami-launchpad/mediawiki?q=MediaWiki  (TLDR: Really generic MediaWiki)


Origins
-------

This whole project grew out of discussions with Cindy and Lex at Enterprise MediaWiki Con in NYC 2016. There are other influencers such as Jeff Geerling and Protobox and MediaWiki-Vagrant.

[1] Andrew Garrett (Werdna) *Software Engineer*, WikiMedia Foundation <https://phabricator.wikimedia.org/T92971>

[2] <https://etherpad.wikimedia.org/p/mwstake20160928>

[3] [presentation from EMWCon 2016](https://upload.wikimedia.org/wikipedia/mediawiki/1/1d/MediaWikiFarm_Extension_Presentation.pdf)

[4] <https://www.mediawiki.org/wiki/User:Legoktm/Packages>