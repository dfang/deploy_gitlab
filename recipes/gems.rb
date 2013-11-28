#
# Cookbook Name:: gitlab
# Recipe:: gems
#

gitlab = node['gitlab']

# To prevent random failures during bundle install, get the latest ca-bundle

directory "/opt/local/etc/certs/" do
  owner gitlab['user']
  group gitlab['group']
  recursive true
  mode 0755
end

remote_file "Fetch the latest ca-bundle" do
  source "http://curl.haxx.se/ca/cacert.pem"
  path "/opt/local/etc/certs/cacert.pem"
  owner gitlab['user']
  group gitlab['group']
  mode 0755
  action :create_if_missing
end

## Install Gems without ri and rdoc
template File.join(gitlab['home'], ".gemrc") do
  source "gemrc.erb"
  user gitlab['user']
  group gitlab['group']
  notifies :run, "execute[bundle install]", :immediately
end

### without
bundle_without = []
case gitlab['database_adapter']
when 'mysql'
  bundle_without << 'postgres'
  bundle_without << 'aws'
when 'postgresql'
  bundle_without << 'mysql'
  bundle_without << 'aws'
end

case gitlab['env']
when 'production'
  bundle_without << 'development'
  bundle_without << 'test'
else
  bundle_without << 'production'
end

execute "bundle install" do
  command <<-EOS
    PATH="/usr/local/bin:$PATH"
    #{gitlab['bundle_install']} --without #{bundle_without.join(" ")}
  EOS
  cwd gitlab['path']
  user gitlab['user']
  group gitlab['group']
  action :nothing
end
