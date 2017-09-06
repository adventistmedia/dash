module Dash
  class Engine < ::Rails::Engine
    #isolate_namespace Dash

    # Make helpers available to main app
    # config.to_prepare do
    #   Dash::ApplicationController.helper Rails.application.helpers
    # end
    # config.before_initialize do
    #   ActiveSupport.on_load :action_controller do
    #     Dash::ApplicationController.helper Dash::Engine.helpers
    #   end
    # end
  end
end