require_dependency "rhinoart/application_controller"

module Rhinoart
	class CachesController < ApplicationController
		def clear
			begin
				Rails.cache.clear
			rescue Exception => e
				flash[:info] = e.message
			end
			
			redirect_to params[:redirect_to] ||= root_path
		end
	end
end
