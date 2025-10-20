class HomeController < ApplicationController
  before_action :authenticate_user!, only: [ :index ]
  def index
    raw = params[:date].to_s.strip
      if raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        y, m, d = raw.split("-").map(&:to_i)
        @selected_date = Date.valid_date?(y, m, d) ? Date.new(y, m, d) : Date.current
      else
        @selected_date = Date.current
      end

    if params[:goal_id].present?
      @goal = current_user.goals.find_by(id: params[:goal_id])
      if @goal.nil?
        @goal = current_user.goals.order(:created_at).first
      end
    else
      @goal = current_user.goals.order(:created_at).first
    end

    if @goal.present?
      @todos_today = current_user.daily_tasks.where(goal: @goal, date: @selected_date).order(created_at: :asc).limit(3)
    else
      @todos_today = DailyTask.none
    end

    @done_count  = @todos_today.where(done: true).count
    @total_count = @todos_today.size

    @goal_three = current_user.goals.three_month.order(:created_at).first
    # Monthly Boxes
    @calendar_months = []
    @days_with_counts = {}

    if @goal&.start_date && @goal&.target_date
      # 月初から月末まで
      whole_range = (@goal.start_date.beginning_of_month..@goal.target_date.end_of_month)
      # date => count + whole_range ex{ Date(2023,9,1) => 3, Date(2023,9,2) => 0, ... }
      @days_with_counts = current_user.daily_tasks.where(goal: @goal, date: whole_range).group(:date).count

        d = @goal.start_date.beginning_of_month
        last_month_end = @goal.target_date.end_of_month
        while d <= last_month_end
          # ActiveSupport  Date/Time
          first = d.beginning_of_month
          last  = d.end_of_month
          # First, last, header string, date array of that month
          @calendar_months << {
            first: first,
            last:  last,
            label: first.strftime("%Y-%m"),
            days:  (first..last).to_a
          }
          d = (d >> 1) # 次の月へ
        end
    end
  end

  def privacy; end
  def terms; end

  private
  def set_goal
    if params[:goal_id].present?
      @goal = current_user.goals.find_by(id: params[:goal_id])
    else
      @goal = current_user.goals.order(:created_at).first
    end
    redirect_to new_goal_path, alert: "まずは目標を作成してください。"
  end
end
