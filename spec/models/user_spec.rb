require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :full_name => "Test User", 
      :email => "test@user.com",
      :password => "password",
      :password_confirmation => "password"
    }
  end

  it "should create an instance given valid attributes" do
    User.create!(@attr)
  end

  it "should have a valid fullname" do
    no_name = User.new(@attr.merge(:full_name => ""))
    no_name.should_not be_valid
  end

  it "should have a valid email" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = 'a' * 51
    long_username = User.new(@attr.merge(:full_name => long_name))
    long_username.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_addr = User.new(@attr.merge(:email => address))
      valid_addr.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org ex.user@foo.]
    addresses.each do |address|
      wrong_email = User.new(@attr.merge(:email => address))
      wrong_email.should_not be_valid
    end
  end

  it "should reject duplicate email" do
    User.create!(@attr)
    dup_email = User.new(@attr)
    dup_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased = @attr[:email].upcase
    User.create(@attr.merge(:email => upcased))
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end

  describe "password" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end

    describe "password validation" do

      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
      end

      it "should reject short passwords" do
        short_password = 'a' * 5
        User.new(@attr.merge(:password => short_password, :password_confirmation => short_password)).
          should_not be_valid
      end

      it "should reject long passwords" do
        long_password = 'a' * 5
        User.new(@attr.merge(:password => long_password, :password_confirmation => long_password)).
          should_not be_valid
      end
    end
  end 

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    describe "has password?" do

      it "should exist" do
        @user.should respond_to(:has_password?)
      end

      it "should return true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should return false if the passwords don't match" do
        @user.has_password?("invalid").
          should be_false
      end
    end
  end

  describe "authenticate method" do

    it "should exist" do
      User.should respond_to(:authenticate)
    end

    it "should return nil on email/password mismatch" do
      User.authenticate(@attr[:email], "wrongpass").should be_nil
    end

    it "should return nil for email address with no user" do
      User.authenticate("no@user.com", @attr[:password]).should be_nil
    end

    it "should return the user on email/password match" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertable to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end




# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  full_name          :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean(1)
#

