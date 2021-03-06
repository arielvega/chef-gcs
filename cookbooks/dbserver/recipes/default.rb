#
# Cookbook:: dbserver
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

execute 'update' do
    command 'sudo dnf update -y'
    action :run
end

execute 'enable postgres 12' do
    command 'sudo dnf module enable -y postgresql:12'
    action :run
end

execute 'install postgresql-server' do
    command 'sudo dnf install -y postgresql-server'
    action :run
end

execute 'inicializamos la base de datos postgresql' do
    command 'sudo postgresql-setup --initdb'
    action :run
end

template '/var/lib/pgsql/data/pg_hba.conf' do
    source 'pg_hba.conf.erb'
end

template '/var/lib/pgsql/data/postgresql.conf' do
    source 'postgresql.conf.erb'
end

execute 'enable postgresql service' do
    command 'sudo systemctl enable postgresql.service && sudo systemctl start postgresql.service'
    action :run
end

execute 'create postgresql user' do
    command 'sudo -u postgres createuser -s gcs'
    action :run
end

execute 'create postgresql database' do
    command 'sudo -u postgres createdb gcs'
    action :run
end

execute 'create user password' do
    command 'sudo -u postgres psql --command "ALTER USER gcs WITH PASSWORD \'gcs\'"'
    action :run
end

execute 'restart postgresql service' do
    command 'sudo systemctl restart postgresql.service'
    action :run
end