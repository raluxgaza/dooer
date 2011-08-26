class ProjectsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @project = Project.find(:all)
    @title = "All project"
  end

  def new
    @project = Project.new
    @title = "Add project"
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect_to project_path(@project.id), :flash => { :success => "Project added successfully" }
    else
      @title = "Add project"
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @title = "The #{@project.name} project"
  end

  def edit
    @title = "Edit project"
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to project_path(@project), :flash => { :success => "Project updated!" }
    else
      render 'edit'
      @title = "Edit project"
    end
  end

  def destroy

  end

  private 

    def correct_user
      @project = Project.find(params[:id])
      redirect_to signin_path unless current_user?(@project.user)
    end
end
