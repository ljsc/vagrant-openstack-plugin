module VagrantPlugins
  module OpenStack
    module Action
      class MessageServerRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_openstack.server_running", name: env[:machine].name))
          @app.call(env)
        end
      end
    end
  end
end
