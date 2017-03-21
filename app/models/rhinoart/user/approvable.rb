module Rhinoart
  module User
    module Approvable
      extend ActiveSupport::Concern

      included do

        if Rhinoart.config.user_approving and Rhinoart.user_class.column_names.include?('approved')

          scope :approved, ->{ where(approved: true) }
          scope :not_approved, ->{ where.not(approved: true) }

          def active_for_authentication?
            super && approved?
          end

          def inactive_message
            return :not_approved if !approved?
            super
          end

          def self.ransackable_scopes(auth_object = nil)
            super + [:approved, :not_approved]
          end

        else
          scope :approved, ->{ all }
          scope :not_approved, ->{ where('1 = 0') }

          def approved?
            true
          end

        end

      end
    end
  end
end