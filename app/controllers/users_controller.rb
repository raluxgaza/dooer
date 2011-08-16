class UsersController < ApplicationController
  before_filter :authenticate,  :only => [:index, :edit, :update]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :admin_user,    :only => :destroy
  
  def index
    @title = "All users"
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.full_name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to dooer"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed" }
  end

  private 

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end
end
