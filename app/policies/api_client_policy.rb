class APIClientPolicy < ApplicationPolicy
  def destroy?
    record.calls_count
  end
end
