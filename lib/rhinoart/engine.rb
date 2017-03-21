module Rhinoart
  class Engine < ::Rails::Engine
    isolate_namespace Rhinoart

    config.to_prepare do
      Devise::SessionsController.layout "application"
    end

    initializer 'rhinoart.extend_action_view' do
      ActiveSupport.on_load :action_view do
        include Helpers::PagesHelper
        self.field_error_proc = proc{|html_tag, instance| html_tag}
      end
    end

    initializer 'rhinoart.extend_action_controller' do
      ActiveSupport.on_load :action_controller do

      end
    end

    initializer 'rhinoart.registry_middleware' do
      Rails.application.config.middleware.use Rhinoart::Registry::Middleware
    end

    initializer 'rhinoart.locales' do
      Rails.application.config.i18n.available_locales = [:en, :ru]
    end

    # initializer 'rhinoart.remove_field_error_wrapper' do
    #   Rails.application.config.action_view.field_error_proc = proc{|html_tag, instance| html_tag}
    # end

  end
end

