# modsecurity-trustwave-rule-downloader
Script to Download ModSecurity Rules

This script is for downloading the Trustwave Commercial ModSecurity Ruleset to a cPanel server.

Download the script to a secure folder on your cPanel server.
``` text
git clone
```
Edit the details and put in your login information
``` text
vi trustwave-rule-download.pl
```

Edit your /etc/httpd/conf/modsec2.user.conf and link to the rules you want to use:

``` text
vi /etc/httpd/conf/modsec2.user.conf
```

and insert:
``` text
# Include Trustwave Commercial Modsecurity Rules
Include conf/slr_vuln_rules/modsecurity_slr_10_ip_reputation.conf
Include conf/slr_vuln_rules/modsecurity_slr_46_known_vulns.conf
Include conf/slr_vuln_rules/modsecurity_slr_50_malware_detection.conf
Include conf/slr_vuln_rules/owasp_crs_integration/application_specific/*.conf
Include conf/slr_vuln_rules/botnet_attacks/*.conf
# Include conf/slr_vuln_rules/creditcard_tracking/*.conf
# Disabled credit card tracking as was creating false positives for clients.
Include conf/slr_vuln_rules/dos_attacks/*.conf
Include conf/slr_vuln_rules/webshell_backdoors/*.conf

```
