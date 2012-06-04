###########
# dot files
template "/root/.profile" do
  source "profile.erb"
  mode "0644"
end

# enable memory monitoring
link "/root/hetzner.thor" do
  to "/root/hetzner/host/install/hetzner.thor"
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


###########################
# configure network for vms
unless File.exists?("/etc/network/_interfaces-origin")
  execute "copy origin interface configuration" do
    command "cp /etc/network/interfaces /etc/network/_interfaces-origin"
  end
end

template "/etc/network/_interfaces-vms" do
  source "etc/network/interfaces.erb"
  mode "0644"
end

execute "copy origin interface configuration" do
  command "rm /etc/network/interfaces && cat /etc/network/_interfaces-origin /etc/network/_interfaces-vms >> /etc/network/interfaces"
end

template "/etc/sysctl.conf" do
  source "etc/sysctl.conf.erb"
  mode "0644"
end

execute "restart network service 1" do
  command "/etc/init.d/networking restart"
end

execute "restart network service 2" do
  command "sysctl -p"
end

template "/etc/libvirt/qemu.conf" do
  source "/etc/libvirt/qemu.conf.erb"
  mode "0644"
end

execute "restart libvirt service" do
  command "service libvirt-bin restart"
end


#############################
# install and configure munin
if node[:server][:tools][:munin][:install]
  package "munin"
  package "munin-node"
  package "munin-plugins-extra"

  execute "restart munin service" do
    command "service munin-node restart"
  end

  template "/etc/munin/munin.conf" do
    source "etc/munin/munin.conf.erb"
    mode "0644"
  end

  # enable memory monitoring
  link "/etc/munin/plugins/memory" do
    to "/usr/share/munin/plugins/memory"
  end

  # enable open_files monitoring
  link "/etc/munin/plugins/open_files" do
    to "/usr/share/munin/plugins/open_files"
  end

  execute "restart munin service" do
    command "service munin-node restart"
  end

  execute "run munin-cron" do
    command "/usr/bin/munin-cron"
    user "munin"
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
