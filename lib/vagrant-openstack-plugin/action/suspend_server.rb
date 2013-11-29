require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This deletes the running server, if there is one.
      class SuspendServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::suspend_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_openstack.suspending_server"))

            # TODO: Validate the fact that we get a server back from the API.
            server = env[:openstack_compute].servers.get(env[:machine].id)
            env[:openstack_compute].suspend_server(server.id)
          end

          @app.call(env)
        end
      end
    end
  end
end
