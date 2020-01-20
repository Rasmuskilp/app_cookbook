#
# Cookbook:: app_nodejs
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'nodejs'
include_recipe 'apt'
#npm installs
#include_recipe 'pm2'
apt_update 'update_sources' do
  action :update
end
package 'nginx'
#package 'npm'
#packages apt-get
#package 'pm2'
#resource service
service 'nginx' do
  action :start
end
service "nginx" do
  action :enable
end
nodejs_npm 'pm2'


# polymorph method
  # service 'nginx' do
  # action([:start, :enable])
  # end
  #
  # resource template
  template '/etc/nginx/sites-available/proxy.conf' do
    source 'proxy.conf.erb'
    variables(proxy_port: node['nginx']['proxy_port'])
    notifies :restart, 'service[nginx]'
  end
  remote_directory '/home/ubuntu/app' do
  source 'app'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end
 # #resource link
  link "/etc/nginx/sites-enabled/proxy.conf" do
    to "/etc/nginx/sites-available/proxy.conf"
    notifies :restart, 'service[nginx]'
  end
  link "/etc/nginx/sites-enabled/default" do
    action :delete
    notifies :restart, 'service[nginx]'
  end
bash 'run and install app' do
  code <<-EOH
  cd app
  sudo npm install
  sudo npm start &
  EOH
end
