module Rhinoart
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      def install_assets
        template 'rhinoart_admin.coffee', 'app/assets/javascripts/rhinoart_admin.coffee'
        template 'rhinoart_admin.css', 'app/assets/stylesheets/rhinoart_admin.css'
      end

    end
  end
end