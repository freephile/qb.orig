---
title: Apache
permalink: /Apache/
---

Features
--------

QualityBox includes these Apache Utilities <https://httpd.apache.org/docs/current/programs/> (e.g. Apache Bench, split-logfile)

We are currently using the `libapache2-mod-php5` package to provide the PHP5 module for the Apache 2 webserver (as found in the apache2-mpm-prefork package). Please note that this package ONLY works with Apache's prefork MPM, as it is not compiled thread-safe.The following extensions are built in: bcmath bz2 calendar Core ctype date dba dom ereg exif fileinfo filter ftp gettext hash iconv libxml mbstring mhash openssl pcre Phar posix Reflection session shmop SimpleXML soap sockets SPL standard sysvmsg sysvsem sysvshm tokenizer wddx xml xmlreader xmlwriter zip zlib

We may want to offer different versions of Apache (worker) or PHP (fcgi), or webserver (nginx)

Mass Virtual Hosting
--------------------

We'll use **mod_vhost_alias** with [name based virtual hosting](https://en.wikipedia.org/wiki/Virtual_hosting#Name-based)

-   [Apache Module mod_vhost_alias](https://httpd.apache.org/docs/current/mod/mod_vhost_alias.html)
-   Docs: <https://httpd.apache.org/docs/current/vhosts/mass.html>
-   See [How to configure SSL with apache2/httpd mass virtual hosting using mod_vhost_alias](https://serverfault.com/questions/390048/how-to-configure-ssl-with-apache2-httpd-mass-virtual-hosting-using-mod-vhost-ali) for an example

Consider use of [mod_macro](https://httpd.apache.org/docs/current/mod/mod_macro.html) for defining repetitious sections of virtual hosts

See [docs/farm](/docs/farm "wikilink") for the filesystem layout

### Logging

<https://httpd.apache.org/docs/current/programs/split-logfile.html>

~~~~ {.apache}
# instead of this
LogFormat "%V %h %l %u %t \"%r\" %s %b" vcommon
CustomLog "${APACHE_LOG_DIR}/access.log" vcommon
#  use %V, not %v when using mod_vhost_alias
LogFormat "%V %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" combined_plus_vhost
CustomLog "${APACHE_LOG_DIR}/access.log" combined_plus_vhost
~~~~

Execute from the command line (move to cron) [1]

~~~~ {.bash}
split-logfile < access.log
~~~~

File Descriptors
----------------

File descriptor limits can become an issue when you want to do mass virtual hosting. <https://httpd.apache.org/docs/current/vhosts/fd-limits.html> `man setrlimit`
`ulimit -u`

On one site we visited, it's huge

    [root@d905-2 exampleWiki]# ulimit -u
    256560
    greg@p2-wiki-nyc1-01:/var/www/html/exampleWiki$ ulimit -u
    7879

On a stock Ubuntu, it's better than a stock RHEL5 (1024), but still may need an upward tweak eventually. Apache only uses about 20-30 file handles, plus one for each log file. So, it's really only an issue if you're hosting hundreds or thousands of websites.

Role
----

In the QualityBox role, we have a task `install_apache.yml` that simply handles the installation of the service, and also the modules (mod_rewrite, mod_vhost_alias)

There are three **roles** (in MTAW) that take various aspects of Apache installation and configuration

1.  **deploy_mw_host** actually configures Apache (Listen, includes, copy index.php. But, it also does a bunch more too like squid, php, composer, and lua. We would have to decompose this stuff and make it Ubuntu compatible. <ref> Here is the list of packages for example. We either don't need them, or already have them installed

<!-- -->

        - libselinux-python (replaced by AppArmor)
        - policycoreutils-python (replaced by AppArmor)
        - gcc (why? not installed)
        - openssl-devel  (we have openssl, and libssl-dev by default)
        - libcurl-devel (we have libcurl3, but not libcurl4 or any of the dev flavors)
        - gettext (default - internationalization)
        - expat-devel (libexpat1:amd64, libexpat1-dev:amd64)
        - perl-ExtUtils-MakeMaker (why? we don't have any libextutils installed)
        - php (have; see install_php)
        - php-ldap (added to install_php)
        - php-mbstring (have; see install_php; part of libapache2-mod-php5)
        - php-xml (have; see install_php; part of libapache2-mod-php5)
        - php-pecl-apcu (commented; see install_php; php5_apcu is the APC User Cache for PHP 5)
        - php-mysqlnd (have; see install_php)
        - php-pear-Mail (equiv. is php_mail - Class that provides multiple interfaces for sending emails) I don't believe we need this in 1.27 see: Email_Marketing#MediaWiki I believe we want https://www.mediawiki.org/wiki/Extension:SwiftMailer)
        - mysql (have mariadb)
        - MySQL-python (have python_mysqldb; see "install python and libraries")
        - httpd (have; see install Apache)
        - ImageMagick (have imagemagick)
        - squid (not installed)
        - bzip2 (added)

These packages were integrated into the 'install miscellaneous packages' task. In particular, we eliminated the SELinux and PolicyCore Utilities because Ubuntu uses [AppArmor](https://wiki.ubuntu.com/AppArmor) by default. Although enabled by default (apparmor_status), we might need to implement some profiles like `/etc/apparmor.d/abstractions/apache2-common` </ref>

1.  **create_new_wiki_on_db_host** does the database tasks (not really Apache)
2.  **create_new_wiki_on_mw_host**
    1.  the .conf file
    2.  branding, images, temp, and thumb directories
    3.  update.php (run with WIKI_NAME)

Examples
--------

Nick Hammond has a simple example for using nginx in a Vagrant/Ansible environment <http://www.nickhammond.com/vagrant-and-ansible-for-local-development/>

Performance Tuning
------------------

See

1.  [Apache/performance](https://freephile.org/wiki/Apache/performance "wikilink")
2.  [Open Exchange knowledgebase](http://oxpedia.org/wiki/index.php?title=Tune_apache2_for_more_concurrent_connections). Aside: good example of nice (proprietary? 'ox') skin and also an example of an open business
3.  [How To Tune Apache on Ubuntu 14.04 Server](https://serverfault.com/questions/684424/how-to-tune-apache-on-ubuntu-14-04-server) (ServerFault)
4.  [How To Optimize Apache Web Server Performance](https://www.digitalocean.com/community/tutorials/how-to-optimize-apache-web-server-performance) (DO)

Apache Status
-------------

remember to modify the conf. I think the module is enabled by default in Ubuntu, but you need to modify the conf (add remote IP) if you want to see status via the web at a URL like <http://example.com/server-status> (yet hide it from the world at large)

~~~~ {.bash}
vim /etc/apache2/mods-enabled/status.conf
service apache2 reload
apache2ctl fullstatus
~~~~

[1] Note that you need the apache2-utils package in Ubuntu to get split-logfile