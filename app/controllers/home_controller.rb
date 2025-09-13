class HomeController < ApplicationController
  def index
    redirect_to tasks_path if user_signed_in?
  end
end
