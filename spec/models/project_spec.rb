require 'spec_helper'

describe Project do

  before(:each) do
    @attr = { :name => "Building dooer", :user_id => 1 }
  end

  it "should create an instance given valid attributes" do
    Project.create!(@attr)
  end

  it "should require a name" do
    no_name = Project.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  describe "relationship" do

    describe "user" do

      it "should require a user_id" do
        user_project = Project.new(@attr.merge(:user_id => ""))
        user_project.should_not be_valid
      end

      it "should respond to user" do
        user_project = Project.new(@attr)
        user_project.should respond_to(:user)
      end
    end
  end
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer(4)
#

