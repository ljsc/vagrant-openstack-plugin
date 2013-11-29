require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This starts a suspended server, if there is one.
      class ResumeServer
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::resume_server")
        end

        def call(env)
          if env[:machine].id
            env[:ui].info(I18n.t("vagrant_openstack.resuming_server"))

            # TODO: Validate the fact that we get a server back from the API.
            server = env[:openstack_compute].servers.get(env[:machine].id)
            if server.state == 'PAUSED'
              env[:openstack_compute].unpause_server(server.id)  
            elsif server.state == 'SUSPENDED'
              env[:openstack_compute].resume_server(server.id)  
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
