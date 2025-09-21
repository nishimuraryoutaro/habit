class GoalsController < ApplicationController
  before_action :authenticate_user!
   before_action :set_goal, only: [ :show, :edit, :update, :destroy ]

  def index
    @goals = current_user.goals.all
  end

  def show
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
    @goal.destroy
    redirect_to goals_path, notice: "目標を削除しました。"
  end

  private
  def set_goal
    @goal = current_user.goals.find(params[:id])
  end
  def goal_params
    params.require(:goal).permit(:title, :description, :start_date)
  end
end