require_dependency "rhinoart/application_controller"

module Rhinoart
	class UsersController < ApplicationController

		before_action :set_user, only: [:show, :edit, :update, :destroy]
		load_and_authorize_resource

		def index
			@search = Rhinoart.user_class.ransack(search_params)
			@users = @search.result.page(params[:page]).per(30)

			# if params[:role].present?
			# 	case params[:role]
			# 	when 'new'
			# 		@users = Rhinoart.user_class.where(approved: false).page(params[:page]).per(30).order(order_str)
			#
			# 	when 'admin'
			# 		@users = Rhinoart.user_class.admin_users.page(params[:page]).per(30).order(order_str)
			# 	else
			# 		@users = Rhinoart.user_class.all.page(params[:page]).per(30).order(order_str)
			# 	end
			# else
			# 	if params[:q].present?
			# 		@users = Rhinoart.user_class.where('email LIKE ? or info LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").page(params[:page]).per(30).order(order_str)
			# 	else
			# 		@users = Rhinoart.user_class.page(params[:page]).per(30).order(order_str)
			# 	end
			# end
		end

		def show
			@activities = PaperTrail::Version.where(whodunnit: @user).order(created_at: :desc).page(params[:page]).per(40)
		end

		def new
			@user = Rhinoart.user_class.new
		end

		def create
			@user = Rhinoart.user_class.new(user_attributes)
			if @user.save
				flash[:success] = t("_WELCOME")
				redirect_to users_path
			else
				render 'new'
			end
		end

		def edit  
		end

		def update
			new_attributes = user_attributes.to_hash.symbolize_keys
			new_attributes.delete(:password) if new_attributes[:password].blank?

			if @user.update_attributes(new_attributes)
				redirect_back_or (params[:redirect_to] || can?(:manage, :users) ? :users : root_path), success: "User updated"
			else
			  render :edit
			end
		end

		def destroy
			# if params[:hard_delete]
			# 	@user.destroy
			# else
			# 	if params[:clear_rights].present?
			# 		@user.roles.each do |role|
			# 			@user.remove_role role.name rescue 1
			# 		end
			# 	end
			# 	@user.update(approved: false)
			# end
			@user.roles = []

			redirect_to (params[:redirect_to] || :users), success: "Roles were removed from user"
		end

		private

		# Use callbacks to share common setup or constraints between actions.
		def set_user
			@user = Rhinoart.user_class.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def user_attributes
			params.require(:user).permit!
		end

		def search_params
			params[:q]
		end

	end
end
