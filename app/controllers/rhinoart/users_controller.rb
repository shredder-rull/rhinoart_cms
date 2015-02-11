require_dependency "rhinoart/application_controller"

module Rhinoart
    class UsersController < BaseController
        before_action { authorize! :manage, :users }
        before_action :set_user, only: [:show, :edit, :update, :destroy]        

        def index
            order_str = params[:sort].present? ? "#{params[:sort]} #{params[:dir]}" : '' #'first_name, last_name asc'

            if params[:role].present?
                case params[:role]
                when 'new'
                    @users = User.where(approved: false).paginate(page: params[:page], per_page: 30)#.order(order_str)
                
                when 'admin'
                    @users = User.where("approved = 1 and (admin_role LIKE ? or admin_role LIKE ? or admin_role LIKE ?)", 
                        "%#{User::ADMIN_PANEL_ROLE_SUPER_USER}%",
                        "%#{User::ADMIN_PANEL_ROLE_USERS_MANAGER}%",
                        "%#{User::ADMIN_PANEL_ROLE_CONTENT_MANAGER}%"
                        ).paginate(page: params[:page], per_page: 30).order(order_str)
                
                else
                    @users = User.all.paginate(page: params[:page], per_page: 30).order(order_str)
                end
            else
                if params[:q].present?
                    @users = User.where('email LIKE ? or info LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").paginate(page: params[:page], per_page: 30).order(order_str)
                else
                    @users = User.paginate(page: params[:page], per_page: 30).order(order_str)
                end
            end 
        end

        def index2
            store_location
            @users = User.paginate(page: params[:page])
        end

        def show
        end	

        def new
            @user = User.new
        end

        def create
            @user = User.new(user_attributes)
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

            if new_attributes[:approved] && !new_attributes[:email].present?
            else
              new_attributes[:admin_role] = nil if !new_attributes[:admin_role].present? && can?(:manage, :all)
            end 

            if @user.update_attributes(new_attributes)
              redirect_to (params[:redirect_to] || :users), success: "User created"
            else
              render :edit
            end
        end  

        def destroy
            if params[:hard_delete]
                @user.destroy
            else
                @user.update(admin_role: nil, frontend_role: nil, approved: false)
            end

            redirect_to (params[:redirect_to] || :users), success: "User soft deleted"
        end

        private
            # Use callbacks to share common setup or constraints between actions.
            def set_user
                @user = User.find(params[:id])
            end

            # Never trust parameters from the scary internet, only allow the white list through.
            def user_attributes
                params.require(:user).permit! #(:name, :email, :password, :approved, :admin_role, :frontend_role)
            end 
    end
end
