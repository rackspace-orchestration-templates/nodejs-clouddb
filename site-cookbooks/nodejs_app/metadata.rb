name             'nodejs_app'
maintainer       'Jon Perritt'
maintainer_email 'jon.perritt@rackspace.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures a nodejs app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(apt application yum build-essential sudo git firewall nodejs
   ssh_known_hosts).each do |cb|
  depends cb
end
