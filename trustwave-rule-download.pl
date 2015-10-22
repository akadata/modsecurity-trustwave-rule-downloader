#!/usr/bin/perl
# This script downloads latest Commercial ModSecurity Rules from Trustwave and restarts Apache web server.
# Written by Wesley Render, OtherData <https://www.otherdata.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict; use warnings;

my $registration_email = 'your@domain.com';  # Your Trustwave Subscription Registration Email
my $license_key = 'xxxxxxxxxxxxxxxxxxxxxxxxx';  # Your Trustwave License Key
my $fromnotification_email = 'your-noreply@domain.com';  # Email which notifications come from
my $notification_email = 'your@domain.com';  # Email where notifications of failures will be sent to
my $modsecurity_rule_location = '/usr/local/apache/conf';  # Script will create a sub folder at this location to store the rules. Should NOT end with a slash.

# Put together download string
my $download_string = "\"User-Agent: $registration_email ($license_key)\"";
my $complete_download_string = "curl -o $modsecurity_rule_location/slr_vuln_latest_1.0.0.zip -f -k -H $download_string https://www.modsecurity.org/autoupdate/repository/modsecurity-slr/slr_vuln_latest/slr_vuln_latest_1.0.0.zip";
print $complete_download_string;

# Download the files
print "\n Downloading rules from Trustwave \n\n";
system($complete_download_string);
if ( $? == 0 )
{
  print "command succeeded: $!\n";
 
}
else
{
  print "Content-type: text/html\n\n";
  my $title ='Trustwave Notification';
  my $to = $notification_email;
  my $from = $fromnotification_email;
  my $subject ='Trustwave Notification';
  open(MAIL, "|/usr/sbin/sendmail -t");
  ## Mail Header
  print MAIL "To: $to\n";
  print MAIL "From: $from\n";
  print MAIL "Subject: $subject\n\n";
  ## Mail Body
  print MAIL "The trustwave rules failed to download. Please look into issue.\n";
  close(MAIL);
  print "<html><head><title>$title</title></head>\n<body>\n\n";
  ## HTML content sent, let use know we sent an email
  print "<h1>$title</h1><p>A message has been sent from $from to $to</p></body></html>";
  printf "command exited with value %d", $? >> 8;
  exit;
}

# Remove old files before unziping new ones
print "\n Removing old rule files in $modsecurity_rule_location/slr_vuln_rules \n\n";
my $remove_old_rules_command = "rm -rf $modsecurity_rule_location/slr_vuln_rules";
system($remove_old_rules_command);

# Unzip files into correct folder
print "\n Extracting rules to $modsecurity_rule_location/slr_vuln_rules \n\n";
my $unzip_command = "unzip -d $modsecurity_rule_location $modsecurity_rule_location/slr_vuln_latest_1.0.0.zip";
system($unzip_command);

# Restart Apache Web Server to load latest rules
print "\n Restarting Apache \n\n";
system ('service httpd restart');
