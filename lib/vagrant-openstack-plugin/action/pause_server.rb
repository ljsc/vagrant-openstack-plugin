require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This pauses a running server, if there is one.
      class PauseServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::pause_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_openstack.pausing_server"))

            # TODO: Validate the fact that we get a server back from the API.
            server = env[:openstack_compute].servers.get(env[:machine].id)
            env[:openstack_compute].pause_server(server.id)
          end

          @app.call(env)
        end
      end
    end
  end
end
