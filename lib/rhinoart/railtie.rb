module Rhinoart
  class Railtie < Rails::Railtie

    initializer 'rhinoart_railtie.add_precompile_assets' do |app|

      ActiveSupport.on_load(:action_controller) do

      end

      app.config.assets.precompile += %w[
        rhinoart_admin.js
        rhinoart_admin.css
        jquery.tablesorter.js
        redactor/redactor.css
        redactor/redactor.js
        rhinoart/*.gif
      ]

    end

  end
end