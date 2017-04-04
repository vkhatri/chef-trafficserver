name 'trafficserver'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Apache Trafficserver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

source_url 'https://github.com/vkhatri/chef-trafficserver'
issues_url 'https://github.com/vkhatri/chef-trafficserver/issues'

depends 'apt'
depends 'yum-epel'
depends 'ulimit'

supports 'centos'
supports 'redhat'
chef_version '12.4'
