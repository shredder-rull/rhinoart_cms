require_dependency "rhinoart/application_controller"

module Rhinoart
	class DashboardController < ApplicationController
		layout 'layouts/rhinoart/application'
		# before_filter :signed_in_user
		# before_filter { access_only_roles %w[ROLE_ADMIN ROLE_EDITOR ROLE_SALLER] }	

		def index
			@activities = PaperTrail::Version.where('created_at > ?', 2.days.ago).where.not(whodunnit: nil).order(created_at: :desc)
			unless can?(:manage, :all)
				@activities = @activities.where(whodunnit: current_user.id)
			end

			@activities = @activities
			@users = Rhinoart.user_class.where(id: @activities.map(&:whodunnit).uniq).group_by(&:id)
		end
	end
end
