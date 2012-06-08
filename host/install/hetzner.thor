require 'json'
require 'active_support/core_ext'

module Hetzner
  class Vm < Thor
    include Actions

    desc "ips", "show IPs"
    method_options(:config => :string)
    def ips
      config = load_config(options[:config])
      config['server']['host']['subnet']['vms'].each do |key, conf|
        puts "#{key}: #{conf['ip']} (user: #{conf['user']}, pass: #{conf['pass']})"
      end
    end

    desc "create", "create a new VM"
    method_options(
      :name      => :required,
      :cpus      => 4,
      :ram       => 4096,
      :swap      => 1024,
      :hdd       => 51200,
      :config    => :string
    )
    def create
      run "mkdir -p /root/vms"

      if File.exists?("/root/vms/#{options[:name]}")
        say("VM '/root/vms/#{options[:name]}' already exists.", Color::RED)
        exit
      end

      config = load_config(options[:config])

      vm_network_gateway  = config['server']['host']['subnet']['gateway']   # e.g. 79.48.232.14
      vm_network_mask     = config['server']['host']['subnet']['maske']     # e.g. 255.255.255.248
      vm_network_net      = config['server']['host']['subnet']['net']       # e.g. 176.9.0.0
      vm_network_bcast    = config['server']['host']['subnet']['broadcast'] # e.g. 176.9.0.31
      vm_network_dns      = config['server']['host']['subnet']['dns']       # e.g. '213.133.98.98 213.133.99.99 213.133.100.100'

      vm_config           = config['server']['host']['subnet']['vms'][options[:name]]

      if vm_config.blank?
        say("No VM configuration found (config['server']['host']['subnet']['vms']['#{options[:name]}']).", Color::RED)
        exit
      end

      shell_cmd = %{ubuntu-vm-builder kvm precise -v  \
        --cpus=#{options[:cpus]} \
        --mem=#{options[:ram]} \
        --swapsize=#{options[:swap]} \
        --rootsize=#{options[:hdd]} \
        --bridge=br0 \
        --libvirt=qemu:///system \
        --flavour=server \
        --hostname=#{options[:name]} \
        --ip=#{vm_config['ip']} \
        --mask=#{vm_network_mask} \
        --net=#{vm_network_net} \
        --bcast=#{vm_network_bcast} \
        --gw=#{vm_network_gateway} \
        --dns=#{vm_network_dns} \
        --mirror=http://de.archive.ubuntu.com/ubuntu \
        --components='main,universe' \
        --addpkg='openssh-server,acpid,htop,wget,screen,make' \
        --user=#{vm_config['user']} \
        --pass=#{vm_config['pass']} \
        --timezone='CET' \
        --dest=/root/vms/#{options[:name]}}
      run(shell_cmd)

      run "virsh autostart #{options[:name]}"
      run "virsh start #{options[:name]}"
      run 'virsh -c qemu:///system list --all'
    end

    desc "edit", "edit the given VM"
    method_options(:name => :required)
    def edit
      run "virsh edit #{options[:name]}"
    end

    desc "list", "show list of all VM's"
    def list
      run 'virsh -c qemu:///system list --all'
    end

    desc "start", "start the given VM"
    method_options(:name => :required)
    def start
      run "virsh start #{options[:name]}"
    end

    desc "stop", "stop the given VM"
    method_options(:name => :required)
    def stop
      run "virsh shutdown #{options[:name]}"
    end

    class Snapshot < Thor
      include Actions

      desc "create", "Create snapshot"
      method_options(:name => :required)
      def create
        while `virsh -c qemu:///system domstate #{options[:name]}`.squish != 'shut off'
          print 'try to shutdown...'
          invoke 'hetzner:vm:stop'
          sleep(10)
        end
        run "virsh snapshot-create #{options[:name]}"
        invoke 'hetzner:vm:start'
      end

      desc "restore", "Restore snapshot"
      method_options(:name => :required, :snapshot_name => :required)
      def restore
        run "virsh snapshot-revert #{options[:name]} #{options[:snapshot_name]}"
      end

      desc "list", "List snapshots"
      method_options(:name => :required)
      def list
        run "virsh snapshot-list #{options[:name]}"
      end
    end

    no_tasks do
      def load_config(config)
        file = if options[:config].present? && File.exists?(options[:config])
          options[:config]
        elsif ENV['SERVER_IDENTIFIER'].present? && File.exists?(config_file_1 = "/root/hetzner/host/install/config/node.#{ENV['SERVER_IDENTIFIER']}.json")
          config_file_1
        elsif ENV['SERVER_IDENTIFIER'].present? && File.exists?(config_file_2 = "/root/hetzner-config/node.#{ENV['SERVER_IDENTIFIER']}.json")
          config_file_2
        else
          say("No configuration (node.SERVER_IDENTIFIER.json) found in /root/hetzner/host/install/config or /root/hetzner-config\n", Color::RED)
          exit
        end

        JSON.parse(File.read(file))
      end
    end
  end
end
