class CommonSpacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end



  def new?
    admin_of_community_for_new_space?
  end
  def show?
    true
  end

  def create?
    admin_of_community_for_new_space?
  end

  def update?
    admin_of_existing_space?
  end

  def destroy?
    admin_of_existing_space?
  end

  def manage_hours?
    admin_of_existing_space?
  end

  private

  def admin_of_community_for_new_space?
    record.is_a?(Community) && record.administrator_id == user.id
  end


  def admin_of_existing_space?
    record.respond_to?(:community) && record.community.administrator_id == user.id
  end
end
