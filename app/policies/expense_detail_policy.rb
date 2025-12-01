class ExpenseDetailPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def show?
    admin_of_community?
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    admin_of_community?
  end

  def update?
    admin_of_community?
  end

  def edit?
    admin_of_community?
  end

  def destroy?
    admin_of_community?
  end



  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def admin_of_community?
    record.common_expense.community.administrator.user == user
  end

end
