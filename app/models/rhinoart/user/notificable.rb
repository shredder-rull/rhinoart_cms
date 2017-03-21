module Rhinoart
  module User
    module Notificable
      extend ActiveSupport::Concern

      included do

        if Rhinoart.config.send_welcome_email
          after_commit on: :create  do
            NotificationsMailer.delay.new_user_welcome(self)
          end
        end

        if Rhinoart.config.send_new_user_notification_email
          after_commit on: :create do
            next unless Rhinoart.user_class.respond_to?(:user_manager_emails)
            User.user_manager_emails.each do |mail_to|
              NotificationsMailer.delay.new_user_notification(self, mail_to)
            end
          end

          def self.user_manager_emails
            with_role(Role::USERS_MANAGER).pluck(:email) if defined? Role::USERS_MANAGER
          end
        end

        if Rhinoart.config.send_approving_notification_email
          after_commit on: :update  do
            NotificationsMailer.delay.user_grant_access_notification(self) if (self.approved_changed? && self.approved == true)
          end
        end

      end

    end
  end
end