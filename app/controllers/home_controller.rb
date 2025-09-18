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

    if params[:goal_id].present?
      @goal = current_user.goals.find_by(id: params[:goal_id])
      if @goal.nil?
        @goal = current_user.goals.order(:created_at).first
      end
    else
      @goal = current_user.goals.order(:created_at).first
    end
  end
end
