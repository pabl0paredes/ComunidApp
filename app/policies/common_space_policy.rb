class CommonSpacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end


  def new?
    admin?
  end

  def show?
    true
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def manage_hours?
    admin_of_existing_space?
  end

  private

  def admin?
    record.community.administrator.user == user
  end


  def admin_of_existing_space?
    record.community.administrator.user_id == user.id
  end
end
