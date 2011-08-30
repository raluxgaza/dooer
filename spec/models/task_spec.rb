require 'spec_helper'

describe Task do

  before(:each) do
    @attr = { :description => "Build things", 
      :due_date => Date.today + 1,
      :project_id => 2 }
  end

  it "should create an instance given valid attributes" do
    Task.create!(@attr)
  end

  it "should require a name" do
    no_name = Task.new(@attr.merge(:description => ""))
    no_name.should_not be_valid
  end

  it "should require a project_id" do
    no_project = Task.new(@attr.merge(:project_id => ""))
    no_project.should_not be_valid
  end

  describe "relationship" do

    describe "project" do

      it "should respond to project" do
        project_task = Task.new(@attr)
        project_task.should respond_to(:project)
      end

      it "should have a project_id" do
        project_task = Task.new(@attr)
        project_task.should respond_to(:project_id)
      end
    end
  end
end



# == Schema Information
#
# Table name: tasks
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  due_date    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  project_id  :integer(4)
#

