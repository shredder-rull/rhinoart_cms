module Rhinoart
  module Helpers
    module ApplicationHelper
      extend ActiveSupport::Concern

      included do
        before_action :set_current_user
      end

      private

      def redirect_back_or(default, options = {})
        redirect_to(session[:return_to] || default, options)
        session.delete(:return_to)
      end

      def store_location
        session[:return_to] = request.url
      end

      def set_current_user
        Registry.current_user = current_user
      end

    end
  end
end
