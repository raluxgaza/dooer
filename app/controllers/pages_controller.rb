class PagesController < ApplicationController

  def home
    @title = "Home"

    if signed_in?
      # show dashboard
    end
  end
end
