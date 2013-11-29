require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        NOT_CREATED_STATES = [:deleted, :soft_deleted, :building, :error].freeze

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:openstack_compute], env[:machine])
          @app.call(env)
        end

        def read_state(openstack, machine)
          return :not_created if machine.id.nil?

          # Find the machine using the OpenStack API.
          server = openstack.servers.get(machine.id)
          if server.nil? || NOT_CREATED_STATES.include?(server.state.downcase.to_sym)
            @logger.info(I18n.t("vagrant_openstack.not_created"))
            machine.id = nil
            return :not_created
          end

          server.state.downcase.to_sym
        end

      end
    end
  end
end
