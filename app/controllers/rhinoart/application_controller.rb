# encoding: utf-8
module Rhinoart
	class ApplicationController < ActionController::Base
		include Helpers::ApplicationHelper

		before_action :set_current_user
		before_action :check_user_access
		before_action :set_paper_trail_whodunnit

		rescue_from CanCan::AccessDenied, :with => :access_denied_handler

		private

		def access_denied_handler(exception)
			if user_signed_in?
				if !can? :access, :admin_panel
					redirect_to main_app.root_path, alert: exception.message
				else
					flash.now[:info] = "Access denied."
					render :template => 'rhinoart/shared/no_approved', :status => 403
				end
			else
				redirect_to rhinoart.sign_in_path(redirect_to: request.fullpath), alert: exception.message
			end
		end

		def set_locale
			if current_user.present? && current_user.locales.present? && current_user.locales.count == 1
				I18n.locale = params[:locale] || current_user.locales.first || I18n.default_locale
			else
				I18n.locale = params[:locale] || I18n.default_locale
			end
		end

		# Force signout to prevent CSRF attacks
		def handle_unverified_request
			sign_out
			super
		end

		def default_url_options(options={})
			if I18n.locale != I18n.default_locale
				{ locale: I18n.locale }
			else
				{ locale: nil }
			end
		end

		def check_user_access
			authorize! :access, :admin_panel
		end

		def translate(key, options = {})
			I18n.t("rhinoart.#{key}", {default: [:key]}.merge(options))
		end
		alias_method :t, :translate

	end
end
