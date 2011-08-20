require 'spec_helper'

describe ProjectsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :name => "Dooer Building" }
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

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "" }
      end

      it "should not create a project" do
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end

      it "should have the right title" do
        post :create, :project => @attr
        response.should have_selector('title', :content => "Add project")
      end

      it "should render the new page" do
        post :create, :project => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        test_sign_in(@user)
        @attr = { :name => "Test Project" }
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

end
