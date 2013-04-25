#
# Cookbook Name:: pdns
# Recipe:: mysql
#
# Copyright 2013, HP Cloud Services
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

passwords = PerconaPasswords.new(node)

package "pdns-backend-mysql" do
  package_name value_for_platform(
    "arch" => { "default" => "pdns" },
    ["debian","ubuntu"] => { "default" => "pdns-backend-mysql" },
    ["redhat","centos","fedora"] => { "default" => "pdns-backend-mysql" },
    "default" => "pdns-backend-mysql"
  )
end

template "/etc/powerdns/pdns.d/pdns.local.gmysql" do
  source "pdns.local.gmysql.erb"
  owner "root"
  group "root"
  mode 0644
  variables({ :powerdns_password => passwords.powerdns_password})
  notifies :restart, "service[pdns]", :immediately
end
