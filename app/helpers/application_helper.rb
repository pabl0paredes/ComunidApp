module ApplicationHelper

  def user_name_color_class(user_id)
  colors = %w[user-name-1 user-name-2 user-name-3 user-name-4 user-name-5]
  index = user_id % colors.length
  colors[index]
end

end
