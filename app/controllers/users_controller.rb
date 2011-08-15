class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index]
  
  def index
    @title = "All users"
    @user = User.find(params[:id])
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

  def show
    @user = User.find(params[:id])
    @title = @user.full_name
  end

end
