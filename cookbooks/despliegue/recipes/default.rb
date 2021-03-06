#
# Cookbook:: despliegue
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

webserver_ip = node['despliegue']['webserver_ip']

execute 'dowload repo' do
    command '[ -d "./proyecto-gcs" ] && echo "El proyecto ya existe..." || git clone https://github.com/arielvega/proyecto-gcs.git'
    user 'azureuser'
    action :run
end

execute 'refresh repo' do
    command 'cd ./proyecto-gcs'
    user 'azureuser'
    action :run
end

execute 'generate RPM' do
    command 'sbt rpm:packageBin && mv ./gcs-app/target/rpm/RPMS/noarch/gcs-app-2.8.x-1.noarch.rpm ~/gcs-app-2.8.x-1.noarch.rpm'
    user 'azureuser'
    action :run
end

template 'remove old package' do
    source "ssh -o 'StrictHostKeyChecking no' azureuser@#{webserver_ip} 'sudo rpm -e gcs-app'"
    user 'azureuser'
end

execute 'copy new package' do
    command "scp -o 'StrictHostKeyChecking no' ~/gcs-app-2.8.x-1.noarch.rpm azureuser@#{webserver_ip}:."
    user 'azureuser'
    action :run
end

execute 'install new package' do
    command "ssh -o 'StrictHostKeyChecking no' azureuser@#{webserver_ip} 'sudo dnf install -y ~/gcs-app-2.8.x-1.noarch.rpm'"
    user 'azureuser'
    action :run
end
