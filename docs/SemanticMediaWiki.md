---
title: docs SemanticMediaWiki
permalink: /docs/SemanticMediaWiki/
---

We will also be installing Semantic MediaWiki ([github](https://github.com/SemanticMediaWiki/SemanticMediaWiki/releases))

Installing Semantic MediaWiki is best done with Composer

-   <https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Composer_with_MediaWiki_1.25%2B>
-   <https://github.com/LinuxCompetenceCenter/SemanticMediaWiki/blob/master/docs/INSTALL.md>

Global install (as root)

~~~~ {.bash}
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
~~~~

Compatibility is a big issue. For example, look at Lex's layout for SMW <https://github.com/LinuxCompetenceCenter/SemanticMediaWiki/blob/master/docs/COMPATIBILITY.md>