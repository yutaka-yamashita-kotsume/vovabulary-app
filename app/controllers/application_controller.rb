class ApplicationController < ActionController::Base
  # これが current_user メソッドなどを提供します
  include Authentication
end
