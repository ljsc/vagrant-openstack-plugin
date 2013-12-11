# coding: utf-8
module VagrantPlugins
  module OpenStack
    module CommandSnapshot
      class Delete < Vagrant.plugin(2, :command)
        def self.synopsis
          'Delete snapshots form the command-line interface'
        end
        
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant openstack snapshot delete <machine> <snapshot> [<args>]'
            o.on('--force', 'Forcefully destroy snapshot without confirmation') do 
              opts[:force_destroy] = true
            end
          end

          # Parse the options and require snapshot identifier.
          argv = parse_options(opts)
          return unless argv

          # Display dialog confirmation to the client.
          unless opts[:force_destroy]
            
          end

          
        end
      end
    end
  end
end

