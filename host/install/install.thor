require 'erubis'
require 'yaml'
require 'active_support/core_ext'

module Hetzner
  SERVER_CONFIG_DIR = '/root/hetzner'

  module Helpers
    def backup_file_suffix
      "_backup_#{Time.new.strftime('%Y%m%d-%H%M')}"
    end

    def config
      YAML.load_file(File.join(SERVER_CONFIG_DIR, 'config.yml'))
    end
  end

  module Host
    class Install < Thor
      include Helpers

      desc "configure_hostname", "set hostname"
      def configure_hostname
        hostname  = config['server']['host']['hostname']
        server_ip = config['server']['host']['ip']
        if hostname.present?
          # backup origin configuration
          FileUtils.cp('/etc/hostname', '/etc/hostname' + backup_file_suffix, :verbose => true)
          FileUtils.cp('/etc/hosts', '/etc/hosts' + backup_file_suffix, :verbose => true)

          # set new configuration
          open('/etc/hostname', 'w') { |f| f.write(hostname) }
          hosts = open('/etc/hosts').read
          open('/etc/hosts', 'w') do |f|
            f.write(hosts.gsub(/#{server_ip}.*$/, "#{server_ip} #{hostname}"))
          end

          # restart service
          system('/etc/init.d/hostname restart')
        end
      end

      desc "configure_network", "setup network"
      def configure_network
        # network configuration
        FileUtils.cp('/etc/network/interfaces', '/etc/network/interfaces' + backup_file_suffix, :verbose => true)
        eruby = Erubis::Eruby.new(open(SERVER_CONFIG_DIR + '/host/install/templates/etc/network/interfaces').read)
        open('/etc/network/interfaces', 'a') do |f|
          f.write(eruby.result(
            :gateway => config['server']['host']['subnet']['gateway'],
            :maske   => config['server']['host']['subnet']['maske'],
            :ips     => config['server']['host']['subnet']['ips']
          ))
        end

        # sysctl.conf
        FileUtils.cp('/etc/sysctl.conf', '/etc/sysctl.conf' + backup_file_suffix, :verbose => true)
        FileUtils.cp(SERVER_CONFIG_DIR + '/host/install/templates/etc/sysctl.conf', '/etc/sysctl.conf', :verbose => true)

        # restart service
        system('/etc/init.d/networking restart')
      end

      desc "configure_munin", "setup monitoring tool munin"
      def configure_munin
        FileUtils.cp('/etc/munin/munin.conf', '/etc/munin/munin.conf' + backup_file_suffix, :verbose => true)
        eruby = Erubis::Eruby.new(open(SERVER_CONFIG_DIR + '/host/install/templates/etc/munin/munin.conf').read)
        open('/etc/munin/munin.conf', 'w') { |f| f.write(eruby.result) }

        system('/etc/init.d/munin-node stop')
        system('/etc/init.d/munin-node start')

        open('/etc/munin/munin-htpasswd', 'w') { |f| f.write(config['server']['host']['tools']['munin']['htpasswd']) }
        FileUtils.cp('/etc/munin/apache.conf', '/etc/munin/apache.conf' + backup_file_suffix, :verbose => true)
        FileUtils.cp(SERVER_CONFIG_DIR + '/host/install/templates/etc/munin/apache.conf', '/etc/munin/apache.conf', :verbose => true)

        system('/etc/init.d/apache2 stop')
        system('/etc/init.d/apache2 start')
      end

      desc "configure_authorized_keys", "setup authorized ssh keys"
      def configure_authorized_keys
        FileUtils.mkdir_p('/root/.ssh', :verbose => true)
        open('/root/.ssh/authorized_keys', 'w') do |f|
          config['server']['host']['ssh_authorized_keys'].each do |ssh_key|
            f.write("#{ssh_key}\n")
          end
        end
      end
    end
  end
end
