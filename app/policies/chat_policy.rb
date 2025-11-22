class ChatPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all   # por ahora todos pueden ver los chats
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    user.administrator.present?
  end

  def destroy?
    user.administrator.present?
  end
end

def hidden?
  true
end
