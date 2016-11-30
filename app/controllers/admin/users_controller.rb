class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i(show edit update destroy archive)
  def index
    @users = User.excluding_archived.order(:email)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "User has been created."
    else
      flash.now[:alert] = "User has not been created."
      render "new"
    end
  end

  def edit
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User has been updated."
    else
      flash.now[:alert] = "User has not been updated."
      render "edit"
    end
  end

  def archive
    if @user == current_user
      flash[:alert] = "You cannot archive yourself!"
    else
      @user.archive
      flash[:notice] = "User has been archived."
    end

    redirect_to admin_users_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :admin)
    end

    def set_user
      @user = User.find(params[:id])
    end
end