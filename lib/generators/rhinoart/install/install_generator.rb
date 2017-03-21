require 'devise'
require 'rolify'
module Rhinoart
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    desc 'Installs Active Admin and generates the necessary migrations'
    argument :name, type: :string, default: 'User'
    argument :role, type: :string, default: 'Role'

    hook_for :users, default: 'devise', desc: 'Rhinoart user generator to run. Skip with --skip-users'

    hook_for :auditing, default: :paper_trail, desc: 'Rhinoart auditing generator to run. Skip with --skip-auditing'

    def install_rolify
      ActiveRecord::Base.extend(Devise::Models) unless ActiveRecord::Base.respond_to?(:devise)
      invoke "rolify", [role, name]
    end

    def extend_user_class
      user_model_file = File.join(destination_root, "app/models/#{file_name}.rb")
      if !File.exist?(user_model_file)
        log :generate, "No user model file found, skip rhinoart extension"
        return
      end
      log :generate, "Extend class #{name} with rhinoart extensions"
      inject_into_class user_model_file, name do
        [
          "  include Rhinoart::User::Notificable",
          "  include Rhinoart::User::Approvable",
          "  include Rhinoart::User::Rolifable",
          "  include Rhinoart::User::Localable",
          "",
          "  #store :info, accessors: Rhinoart.additional_user_attributes, coder: JSON",
          "  #mount_uploader :avatar, Rhinoart::ImageUploader",
          "  #has_paper_trail Rhinoart.paper_trail if Rhinoart.paper_trail",
          "\n\n"
        ].join("\n")
      end
    end

    def copy_files
      copy_file "controllers/pages_controller.rb", "app/controllers/pages_controller.rb"
      copy_file "models/ability.rb", "app/models/ability.rb"

      copy_file "views/layouts/application.html.slim", "app/views/layouts/application.html.slim"
      copy_file "views/pages/default.html.slim", "app/views/pages/default.html.slim"

      @user_class = name || 'User'
      template 'initializers/rhinoart.rb.erb', 'config/initializers/rhinoart.rb'
    end

    def add_assets
      invoke 'rhinoart:assets'
    end

    def add_route
      route "get '/*url' => 'pages#internal', :as => :page, constraints: Rhinoart::PagesConstraint"
      route "root 'pages#index'"
      route "mount Rhinoart::Engine, at: '/admin'"
    end


    def install_migrations
      rake 'db:create'
      rake 'rhinoart:install:migrations'
      #rake 'rhinoart:samples'
    end

    private

    ##
    # Can invoke the same command many times
    def _shared_configuration
      {}
    end

  end
end
