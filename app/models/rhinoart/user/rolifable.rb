module Rhinoart
  module User
    module Rolifable
      extend ActiveSupport::Concern

      included do
        #rolify role_cname: 'Rhinoart::Role'

        scope :super_users, ->{ with_role(Role::SUPER_USER) }
        scope :user_managers, ->{ with_role(Role::USER_MANAGER) }
        scope :content_managers, ->{ with_role(Role::CONTENT_MANAGER) }
        scope :admins, ->{ with_any_role(*Role.backend_roles) }

        def ability
          @ability ||= defined?(::Ability) ? ::Ability.new(self) : Rhinoart::Ability.new(self)
        end
        delegate :can?, :cannot?, :to => :ability

        def self.ransackable_scopes(auth_object = nil)
          super + [:admins, :super_users, :user_managers, :content_managers]
        end

      end
    end
  end
end
