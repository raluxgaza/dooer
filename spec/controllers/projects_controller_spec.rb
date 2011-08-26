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

  describe "GET 'edit'" do

    describe "failure" do
      # project can't be blank
      # only owner of project can edit project
      before(:each) do
        @attr = { :name => "" }
        @project = { :name => "Good project", :user_id => 2 }
      end

      it "should be deny non-signed in users" do
        get :edit, :id => @project
        response.should_not be_success
      end

      it "should have the right title" do
        test_sign_in(@user)
        get :edit, :id => @project
        response.should have_selector('title', :content => "Edit project")
      end
    end
  end
  
  describe "PUT 'update'" do

    before(:each) do
      test_sign_in(@user)
      @project = Factory(:project)
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :user_id => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @project, :project => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @project, :project => @attr
        response.should have_selector('title', :content => "Edit project")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New project", :user_id => 1 }
      end

      it "should change user attributes" do
        put :update, :id => @project, :project => @attr
        @project.reload
        @project.name.should == @attr[:name]
        @project.user_id.should == @attr[:user_id]
      end

      it "should redirect to updated project page" do
        put :update, :id => @project, :project => @attr
        response.should redirect_to(project_path(@project))
      end

      it "should have flash message" do
        put :update, :id => @project, :project => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @project = Factory(:project)
    end

    describe "as a non-signed in user" do
      it "should deny access" do
        delete :destroy, :id => @project
        response.should redirect_to(signin_path)
      end
    end
  end

end
