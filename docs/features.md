---
title: features
permalink: /features/
---

The emphasis is on a complete feature set, quality, performance, and security that is turn-key, simple to use, and supported.


Free SSL included. **https**://wiki.example.com


Enterprise features
-------------------

1. String Functions (via Scribunto and Lua)
1. Links to your Windows shared resources via **Universal Naming Convention** ([UNC links](https://mediawiki.org/wiki/UNC_links)) are supported.
1. Beautiful, responsive, mobile-first [look and feel](/look_and_feel)
1. Clean URLs for easier use, better SEO.
1. REST-like action verbs extend "Clean URLs" to include all the regular user interactions like 'edit' and 'history'
1. Advanced "[Document Not Found](https://freephile.com/wiki/404)" handling
1. Licensing selections in the "Upload" form. This is part of the pre-loaded content which makes QualityBox a turn-key system.
1. "Help" content included. This is part of the pre-loaded content which makes QualityBox a turn-key system.
1. Flexible powers for Site Administrators to delete content


Special Services
----------------

Of course the creators of QualityBox (MWStake / partner directory) offer additional support and special services. Some of those services include

1. Make it so that your wiki can NOT be exported by a user -- even the admin (not recommended) <sup>[3](#footnote3)</sup>
1. Disable the API (not recommended)
1. Delete archived files -- either due to sensitive content, or to reduce disk space requirements <sup>[4](#footnote4)</sup>
@todo list additional services, including maintenance scripts  
@todo add multi-lingual wiki features (language pack)  

Footnotes
---------

<a name="footnote1">[1]</a> `$wgPFEnableStringFunctions = true;` and `array_push($wgUrlProtocols, "file://");`  
<a name="footnote2">[2]</a> In 2013, it was determined that this extension would never be enabled on Wikimedia wikis (see phabricator:T8455). As a workaround, use String-handling templates or [Module:String](https://freephile.org/wiki/Module:String)  <https://www.mediawiki.org/wiki/Extension:StringFunctions>  
<a name="footnote3">[3]</a> [https://mediawiki.org/wiki/Manual:Parameters_to_Special:Export](https://www.mediawiki.org/wiki/Manual:Parameters_to_Special:Export "wikilink")  
<a name="footnote4">[4]</a> [https://mediawiki.org/wiki/Manual:DeleteArchivedFiles.php](https://www.mediawiki.org/wiki/Manual:DeleteArchivedFiles.php "wikilink")  