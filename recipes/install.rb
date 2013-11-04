#
# Cookbook Name:: gitlab
# Recipe:: install
#

gitlab = node['gitlab']

# Merge environmental variables
gitlab = Chef::Mixin::DeepMerge.merge(gitlab,gitlab[gitlab['env']])

# Setup all package, user, etc. requirements of GitLab
include_recipe "gitlab::initial"

# Fetch GitLab shell source code
include_recipe "gitlab::gitlab_shell_source"

# Configure GitLab shell
include_recipe "gitlab::gitlab_shell"

# Setup chosen database
include_recipe "gitlab::database_#{gitlab['database_adapter']}"

# Fetch GitLab source code
include_recipe "gitlab::gitlab_source"

# Install required gems
include_recipe "gitlab::gems"

# Configure GitLab
include_recipe "gitlab::gitlab"

# Start GitLab if in production
include_recipe "gitlab::start"

# Setup and configure nginx
include_recipe "gitlab::nginx" if gitlab['env'] == 'production'
