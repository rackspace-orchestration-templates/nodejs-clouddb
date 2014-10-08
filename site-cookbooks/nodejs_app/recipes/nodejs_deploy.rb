include_recipe 'git'

home_dir = File.join('/home', node['nodejs_app']['username'])

if node['nodejs_app']['git_repo'] =~ /^git@/
  require 'uri'
  ### Temporarily convert ssh address to http protocol to find host easier ###
  repo = node['nodejs_app']['git_repo']
  uri = URI(repo.gsub(':', '/').gsub(/git\@/, 'http://'))
  host = uri.host
  ssh_known_hosts_entry host
end

begin_key = '-----BEGIN RSA PRIVATE KEY-----'
end_key = '-----END RSA PRIVATE KEY-----'

key = node['nodejs_app']['deploy_key']
if key
  key = key.gsub(begin_key, '').gsub(end_key, '').gsub(' ', '\n')
  git_deploy_key = begin_key + key + end_key
end

application 'create nodejs application' do
  path node['nodejs_app']['destination']
  owner node['nodejs_app']['username']
  repository node['nodejs_app']['git_repo']
  revision node['nodejs_app']['rev']
  deploy_key git_deploy_key if key
end

execute 'locally install npm packages from package.json' do
  cwd "#{node['nodejs_app']['destination']}/current"
  command 'npm install'
  user node['nodejs_app']['username']
  environment ({ 'HOME' => home_dir })
  only_if { ::File.exist?(File.join(node['nodejs_app']['destination'],
                                    'current/package.json'))
  }
end

execute 'add forever to run app as daemon' do
  command 'npm install forever -g'
  environment ({ 'HOME' => home_dir })
end

template '/etc/init.d/node-app' do
  source 'init.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables destination: "#{node['nodejs_app']['destination']}/current"
end

service 'node-app' do
  action [:enable, :start]
end
