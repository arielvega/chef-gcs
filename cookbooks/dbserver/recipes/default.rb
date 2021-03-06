#
# Cookbook:: dbserver
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.


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