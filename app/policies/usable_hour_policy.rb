class UsableHourPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  
  def update?
    user_is_admin_of_community?
  end

  def destroy?
    user_is_admin_of_community?
  end

  private

  def user_is_admin_of_community?
    record.common_space.community.administrator_id == user.id
  end

end
