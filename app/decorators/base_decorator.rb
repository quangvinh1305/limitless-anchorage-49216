class BaseDecorator
  attr_reader :component

  def initialize component
    @component = component
  end

  def h
    ActionController::Base.helpers
  end

  def r
  Rails.application.routes.url_helpers
  end
end