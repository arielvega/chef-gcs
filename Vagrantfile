$script = <<-'SCRIPT'
if rpm -qa | grep -q chef-workstation; then 
  echo "chef-workstation Installed"; 
else
  curl https://packages.chef.io/files/stable/chef-workstation/21.1.247/el/7/chef-workstation-21.1.247-1.el7.x86_64.rpm --output chef-workstation-21.1.247-1.el7.x86_64.rpm 
  sudo rpm -ivh chef-workstation-21.1.247-1.el7.x86_64.rpm
  chef env --chef-license accept
fi

sudo yum -y install vim java-1.8.0-openjdk-devel git 

if rpm -qa | grep -q scala; then 
  echo "scala Installed"; 
else
  curl https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.rpm --output scala-2.12.10.rpm
  sudo yum -y install scala-2.12.10.rpm
fi

if rpm -qa | grep -q sbt; then 
  echo "sbt Installed"; 
else
  curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
  sudo yum -y install sbt
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
