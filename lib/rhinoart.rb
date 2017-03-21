require 'haml'
require 'slim'
require 'awesome_nested_set'
require 'acts_as_list'
require 'mini_magick'
require 'carrierwave'
require 'russian'
require 'momentjs-rails'
require 'bootstrap-datepicker-rails'
require 'bootstrap3-datetimepicker-rails'
require 'kaminari'
require 'cancan'
require 'devise'
require 'rolify'
require 'paper_trail'
require 'ransack'
require 'cache_method'
require 'nokogiri'
require 'font-awesome-sass'

require 'rhinoart/version'
require 'rhinoart/engine'

module Rhinoart
  extend ActiveSupport::Autoload
  include ActiveSupport::Configurable

  eager_autoload do
    autoload :Menu
    autoload :Helpers
    autoload :Registry
    autoload :PagesConstraint
  end

  configure do |config|
    config.user_class = 'User'

    config.parent_controller = 'ApplicationController'

    config.order_in_list = :by_date

    config.send_welcome_email = false
    config.send_new_user_notification_email = false
    config.send_approving_notification_email = false

    config.mailer_from = nil

    config.user_approving = false

    config.blog_post_template = 'blog/post'
  end

  def self.user_class
    @user_class ||= config.user_class.constantize
  end

  def self.version
    Rhinoart::VERSION
  end

  def method_missing(method_name)
    if config.respond_to? method_name
      config.public_send(method_name)
    else
      super
    end
  end

  # setting('device_namespace', :users)
  #
  # setting('devise_controllers', {
  #   sessions: 'rhinoart/sessions',
  #   passwords: 'rhinoart/passwords',
  #   omniauth_callbacks: 'rhinoart/omniauth_callbacks'
  # })
  #
  # setting('devise_routes', {
  #   class_name: 'Rhinoart::User',
  #   module: :devise,
  #   controllers: Rhinoart.devise_controllers
  # })
  #
  # setting('devise_scopes', [
  #   :database_authenticatable,
  #   :recoverable,
  #   :registerable,
  #   :trackable,
  #   :validatable,
  #   :omniauthable,
  #   :omniauth_providers => [:google_oauth2]
  # ])

end

require 'rhinoart/work_links'
require 'rhinoart/railtie'
