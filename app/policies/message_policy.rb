class MessagePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all   # Por ahora todos pueden ver los mensajes
    end
  end

  def show?
    true
  end

  def create?
    user.present?  # cualquiera logueado
  end

  def update?
    user.administrator.present? || record.user == user
  end

  def destroy?
    user.administrator.present? || record.user == user
  end
end
