name 'trafficserver'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Apache Trafficserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'apt'
depends 'yum-epel'
depends 'ulimit'

%w(redhat centos amazon).each do |os|
  supports os
end
