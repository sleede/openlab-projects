class ApiClientPolicy < ApplicationPolicy
  def destroy?
    record.calls_count
  end
end
