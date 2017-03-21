module Rhinoart
  class DeviseGenerator < Rails::Generators::NamedBase
    desc 'Creates an admin user and uses Devise for authentication'
    argument :name, type: :string, default: 'User'

    class_option  :registerable, type: :boolean, default: false,
                  desc: 'Should the generated resource be registerable?'

    def install_devise
      require 'devise'

      initializer_file = File.join(destination_root, 'config/initializers/devise.rb')

      if File.exist?(initializer_file)
        log :generate, 'No need to install devise, already done.'
      else
        log :generate, 'devise:install'
        invoke 'devise:install'
      end
    end

    def create_admin_user
      invoke 'devise', [name, ['first_name:string', 'last_name:string', 'info:text']]
    end

    def remove_registerable_from_model
      unless options[:registerable]
        model_file = File.join(destination_root, 'app/models', "#{file_path}.rb")
        gsub_file model_file, /\:registerable([.]*,)?/, ""
      end
    end

    # def set_namespace_for_path
    #   routes_file = File.join(destination_root, "config", "routes.rb")
    #   gsub_file routes_file, /devise_for :#{plural_table_name}$/, "devise_for :#{plural_table_name}, ActiveAdmin::Devise.config"
    # end

    # def add_default_user_to_seed
    #   seeds_paths = Rails.application.paths['db/seeds.rb'] || Rails.application.paths['db/seeds'] # "db/seeds" => Rails 3.2 fallback
    #   seeds_file = seeds_paths.existent.first
    #   return if seeds_file.nil? || !options[:default_user]
    #
    #   create_user_code = "#{class_name}.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')"
    #
    #   append_to_file seeds_file, create_user_code
    # end
  end
end