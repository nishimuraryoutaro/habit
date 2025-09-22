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

  def create
    @goal = current_user.goals.find_by(id: params[:goal_id])

    raw = params[:daily_tasks] || {}
      if raw.is_a?(Array)
        raw
      elsif raw.respond_to?(:values)
        raw.values
      else
        []
      end

      if task.save
        redirect_to root_path, notice: "OK"
      else
        redirect_to new_daily_task_path(goal_id: @goal.id, date: @date), alert: task.errors.full_messages.to_sentence
      end
  end
end
