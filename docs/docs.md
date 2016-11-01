---
title: docs docs
permalink: /docs/docs/
---

1.  Expand on the Readme

2.  List the extensions,

3.  Pull content from the [Features](https://freephile.org/wiki/Features "wikilink") page into the [docs/features](/docs/features "wikilink") page

4.  Consult [mw:Manual:composer.json best practices](https://mediawiki.org/wiki/Manual:composer.json_best_practices "wikilink") and convert Html2Wiki to use Composer

Extensions
----------

Extensions are installed using [Composer](https://freephile.org/wiki/Composer "wikilink")[1][2]. There are some intractable problems associated with using Composer in a wikifarm setup [3]. If a QualityBox customer requires an extension that conflicts with the extensions featured in QualityBox; or if a QualityBox customer requires that a feature be disabled (aka removed), then that will require a **CustomBox**.

Since both MediaWiki core and Extensions rely on Composer, the [Composer merge plugin](https://github.com/wikimedia/composer-merge-plugin) is responsible for merging multiple composer.json files at Composer runtime.

Performance is enhanced by loading multiple extensions with the new Extension Registration format (v. using the deprecated entry point 'require' format) and using APC [4]

See Also
--------

[docs/features](/docs/features "wikilink")

[1] As of [mw:MediaWiki 1.22](https://mediawiki.org/wiki/MediaWiki_1.22 "wikilink"), you can use [Composer](http://getcomposer.org/) to install MediaWiki extensions which include a `composer.json` manifest and are published on the [Packagist](https://packagist.org/) package repository.

[2] <https://gerrit.wikimedia.org/r/#/c/93120/>

[3] see [mw:Composer/For extensions](https://mediawiki.org/wiki/Composer/For_extensions "wikilink") Normally, you install the extension with Composer (which installs the files and handles the dependencies; plus creates an autoloader). Then you activate the extension with the `wfLoadExtension` in `LocalSettings.php`. The problem with a wikifarm is how to conditionally activate the extension. The best approach is to conditionally load an extra LocalSettings.php for your farm instances. But you won't be able to **deactivate** an extension (e.g. to substitute ExtB for ExtA or disable ExtA altogether.) Historical discussion at [RfC: Extension management with Composer](https://phabricator.wikimedia.org/T467#1343633) and <https://github.com/composer/composer/issues/4109>

[4] [mw:Manual:Extension registration](https://mediawiki.org/wiki/Manual:Extension_registration "wikilink") Extensions that are loaded together with wfLoadExtension**s** (with plural -s) will be cached together.