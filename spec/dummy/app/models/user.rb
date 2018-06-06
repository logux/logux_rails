# frozen_string_literal: true

class User
  attr_reader :kind

  def initialize(kind)
    @kind = kind
  end

  def admin?
    kind == :admin
  end

  def user?
    kind == :user
  end

  def staff?
    admin? || user?
  end

  def client?
    superclient? || kind == :client
  end

  def superclient?
    kind == :superclient
  end
end
