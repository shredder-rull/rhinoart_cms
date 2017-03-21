module Rhinoart
  module Role

    SUPER_USER = :super_user
    USER_MANAGER = :user_manager
    CONTENT_MANAGER = :content_manager

    def self.backend_roles
      [SUPER_USER, USER_MANAGER, CONTENT_MANAGER]
    end

  end
end