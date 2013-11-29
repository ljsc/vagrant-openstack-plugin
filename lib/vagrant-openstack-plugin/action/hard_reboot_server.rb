require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This hard reboots a running server, if there is one.
      class HardRebootServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::hard_reboot_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_openstack.hard_rebooting_server"))

            # TODO: Validate the fact that we get a server back from the API.
            server = env[:openstack_compute].servers.get(env[:machine].id)
            server.reboot('HARD')
          end

          @app.call(env)
        end
      end
    end
  end
end
