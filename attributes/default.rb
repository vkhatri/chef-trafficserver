default['trafficserver']['version']         = '5.2.1'
default['trafficserver']['install_method']  = 'source' # options: source, package
default['trafficserver']['setup_epel']      = true
default['trafficserver']['cookbook']        = 'trafficserver'

# trafficserver user / group
default['trafficserver']['user']          = 'ats'
default['trafficserver']['group']         = 'ats'
default['trafficserver']['user_home']     = nil
default['trafficserver']['setup_user']    = true # ideally set to false for Production environment and advised to manage trafficserver user via different cookbook

default['trafficserver']['umask']         = '0022'
default['trafficserver']['dir_mode']      = '0755'
default['trafficserver']['parent_dir']    = '/usr/local/trafficserver'
default['trafficserver']['log_dir']       = '/var/log/trafficserver'
default['trafficserver']['conf_dir']      = '/etc/trafficserver'

# data storage cache dirs
default['trafficserver']['storage_dir']   = '/opt/trafficserver-storage'
default['trafficserver']['data_dir']      = '/opt/trafficserver-data'

# for tarball installation
default['trafficserver']['version_dir']   = ::File.join(node['trafficserver']['parent_dir'], node['trafficserver']['version'])
default['trafficserver']['install_dir']   = ::File.join(node['trafficserver']['version_dir'], 'installed')
default['trafficserver']['source_dir']    = ::File.join(node['trafficserver']['version_dir'], "trafficserver-#{node['trafficserver']['version']}")

default['trafficserver']['notify_restart']  = true # notify service restart on config change
default['trafficserver']['service_name']    = 'trafficserver'

default['trafficserver']['port']      = 8983
default['trafficserver']['ssl_port']  = 8984

default['trafficserver']['tarball']['url']  = "https://archive.apache.org/dist/trafficserver/trafficserver-#{node['trafficserver']['version']}.tar.bz2"
default['trafficserver']['tarball']['md5']  = 'f8fa197db0f76a63fb6624d7facddfff'

default['trafficserver']['force_compile']       = false
default['trafficserver']['compile']['--prefix'] = node['trafficserver']['install_dir']
default['trafficserver']['compile']['--sysconfdir']     = node['trafficserver']['conf_dir']
default['trafficserver']['compile']['--datadir']        = node['trafficserver']['data_dir']
default['trafficserver']['compile']['--enable-tproxy']  = 'auto'
default['trafficserver']['compile']['--with-user']      = node['trafficserver']['user']
default['trafficserver']['compile']['--with-group']     = node['trafficserver']['group']

# trafficserver process limits
default['trafficserver']['limits']['memlock']    = 'unlimited'
default['trafficserver']['limits']['nofile']     = 48_000
default['trafficserver']['limits']['nproc']      = 'unlimited'

default['trafficserver']['git']['url'] = 'https://github.com/apache/trafficserver.git'

default['trafficserver']['daemon_prefix'] = case node['trafficserver']['install_method']
                                            when 'source'
                                              ::File.join(node['trafficserver']['install_dir'], 'bin')
                                            else
                                              '/usr/bin'
                                            end

default['trafficserver']['service_config_file'] = value_for_platform_family(
  'rhel' => '/etc/sysconfig/trafficserver',
  'debian' => '/etc/default/trafficserver'
)

# manage trafficserver configuration files
default['trafficserver']['manage_config'] = true
default['trafficserver']['manage_body_factory'] = true
