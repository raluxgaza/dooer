require 'spec_helper'

describe Project do

  before(:each) do
    @attr = { :name => "Building dooer" }
  end

  it "should create an instance given valid attributes" do
    Project.create!(@attr)
  end

  it "should require a name" do
    no_name = Project.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end
end
