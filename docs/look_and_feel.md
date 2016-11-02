---
title: look and feel
permalink: /look_and_feel/
---

The QualityBox features a grid layout. There is a Top navbar, bottom footer with all your content in the middle. [1]

There are two choices for the "Look and Feel" (some projects like [Drupal](https://freephile.org/wiki/Drupal "wikilink") or [WordPress](https://freephile.org/wiki/WordPress "wikilink") call this a 'theme', while the MediaWiki project calls it a 'skin'). QualityBox offers both [Chameleon](https://github.com/wikimedia/mediawiki-skins-chameleon) and [Foreground](http://foreground.wikiproject.net/wiki/Main_Page). Both of these theme choices take the bland out of the normal MediaWiki Look and Feel. They provide not only a pleasant user experience but also one that is mobile-first; which adds to your Search Engine Optimization.

Chameleon
---------

The Chameleon skin uses Twitter's [Bootstrap](https://freephile.org/wiki/Bootstrap "wikilink") 3 to provide a customizable MediaWiki skin. Not only can you customize the layout internally, but you can also adapt it using free drop-in replacement CSS from places like <https://bootswatch.com/> [2]

Chameleon Documentation
-----------------------

<https://github.com/wikimedia/mediawiki-skins-chameleon/blob/master/docs/index.md> [3]

Foreground
----------

Foreground is used by WikiApiary

One great thing about Foreground is that it's based on [Foundation](http://foundation.zurb.com/) (by Zurb) [4]

One distinct problem with Foreground is that it's based on **[Foundation 4](https://github.com/zurb/foundation-sites)** (two versions out-of-date). There is a branch for Foundation 5 <https://github.com/thingles/foreground/tree/feature/foundation5>, but I believe development has stalled on compatibility issues [5][6] with newer Foundation and the markup clashing with what's allowed by the MediaWiki parser. I'll ping the community to find more detail on the status and/or other good options. This skin is used by WikiApiary so I expect there to be relatively good support and active development for it. But it looks instead like WikiApiary is stuck because of the evolution of Foreground has made it incompatible with the wiki parser. The mailing list is inactive. The developers are Garrick van Buren, Jamie Thingelstad, Tom Hutchison Chameleon may be the better option at this point.

Foreground Highlights
---------------------

-   MediaWiki on top and at the bottom, nothing but content in the middle.
-   [Tabs](http://foreground.wikiproject.net/wiki/Tabs|Useful). Built-in and responsive tabs. Better and faster than HeaderTabs extension.
-   [Typography](http://foreground.wikiproject.net/wiki/Type|Smart). ?hoose the design of the text that you need.
-   [Layout](http://foreground.wikiproject.net/wiki/Grid|Grid). Place your information efficiently on desktop and mobile devices
-   Full support of [Font Awesome](http://fortawesome.github.io/Font-Awesome/) (v4.3)!
-   Simple customization <http://foreground.wikiproject.net/wiki/Customizing>

Foundation 4 Documentation
--------------------------

<http://foundation.zurb.com/sites/docs/v/4.3.2/>

[1]  Need screenshot of finished demo site

[2]  test implementation of the '[spacelab](https://bootswatch.com/spacelab/)' and 'paper' themes

[3]  Actually add Chameleon. Since it's not a download, but rather installed with composer, the steps will be different than the current Vector and Foreground aka shell: composer require "mediawiki/chameleon-skin:\~1.0" Test the implementation and also reconfigure the whole layout of the 'farm' configs and overrides

[4] Foundation is a Framework for any device, medium, and accessibility. Foundation is a family of responsive front-end frameworks that make it easy to design beautiful responsive websites, apps and emails that look amazing on any device. Foundation is semantic, readable, flexible, and completely customizable. We’re constantly adding new resources and code snippets, including these handy HTML templates to help get you started! - description by Zurb

[5] <https://github.com/thingles/foreground/issues/82>

[6] <https://github.com/thingles/foreground/pull/102>