module VagrantPlugins
  module OpenStack
    module Action
      class MessageAlreadyPaused
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_openstack.already_paused"))
          @app.call(env)
        end
      end
    end
  end
end
