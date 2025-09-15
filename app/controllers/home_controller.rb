class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    raw = params[:date].to_s.strip
      if raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        y, m, d = raw.split("-").map(&:to_i)
        @selected_date = Date.valid_date?(y, m, d) ? Date.new(y, m, d) : Date.current
      else
        @selected_date = Date.current
      end
  end

  def create
    goal = @user.goals.new(goal_params) # 目的日が空でもモデルで+3ヶ月補完
    if goal.save
      redirect_to profile_path(@user), notice: "新しい目標を作成しました。"
    else
      redirect_to profile_path(@user), alert: goal.errors.full_messages.join(", ")
    end
  end

  def goal_params
    params.require(:goal).permit(:title, :start_date, :target_date, :description)
  end
end
