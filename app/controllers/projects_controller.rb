class ProjectsController < ApplicationController
  #before_filter :authenticate, :except => [:new, :create]

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
end
