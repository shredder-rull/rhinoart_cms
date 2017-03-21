module Rhinoart
  class UserWrapper

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def method_missing(id, *args)
      user.public_send(id, *args)
    end

    def has_role?(*args)
      user.respond_to?(:has_role?) ? user.has_role?(*args) : nil
    end

  end
end