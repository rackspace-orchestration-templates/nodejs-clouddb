# recipes/default.rb

case node['platform_family']
when 'rhel', 'fedora'
  include_recipe 'yum'
else
  include_recipe 'apt'
end

include_recipe 'build-essential'
include_recipe 'sudo'

node.set['authorization']['sudo']['users'] = [node['nodejs_app']['username']]

databag = Chef::EncryptedDataBagItem.load(node['deployment']['app_id'],
                                          node['deployment']['id'])
node.set['nodejs_app']['password'] = databag['nodejs_app']['password']
node.set['nodejs_app']['deploy_key'] = databag['nodejs_app']['deploy_key']
node.set['nodejs_app']['database_url'] = databag['nodejs_app']['database_url']

app_user = node['nodejs_app']['username']
app_dir = node['nodejs_app']['destination']
home_dir = File.join('/home', app_user)
secrets_dir = node['nodejs_app']['secrets_dir']
forever_dir = File.join(home_dir, '.forever')

directory secrets_dir do
  mode 0750
  recursive true
end

file File.join(secrets_dir, "#{node['nodejs_app']['appName']}_db_url.txt") do
  mode 0660
  content databag['nodejs_app']['database_url']
end

user app_user do
  password node['nodejs_app']['password']
  supports manage_home: true
  shell '/bin/bash'
  home home_dir
end

[app_dir, forever_dir, File.join(forever_dir, 'pids')].each do |dir|
  directory dir do
    owner app_user
    mode 0755
    recursive true
  end
end

bash 'create Node directories' do
  user app_user
  code <<-EOH
    sudo mkdir -p \
    /usr/local/{share/man,bin,lib/node,include/node,lib/node_modules}
    sudo chown -R #{app_user} \
    /usr/local/{share/man,bin,lib/node,include/node,lib/node_modules}
  EOH
end

include_recipe 'nodejs'

if node['nodejs_app']['git_repo'].empty? || !node['nodejs_app']['git_repo']
  include_recipe 'nodejs_app::nodejs_stack'
else
  include_recipe 'nodejs_app::nodejs_deploy'
end

include_recipe 'nodejs_app::firewall'
