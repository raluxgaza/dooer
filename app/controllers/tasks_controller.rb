class TasksController < ApplicationController
  before_filter :authenticate

  def new
    @title = "Add task"
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      redirect_to project_path, :flash => { :success => "Task added successfully" }
    else
      @title = "Add task"
      render "new"
    end
  end

  def show
    @title = "Show task"
    @task = Task.find(params[:id])
  end

  def edit
    @title = "Edit task"
    @task = Task.find(params[:id])
  end

  def update
    if @task.update_attributes(params[:task])
      redirect_to project_task_path, 
        :flash => { :success => "Task updated successfully" }
    else
      @title = "Edit task"
      render 'edit'
    end
  end

end
