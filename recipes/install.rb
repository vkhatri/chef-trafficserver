#
# Cookbook Name:: trafficserver
# Recipe:: install
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

include_recipe 'trafficserver::package_dependency'

[node['trafficserver']['log_dir'],
 node['trafficserver']['conf_dir'],
 node['trafficserver']['storage_dir'],
 node['trafficserver']['data_dir']
].each do |dir|
  directory dir do
    owner node['trafficserver']['user']
    group node['trafficserver']['group']
    mode node['trafficserver']['dir_mode']
    recursive true
  end
end

include_recipe "trafficserver::#{node['trafficserver']['install_method']}"
