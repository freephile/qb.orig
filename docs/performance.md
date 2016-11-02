---
title: performance
permalink: /performance/
---

Performance is both technical and a major point in the marketing of the platform. See [business] (business)

Do we install [APC](https://freephile.org/wiki/PHP_Accelerator) or other cache discussed in the manual[1]?

Performance optimizations need to be considered in all layers/service components

1.  Platform considerations (box size and other parameters) as well as box loading (when do we scale a customer up?)
2.  Memcache, etc. for OS
3.  Apache tuning for performance characteristics
    1.  Aside from `ab` to measure capacity and benchmarking, we could also use `apachetop` to measure the volume on the production server.

4.  Database tuning for performance and caching, master/slave read/write
5.  Application settings for take advantage of the above caching and configurations as well as internal performance tweaks (internal caching, job run rate, etc.)

See Also
--------

<https://www.mediawiki.org/wiki/User:Aaron_Schulz/How_to_make_MediaWiki_fast>

[1] <https://www.mediawiki.org/wiki/Manual:Cache%C2%A0>