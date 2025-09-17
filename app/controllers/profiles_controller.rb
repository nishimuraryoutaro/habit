class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = User.find(params[:id])
    @goal   = @user.goals.order(:created_at).first || @user.goals.build
    @goals  = @user.goals.order(created_at: :desc)
  end
end
