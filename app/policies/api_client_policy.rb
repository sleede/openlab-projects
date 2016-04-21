class APIClientPolicy < ApplicationPolicy
  def destroy?
    record.calls_count == 0
  end
end
