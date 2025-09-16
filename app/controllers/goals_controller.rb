class GoalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @goals = current_user.goals.all
  end

  def show
    @goal = current_user.goals.find(params[:id])
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
    @goal = current_user.goals.find(params[:id])
  end

  def update
    @goal = current_user.goals.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goals_path, notice: t("views.goals.update.success")
    else
      flash.now[:alert] = t("views.goals.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal = current_user.goals.find(params[:id])
    @goal.destroy
    redirect_to goals_path, notice: t("views.goals.destroy.success")
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :description, :start_date)
  end
end