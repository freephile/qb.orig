---
title: SemanticMediaWiki
permalink: /SemanticMediaWiki/
---

We will also be installing Semantic MediaWiki ([github](https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases))

Installing Semantic MediaWiki is best done with Composer... which is how we deal with all extension management in QualityBox

-   <https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Composer_with_MediaWiki_1.25%2B>
-   <https://github.com/LinuxCompetenceCenter/SemanticMediaWiki/blob/master/docs/INSTALL.md>



Help
----

Note that if you don't have Composer yet, here is how you would do a global install (as root)

~~~~ {.bash}
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
~~~~

Compatibility is a big issue for SMW. For example, look at [Lex's layout for SMW](https://github.com/LinuxCompetenceCenter/SemanticMediaWiki/blob/master/docs/COMPATIBILITY.md) This is not such a problem when you manage the requirements with Composer -- it's just a note that it's very version-dependent as to what MW is compatible with what SMW etc.