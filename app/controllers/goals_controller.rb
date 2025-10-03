class GoalsController < ApplicationController
  before_action :authenticate_user!
   before_action :set_goal, only: [ :show, :edit, :update, :destroy ]

  def index
    @goals = current_user.goals.all
  end

  def show
    @goal = current_user.goals.find(params[:id])

    raw = params[:date].to_s.strip
    if raw.empty?
      @selected_date = Date.current
    elsif raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      y, m, d = raw.split("-").map(&:to_i)
      if Date.valid_date?(y, m, d)
        @selected_date = Date.new(y, m, d)
      else
        @selected_date = Date.current
      end
    else
      @selected_date = Date.current
    end

    @calendar_months  = []
    @days_with_counts = {}

    if @goal.start_date && @goal.target_date
      whole = (@goal.start_date.beginning_of_month..@goal.target_date.end_of_month)
      @days_with_counts = current_user.daily_tasks.where(goal: @goal, date: whole).group(:date).count

      d = @goal.start_date.beginning_of_month
      last = @goal.target_date.end_of_month
      while d <= last
        first = d.beginning_of_month
        eom   = d.end_of_month
        @calendar_months << {
          first: first,
          last:  eom,
          label: first.strftime("%Y-%m"),
          days:  (first..eom).to_a
        }
        d = (d >> 1)
      end
    end

    @tasks_today = current_user.daily_tasks.where(goal: @goal, date: @selected_date).order(:created_at).limit(3)
  end

  def new
    @goal = current_user.goals.new
  end

  def create
    @goal = current_user.goals.new(goal_params)
    if @goal.save
      redirect_to root_path(@goal), notice: "Goalを作成しました"
    else
      flash.now[:error] = "作成に失敗しました"
      show
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to goal_path(@goal, goal_id: @goal.id), notice: "目標を更新しました。"
    else
      flash.now[:alert] = t("更新を失敗しました")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    goal = current_user.goals.find_by(id: params[:id])
    unless goal
      return redirect_to profile_path(current_user), alert: "目標が見つかりません。"
    end
    goal.daily_tasks.destroy_all

    if goal.destroy
      redirect_to profile_path(current_user), notice: "削除しました。"
    else
      redirect_to profile_path(current_user), alert: "削除に失敗しました。"
    end
  end

  private
  def set_goal
    @goal = current_user.goals.find(params[:id])
  end
  def goal_params
    params.require(:goal).permit(:title, :description, :start_date, :target_date, :one_month_title, :one_week_title)
  end
end
