class DailyTasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @goal = current_user.goals.find_by(id: params[:goal_id])

    raw = params[:date].to_s.strip

    if raw.present? && raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      y, m, d = raw.split("-").map(&:to_i)
      if Date.valid_date?(y, m, d)
        @date = Date.new(y, m, d)
      else
        @date = Date.current
      end
    else
      @date = Date.current
    end

    @tasks = current_user.daily_tasks.where(goal: @goal, date: @date).order(:created_at).limit(3).to_a
    (3 - @tasks.size).times do
      # @taskに配列として代入<<
      @tasks << current_user.daily_tasks.new(goal: @goal, date: @date)
    end
  end
end