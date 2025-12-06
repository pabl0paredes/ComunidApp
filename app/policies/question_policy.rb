class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end
end
