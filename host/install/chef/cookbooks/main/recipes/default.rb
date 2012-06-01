###########
# dot files
template "/root/.profile" do
  source "profile.erb"
  mode "0644"
end


####################
# configure hostname
file "/etc/hostname" do
  content node[:server][:host][:hostname]
end

template "/etc/hosts" do
  source "etc/hosts.erb"
  mode "0644"
end

execute "restart hostname service" do
  command "service hostname --full-restart"
end


###################
# configure network
template "/etc/network/interfaces" do
  source "etc/network/interfaces.erb"
  mode "0644"
end

template "/etc/sysctl.conf" do
  source "etc/sysctl.conf.erb"
  mode "0644"
end

execute "restart network service" do
  command "/etc/init.d/networking restart"
  command "sysctl -p"
end


#############################
# install and configure munin
if node[:server][:tools][:munin][:install]
  package "munin"
  package "munin-node"
  package "munin-plugins-extra"

  template "/etc/munin/munin.conf" do
    source "etc/munin/munin.conf.erb"
    mode "0644"
  end

  execute "stop munin service" do
    command "/etc/init.d/munin-node stop"
  end

  execute "start munin service" do
    command "/etc/init.d/munin-node start"
  end

  execute "generate munin-htpasswd" do
    user = node[:server][:tools][:munin][:user]
    pass = node[:server][:tools][:munin][:pass]
    command "htpasswd -c -b /etc/munin/munin-htpasswd #{user} #{pass}"
  end

  template "/etc/munin/apache.conf" do
    source "etc/munin/apache.conf.erb"
    mode "0644"
  end

  execute "stop apache service" do
    command "/etc/init.d/apache2 stop"
  end

  execute "start apache service" do
    command "/etc/init.d/apache2 start"
  end
end
