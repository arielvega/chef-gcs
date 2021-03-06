$script = <<-'SCRIPT'
if rpm -qa | grep -q chef-workstation; then 
  echo "chef-workstation Installed"; 
else
  curl https://packages.chef.io/files/stable/chef-workstation/21.1.247/el/7/chef-workstation-21.1.247-1.el7.x86_64.rpm --output chef-workstation-21.1.247-1.el7.x86_64.rpm 
  rpm -ivh chef-workstation-21.1.247-1.el7.x86_64.rpm
  chef env --chef-license accept
fi
if rpm -qa | grep -q vim; then 
  echo "vim Installed"; 
else
  sudo yum -y install vim
fi
SCRIPT
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    config.vm.provision "shell", inline: $script
  end
end
