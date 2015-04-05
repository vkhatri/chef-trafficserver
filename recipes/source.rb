#
# Cookbook Name:: trafficserver
# Recipe:: tarball
#
# Copyright 2014, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# setup user
include_recipe 'trafficserver::user'

# Setup Directories for trafficserver
[node['trafficserver']['parent_dir'],
 node['trafficserver']['version_dir'],
 node['trafficserver']['conf_dir'],
 node['trafficserver']['install_dir']
].each do |dir|
  directory dir do
    owner node['trafficserver']['user']
    group node['trafficserver']['group']
    mode node['trafficserver']['dir_mode']
    recursive true
  end
end

tarball_file  = ::File.join(node['trafficserver']['version_dir'], "trafficserver-#{node['trafficserver']['version']}.tar.bz2")

# Stop trafficserver Service if running for Version Upgrade
service 'trafficserver' do
  service_name node['trafficserver']['service_name']
  # action :stop
  action :nothing
  only_if { File.exist?("/etc/init.d/#{node['trafficserver']['service_name']}") && !File.exist?(node['trafficserver']['source_dir']) }
end

# download tarball
remote_file tarball_file do
  source node['trafficserver']['tarball']['url']
  # checksum node['trafficserver']['tarball']['sha256']
  not_if { File.exist?(node['trafficserver']['source_dir']) }
end

# extract tarball
execute 'extract_trafficserver_tarball' do
  user node['trafficserver']['user']
  group node['trafficserver']['group']
  umask node['trafficserver']['umask']
  cwd node['trafficserver']['version_dir']
  command "tar xjf #{tarball_file}"
  creates ::File.join(node['trafficserver']['source_dir'], 'configure')
  notifies :run, 'execute[compile_trafficserver]', :immediately
end

remote_file tarball_file do
  action :delete
end

compile_options = ''
node['trafficserver']['compile'].each do |k, v|
  if v
    compile_options << " #{k}=#{v}"
  else
    compile_options << " #{k}"
  end
end

# compile
execute 'compile_trafficserver' do
  user node['trafficserver']['user']
  group node['trafficserver']['group']
  umask node['trafficserver']['umask']
  cwd node['trafficserver']['source_dir']
  # set node['trafficserver']['force_compile'] attribute to re-compile
  # caution: if set, will compile on each chef run
  creates ::File.join(node['trafficserver']['install_dir'], 'bin', 'traffic_server') unless node['trafficserver']['force_compile']
  command "autoreconf -if ; ./configure #{compile_options} ; make && make install"
end

template '/etc/init.d/trafficserver' do
  cookbook node['trafficserver']['cookbook']
  source 'initd.erb'
  owner 'root'
  group 'root'
  mode 0750
  variables(:version => node['trafficserver']['version'],
            :install_dir => node['trafficserver']['install_dir'],
            :log_dir => node['trafficserver']['log_dir'])
  notifies :restart, 'service[trafficserver]', :delayed if node['trafficserver']['notify_restart']
end
