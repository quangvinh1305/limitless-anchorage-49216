class BaseDecorator
  attr_reader :component

  def initialize component
    @component = component
  end

  def helpers
    ActionController::Base.helpers
  end

  def routes
  Rails.application.routes.url_helpers
  end
end