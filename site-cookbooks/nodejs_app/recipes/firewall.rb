include_recipe 'firewall'

if node["nodejs_app"]["sslcert"] and node["nodejs_app"]["sslkey"]
  firewall_rule "https" do
    port node["nodejs_app"]["https_port"].to_i
    action :allow
  end
end
