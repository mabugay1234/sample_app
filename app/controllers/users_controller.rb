class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :find_user, only: %i(show destroy)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.page_limit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:success] = t ".users_controller.success"
      redirect_to root_url
    else
      flash[:danger] = t ".users_controller.danger"
      render :new
    end
  end

  def show
    return if @user.present?
    flash[:error] = t ".not"
    redirect_to signup_path
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".danger"
      render :edit
    end
  end

  def destroy
    if @user&.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "ession.create.logged_danger"
    redirect_to login_url
  end

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "ession.create.logged_danger"
    redirect_to login_url
  end

  def correct_user
    find_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
