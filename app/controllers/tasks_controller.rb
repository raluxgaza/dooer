class TasksController < ApplicationController
  before_filter :authenticate

  def new
    @title = "Add task"
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      # flash message & redirect to project
      redirect_to project_path, :flash => { :success => "Task added successfully" }
    else
      @title = "Add task"
      render "new"
    end
  end

  def show
  end

  def edit
  end

end
