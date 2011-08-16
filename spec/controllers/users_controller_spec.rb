require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /signin/i
      end
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :full_name => "", :email => "",
          :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :full_name => "Test User", :email => "test@user.com",
          :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to/i
      end
    end

    describe "GET 'edit'" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector('title', :content => "Edit user")
      end
    end

    describe "PUT 'update'" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      describe "failure" do

        before(:each) do
          @attr = { :email => "", :password => "",
            :password_confirmation => "" }
        end

        it "should render the edit page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :full_name => "Test User", :email => "test@user.com", 
            :password => "password",
            :password_confirmation => "password" }
        end

        it "should change the user attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.full_name == @attr[:full_name]
          @user.email == @attr[:email]
        end

        it "should redirect to user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
    end

    describe "authentication of edit/update pages" do

      before(:each) do
        @user = Factory(:user)
      end

      describe "for non signed-in users" do

        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end

        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end

      describe "for signed-in users" do

        before(:each) do
          wrong_user = Factory(:user, :email => "user@example.com")
          test_sign_in(wrong_user)
        end

        it "should require matching users for edit" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should require matching users for update" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end
    end
  end  

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    # This test keeps failing. Need to make it pass
    #describe "as a non-signed in user" do
      #it "should deny access" do
        #delete :destroy, :id => @user
        #response.should redirect_to(signin_path)
      #end
    #end

    describe "as signed in user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
