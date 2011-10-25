require 'spec_helper'

describe TasksController do
  render_views

  before(:each) do
    @user = Factory(:user)
  end

  describe "GET 'new'" do

    before(:each) do
      test_sign_in(@user)
    end

    it "should be successful" do
      get 'projects/1/tasks/new'
      response.should be_success
    end

    it "should render the right title" do
      get :new
      response.should have_selector('title', :content => "Add task")
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @attr = { :description => "Building things now",
        :project_id => 2
      }
    end

    describe "failure" do
      
      it "should render the right title" do
        test_sign_in(@user)
        post :create, :task => @attr
        response.should have_selector('title', :content => "Add task")
      end

      it "should reject non-signed in users" do
        lambda do
          post :create, :task => @attr
        end.should_not change(Task, :count)
      end
    end

    describe "success" do

      before(:each) do
        test_sign_in(@user)
      end

      it "should display flash success" do
        post :create, :task => @attr
        flash[:success].should =~ /added/
      end

      it "should create task" do
        lambda do
          post :create, :task => @attr
        end.should change(Task, :count).by(1)
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @attr = { :description => "Building shit", :project_id => 2 }
    end

    it "should display task" do
      get :show, :id => @attr
      response.should be_success
    end
  end

end
