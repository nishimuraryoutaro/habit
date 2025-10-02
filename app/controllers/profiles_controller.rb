class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user   = current_user
    @goals  = Goal.where(user_id: @user.id).order(created_at: :desc)
  end

  def create
    @user = User.find(params[:profile_id])
    goal = @user.goals.find(params[:goal_id])
    # Goalのidをセッションに保存session[...] はユーザーごとの一時的な保存場所
    session[:current_goal_id] = goal.id
    redirect_to root_path(goal_id: goal.id), notice: "この目標をHOMEの表示対象にしました。"
  end

  def update
    @user = current_user
    @goal = @user.goals.order(:created_at).first || @user.goals.build
    if @goal.update(goal_params)
      redirect_to goal_path(@goal, goal_id: @goal.id), notice: "目標（期間）を更新しました。"
    else
      redirect_to profile_path(@user), alert: @goal.errors.full_messages.join(", ")
    end
  end

  private
  def goal_params
    params.require(:goal).permit(:title, :start_date, :target_date, :description)
  end
end
