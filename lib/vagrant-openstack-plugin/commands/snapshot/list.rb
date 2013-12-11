# coding: utf-8
module VagrantPlugins
  module OpenStack
    module CommandSnapshot
      # This is the subcommand for the `vagrant openstack snapshot` which lists
      # all of the snapshots for each OpenStack provider.
      class List < Vagrant.plugin('2', :command)
        def self.synopsis
          'List all snapshots from the command-line interface'
        end
        
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant openstack snapshot list <machines>'
            o.on('--[no-]volume', 'Enable or disable filtering of volume snapshots') do |vs|
              opts[:volume_snapshots] = vs
            end
          end

          # Parse the options for machine filters.
          argv = parse_options(opts)
          return unless argv
          
          # Reduce the set of machines if the providers are the same. Because
          # OpenStack API returns *all* of the snapshots we'll get duplicates.
          machines = with_target_vms(argv).map { |m| m.provider_name == 'openstack' }
          machines = machines.uniq { |m| m.provider_options.endpoint }

          machines.each do |m|
            m.action(:connect_openstack, {})
            m.env[:openstack_compute].snapshots.all(true).each do |snap|
              @env.ui.info("OpenStack snapshots for #{m.provider_options.endpoint}")
              @env.ui.info(snap.to_s)
            end
          end

        end
      end
    end
  end
end

