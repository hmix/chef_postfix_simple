# Cookbook Name:: postfix_simple
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Update repo list (rhel family does this every time a package is installed)
include_recipe 'apt' if node['platform_family'] == 'debian'

### We need an email server
case node['platform_family']
when 'debian'
  package 'postfix'
  package 'mailutils'
when 'rhel'
  package 'postfix'
  package 'mailx'
end

service 'postfix' do
  supports :status => true, :restart => true
  action [ :enable  ]
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[postfix]'
end

#template '/etc/postfix/canonical' do
  #source 'canonical.erb'
  #owner 'root'
  #group 'root'
  #mode '0644'
#end

#execute 'postmap_canonical' do
  #cwd '/etc/postfix'
  #command 'postmap canonical'
  #only_if { ::File.exists?('etc/postfix/canonical') }
#end

#service 'postfix' do
  #action [:restart, :enable]
#end

