require 'spec_helper'

describe ProjectsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "Dooer Building", :user_id => @user }
  end

  describe "GET 'new'" do

    it "should be successful" do
      test_sign_in(@user)
      get :new
      response.should be_success
    end

    it "should have the right title" do
      test_sign_in(@user)
      get :new
      response.should have_selector('title', :content => "Add project")
    end
  end

  describe "GET 'index'" do

    it "should be able to show all projects" do
      test_sign_in(@user)
      get :index
      response.should be_success
    end

    it "should have the right title" do
      test_sign_in(@user)
      get :index
      response.should have_selector('title', :content => "All project")
    end

    #TODO: Need to understand how to test this well.
    it "should return a list of projects" do
      test_sign_in(@user)
      get :index
      # I should get a list of projects with the response
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :user_id => "" }
      end

      it "should deny non-signed in users" do
        post :create, :project => @attr
        response.should redirect_to(signin_path)
      end

      it "should not create a project" do
        test_sign_in(@user)
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end

      it "should have the right title" do
        test_sign_in(@user)
        post :create, :project => @attr
        response.should have_selector('title', :content => "Add project")
      end

      it "should render the new page" do
        test_sign_in(@user)
        post :create, :project => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        test_sign_in(@user)
        @attr = { :name => "Test Project", :user_id => @user }
      end

      it "should require a user id" do
        lambda do
          post :create, :project => @attr.merge(:user_id => "")
        end.should_not change(Project, :count)
      end

      it "should create a project" do
        lambda do
          post :create, :project => @attr
        end.should change(Project, :count).by(1)
      end

      it "should have message" do
        post :create, :project => @attr
        flash[:success].should =~ /added/
      end

      it "should redirect to project show page" do
        post :create, :project => @attr
        response.should redirect_to(project_path(1))
      end
    end
  end

  describe

end
