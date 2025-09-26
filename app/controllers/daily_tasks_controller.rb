class DailyTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal_and_date, only: [ :new, :create ]
  def new
    @goal = current_user.goals.find_by(id: params[:goal_id])

    raw = params[:date].to_s.strip

    if raw.present? && raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      y, m, d = raw.split("-").map(&:to_i)
      @date = Date.valid_date?(y, m, d) ? Date.new(y, m, d) : Date.current
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
    slots = slots_from_params(params[:daily_tasks]).first(3)
    base = current_user.daily_tasks.where(goal: @goal, date: @date)

    slots.each do |s|
      task = s[:id].present? ? (base.find_by(id: s[:id]) || base.new) : base.new
      task.title = s[:title].to_s

      unless task.save
        redirect_to new_daily_task_path(goal_id: @goal.id, date: @date),
                    alert: task.errors.full_messages.to_sentence
        return
      end
    end
    redirect_to root_path(goal_id: @goal.id, date: @date), notice: "その日のタスクを保存しました。"
  end
  def update
    task = current_user.daily_tasks.find(params[:id])
    if task.update(params.require(:daily_task).permit(:done, :title))
      redirect_back fallback_location: root_path(goal_id: task.goal_id, date: task.date), notice: "更新しました。"
    else
      redirect_back fallback_location: root_path(goal_id: task.goal_id, date: task.date), alert: "更新できませんでした"
    end
  end

  private

  def set_goal_and_date
    gid  = params[:goal_id].presence
    date = params[:date].presence

    if gid.blank? || date.blank?
      first_slot = begin
        raw = params[:daily_tasks] || {}
        raw.is_a?(Array) ? raw.first : raw.values.first
      rescue
        nil
      end

      if first_slot
        h   = first_slot.respond_to?(:to_h) ? first_slot.to_h : first_slot
        tid = (h["id"] || h[:id]).presence
        if tid && (task = current_user.daily_tasks.find_by(id: tid))
          gid  ||= task.goal_id
          date ||= task.date&.iso8601
        end
      end
    end

    @goal = current_user.goals.find_by(id: gid)
    @date = (Date.iso8601(date) rescue Date.current)

    unless @goal
      redirect_to root_path, alert: "目標が見つかりません"
    end
  end

  def slots_from_params(raw)
     array =
    if raw.is_a?(Array)
      raw
    elsif raw.respond_to?(:values)
      raw.values
    else
      []
    end

    array.map do |slot|
      h =
        if slot.respond_to?(:to_unsafe_h)
          slot.to_unsafe_h
        elsif slot.respond_to?(:to_h)
          slot.to_h
        else
          slot
        end

      {
        id:    (h["id"] || h[:id]),
        title: (h["title"] || h[:title]).to_s
      }
    end
  end
end
