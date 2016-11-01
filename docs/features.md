---
title: docs features
permalink: /docs/features/
---

The emphasis is on a complete feature set, quality, performance, and security that is turn-key, simple to use, and supported.

<li>
Free SSL included. **https**://wiki.example.com

</ol>
Enterprise features
-------------------

<li>
String Functions (via Scribunto and Lua)

<li>
Links to your Windows shared resources via **Universal Naming Convention** ([UNC links](https://mediawiki.org/wiki/UNC_links "wikilink")) are supported.

<li>
Beautiful, responsive, mobile-first [docs/look and feel](/docs/look_and_feel "wikilink")

<li>
Clean URLs for easier use, better SEO.

<li>
REST-like action verbs extend "Clean URLs" to include all the regular user interactions like 'edit' and 'history'

<li>
Advanced "[Document Not Found](https://freephile.com/wiki/404 "wikilink")" handling

<li>
Licensing selections in the "Upload" form. This is part of the pre-loaded content which makes QualityBox a turn-key system.

<li>
"Help" content included. This is part of the pre-loaded content which makes QualityBox a turn-key system.

<li>
Flexible powers for Site Administrators to delete content

</ol>
Special Services
----------------

Of course the creators of QualityBox offer additional support and special services. Some of those services include

<li>
Make it so that your wiki can NOT be exported by a user -- even the admin (not recommended) [3]

<li>
Disable the API (not recommended)

<li>
Delete archived files -- either due to sensitive content, or to reduce disk space requirements [4]

</ol>

list additional services, including maintenance scripts add multi-lingual wiki features 

[1] `$wgPFEnableStringFunctions = true;` and `array_push($wgUrlProtocols, "file://");`

[2] In 2013, it was determined that this extension would never be enabled on Wikimedia wikis (see phabricator:T8455). As a workaround, use String-handling templates or [Module:String](/Module:String "wikilink") <https://www.mediawiki.org/wiki/Extension:StringFunctions>

[3] [mw:Manual:Parameters_to_Special:Export](https://www.mediawiki.org/wiki/Manual:Parameters_to_Special:Export "wikilink")

[4] [mw:Manual:DeleteArchivedFiles.php](https://www.mediawiki.org/wiki/Manual:DeleteArchivedFiles.php "wikilink")