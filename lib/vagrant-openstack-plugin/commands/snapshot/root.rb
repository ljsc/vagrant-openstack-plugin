# coding: utf-8
require 'optparse'

module VagrantPlugins
  module OpenStack
    module CommandSnapshot
      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          'Manage snapshots through the command-line interface'
        end

        def initialize(argv, argc)
          super

          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new.register(:list) do
            require_relative 'list'
            List
          end

          @subcommands.register(:take) do
            require_relative 'take'
            Take
          end

          @subcommands.register(:delete) do
            require_relative 'delete'
            Delete
          end
        end

        def execute
          # Print the help for all of the subcommands
          return help if @main_args.include?('-h') || @main_args.include?('--help')

          # At this point we have a subcommand that needs to be parsed and
          # dispatched. Use the registry that was built on initialization.
          command_klass = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help unless command_klass
          @logger.debug("Invoking command class: #{command_klass} with #{@sub_args.inspect}")
          
          @command_klass.new(@sub_args, @env).execute
        end

        def help
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant openstack snapshot <command> [<args>]'
            o.separator ''
            o.separator 'Available subcommands:'

            keys = @subcommands.keys.map(&:to_s)
            keys.sort.each { |k| o.separator "     #{k}" }

            o.separator ''
            o.separator 'For help on any individual command run `vagrant openstack snapshot COMMAND -h`'
          end

          @env.ui.info(opts.help, prefix: false)
        end
      end
    end
  end
end
  
