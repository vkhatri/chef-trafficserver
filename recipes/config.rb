#
# Cookbook Name:: trafficserver
# Recipe:: config
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

## TODO
# perhaps few of ats configuration can be
# leveraged with LWRP.
# to be checked later.
include_recipe 'trafficserver::cache.config'
include_recipe 'trafficserver::congestion.config'
include_recipe 'trafficserver::hosting.config'
include_recipe 'trafficserver::icp.config'
include_recipe 'trafficserver::ip_allow.config'
include_recipe 'trafficserver::log_hosts.config'
include_recipe 'trafficserver::logs_xml.config'
include_recipe 'trafficserver::parent.config'
include_recipe 'trafficserver::plugin.config'
include_recipe 'trafficserver::prefetch.config'
include_recipe 'trafficserver::proxy.pac'
include_recipe 'trafficserver::records.config'
include_recipe 'trafficserver::remap.config'
include_recipe 'trafficserver::socks.config'
include_recipe 'trafficserver::splitdns.config'
include_recipe 'trafficserver::ssl_multicert.config'
include_recipe 'trafficserver::stats.config.xml'
include_recipe 'trafficserver::storage.config'
include_recipe 'trafficserver::update.config'
include_recipe 'trafficserver::vaddrs.config'
include_recipe 'trafficserver::volume.config'

##
template node['trafficserver']['service_config_file'] do
  cookbook node['trafficserver']['cookbook']
  source 'sysconfig.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[trafficserver]', :delayed if node['trafficserver']['notify_restart']
  only_if { node['trafficserver']['manage_config'] }
end

remote_directory ::File.join(node['trafficserver']['conf_dir'], 'body_factory') do
  cookbook node['trafficserver']['cookbook']
  source 'body_factory'
  owner node['trafficserver']['user']
  group node['trafficserver']['group']
  mode node['trafficserver']['dir_mode']
  files_mode 0644
  files_owner node['trafficserver']['user']
  files_group node['trafficserver']['group']
  notifies :reload, 'service[trafficserver]', :delayed if node['trafficserver']['notify_restart']
  only_if { node['trafficserver']['manage_body_factory'] }
end

# trafficserver service user limits
user_ulimit node['trafficserver']['user'] do
  filehandle_limit node['trafficserver']['limits']['nofile']
  process_limit node['trafficserver']['limits']['nproc']
  memory_limit node['trafficserver']['limits']['memlock']
end

ruby_block 'require_pam_limits.so' do
  block do
    fe = Chef::Util::FileEdit.new('/etc/pam.d/su')
    fe.search_file_replace_line(/# session    required   pam_limits.so/, 'session    required   pam_limits.so')
    fe.write_file
  end
end

service 'trafficserver' do
  supports :status => true, :restart => true, :reload => true
  service_name node['trafficserver']['service_name']
  action [:enable, :start]
end
