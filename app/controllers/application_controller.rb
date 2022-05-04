class ApplicationController < ActionController::Base
  def hello
    render html: 'hihi'
  end
end
