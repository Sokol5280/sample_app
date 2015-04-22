class UsersController < ApplicationController

	# before_action :set_user, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy


  # GET /users
  # GET /users.json
  def index
		@users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
			flash[:success] = "Добро пожаловать на страницу Complx Services!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
			flash[:success] = "Ваш профиль был успешно обновлён."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
		User.find(params[:id]).destroy
		flash[:success] = "Пользователь был успешно удалён."
    redirect_to users_url
  end
  
	def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
	
	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
	
		# Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
	
		def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
	
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end