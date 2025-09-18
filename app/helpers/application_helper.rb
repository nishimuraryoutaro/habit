module ApplicationHelper
  def home_path_with_goal(fallback_goal_id = nil)
    gid = params[:goal_id].presence || fallback_goal_id
    gid.present? ? root_path(goal_id: gid) : root_path
  end
end
