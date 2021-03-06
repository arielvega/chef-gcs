#
# Cookbook:: webserver
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

dbserver_ip = node['webserver']['dbserver_ip']
dbserver_name = node['webserver']['dbserver_name']
ruby_block 'edit etc hosts' do
    block do
        fe = Chef::Util::FileEdit.new('/etc/hosts')
        fe.insert_line_if_no_match(/\W#{Regexp.escape(dbserver_name)}\W/, "#{dbserver_ip}    #{dbserver_name}")
        fe.write_file
    end
end

execute 'install nginx' do
    command 'sudo dnf install -y nginx'
    action :run
end

template '/etc/nginx/nginx.conf' do
    source 'nginx.conf.erb'
end

execute 'enable nginx to connect' do
    command 'sudo setsebool -P httpd_can_network_connect on'
    action :run
end

execute 'enable nginx service' do
    command 'sudo systemctl enable nginx.service && sudo systemctl start nginx.service'
    action :run
end

execute 'install java' do
    command 'sudo dnf install -y java-1.8.0-openjdk-devel'
    action :run
end