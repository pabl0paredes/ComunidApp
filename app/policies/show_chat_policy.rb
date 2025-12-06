class ShowChatPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.present? && user == record.user
  end
end
