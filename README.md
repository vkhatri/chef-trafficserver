trafficserver Cookbook
======================

[![Build Status](https://travis-ci.org/bcorner13/chef-trafficserver.svg?branch=hotfix/CreateMissingUser)](https://travis-ci.org/bcorner13/chef-trafficserver)

This is a [Chef] cookbook to manage [Apache TrafficServer].

>> Note: This cookbook is currently under development and may not be tested for intended
features & functionality.

More attributes/features will be added over time, **feel free to contribute** what
you find missing!


## Repository

https://github.com/vkhatri/chef-trafficserver


## Supported Platform

Currently this cookbook under development and support only RHEL based platforms.


## Dependencies

- apt
- yum-epel
- ulimit

## Recipes

- `trafficserver::default`      - default recipe (used for run_list)


## Advance Attributes


## Core Attributes


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[Chef]: https://www.chef.io/
[Apache TrafficServer]: http://trafficserver.apache.org/
[Contributors]: https://github.com/vkhatri/chef-trafficserver/graphs/contributors
