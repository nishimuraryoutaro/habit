class DailyTasksController < ApplicationController
  before_action :authenticate_user!
end