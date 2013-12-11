# coding: utf-8
module VagrantPlugins
  module OpenStack
    module CommandSnapshot
      class Take < Vagrant.plugin(2, :command)
        def self.synopsis
          'Create snapshots from the command-line interface'
        end

        def execute
          opts = OptionParser.new do |o|
            o.banner 'vagrant openstack snapshot take <VM>'
          end

          # Parse the options and get the virtual machine.
          argv = parse_options(opts)
          return unless argv
        end

       end
    end
  end
end
