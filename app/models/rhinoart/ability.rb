module Rhinoart
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= Rhinoart.user_class.new # guest users (not logged in)

      if user.has_any_role? *Role.backend_roles
        can :access, :admin_panel
      end

      if user.has_role?(Role::SUPER_USER)
        can :manage, :all
      end

      if user.has_role?(Role::USER_MANAGER)
        can :manage, :users
        can :manage, Rhinoart.user_class
        #cannot :manage, :user_roles
      end

      can :manage, Rhinoart.user_class, id: user.id

      if user.has_role?(Role::CONTENT_MANAGER)
        can :manage, :content
      end

    end
  end
end
