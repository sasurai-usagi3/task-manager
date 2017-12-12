class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in?
      @groups = current_user.joined_groups.distinct
    else
    end
  end
end
