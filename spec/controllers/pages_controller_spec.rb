require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Task Management"
  end

  describe "GET 'home'" do

    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector('title', :content => @base_title + " -- Home")
    end
  end

end
