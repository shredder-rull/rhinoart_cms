class RhinoartConfig < Rails::Railtie
	config.frontend_roles = ['User', 'Subscriber', 'Blogger']
	config.order_in_list = :by_date # or :by_position

end

Rhinoart.configure do |config|
  config.user_class = "User"
  #
  # config.parent_controller = 'ApplicationController'
  #
  # config.order_in_list = :by_date
  #
  # config.send_welcome_email = false
  # config.send_new_user_notification_email = false
  # config.send_approving_notification_email = false
  #
  # config.mailer_from = nil
  #
  # config.user_approving = false
  #
  # config.paper_trail = false
  #
  # config.additional_user_attributes = %i[locales first_name last_name]
end
