require_dependency "rhinoart/application_controller"

module Rhinoart
	class StructuresController < ApplicationController
		before_action { authorize!(:manage, :content) }

		def index
			store_location
			@pages = Rhinoart::Page.page(params[:page])
		end

	end
end
