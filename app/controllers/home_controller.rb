class HomeController < ApplicationController
  def index
    raw = params[:date].to_s.strip
      if raw.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        y, m, d = raw.split("-").map(&:to_i)
        @selected_date = Date.valid_date?(y, m, d) ? Date.new(y, m, d) : Date.current
      else
        @selected_date = Date.current
      end
  end
end
