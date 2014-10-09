Description
===========

This is a template for deploying a NodeJS application from a git repo under on
multiple Linux servers with [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) on the [Rackspace
Cloud](http://www.rackspace.com/cloud/). This template is leveraging
[chef-solo](http://docs.opscode.com/chef_solo.html) to set up the server.

Requirements
============
* A Heat provider that supports the following:
  * OS::Heat::ChefSolo
  * OS::Heat::RandomString
  * OS::Heat::ResourceGroup
  * OS::Nova::KeyPair
  * Rackspace::Cloud::LoadBalancer
  * Rackspace::Cloud::Server
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `db_flavor`: Required: Rackspace Cloud Server flavor to use. The size is
  based on the amount of RAM for the provisioned server. (Default: 4 GB
  Performance)
* `db_size`: Required: Amount of storage required for your Rackspace Cloud Database,
in GB. (Default: 10)
* `datastore_version`: Required: Version of MySQL to run on the Cloud Databases
instance. (Default: 5.6)
* `image`: Required: Server image used for all servers that are created as a
  part of this deployment. (Default: Ubuntu 12.04 LTS (Precise Pangolin))
* `load_balancer_hostname`: Hostname for the Cloud Load Balancer (Default:
  nodejs-app-load-balancer)
* `server_hostnames`: Server Name (Default: nodejs-%index%)
* `db_hostname`: Server Name (Default: nodejs-db)
* `repo`: Optional: URL to your git repository. Use the https:// syntax for
  public repositories, use git@ syntax for private repositories. (Default: '')
* `flavor`: Required: Rackspace Cloud Server flavor to use. The size is based
  on the amount of RAM for the provisioned server. (Default: 4 GB Performance)
* `packages`: Optional: Additional system packages to install. For a list of
  available packages, see: http://packages.ubuntu.com/precise/allpackages
  (Default: '')
* `nodejs_app_server_count`: Required: Number of servers to spin up as a part
  of this deployment. (Default: 2)
* `kitchen`: URL for the kitchen to use (Default:
  https://github.com/brint/nodejs-multi)
* `destination`: Path to setup your application on your servers. (Default:
  /var/www/vhosts/application)
* `chef_version`: Version of chef client to use (Default: 11.14.6)
* `database_username`: Database Username (Default: nodejs)
* `deploy_key`: Optional: If you specified a private repository, provide your
  private deploy key here. (Default: '')
* `child_template`: (Default:
  https://raw.github.com/brint/nodejs-multi/master/node-web.yaml)
* `revision`: Optional: Git Branch/Ref to deploy. Default: HEAD (Default: HEAD)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value of a specific output.

* `private_key`: SSH Private Key
* `load_balancer_ip`: Load Balancer IP
* `nodejs_url`: Node.js URL
* `node_server_ips`: Node.js Server IPs
* `mysql_root_password`: MySQL Root Password
* `database_server_ip`: Database Server IP

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
By default the application will be deployed under /var/www/application

Testing
=============
Here's a command to run the tests against a node:
```
nodejs-multi$ fab -u root -i NODE_SSH_KEY -H NODE_IP_ADDRESS -f test/fabric/nodejsmulti.py --disable-known-hosts --abort-on-prompts --set=use_ssh_config=True check
```

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
