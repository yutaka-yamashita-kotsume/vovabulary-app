class ApplicationController < ActionController::Base
  # これが current_user メソッドなどを提供します
  include Authentication
  
  # 以前の Rails と異なり、Rails 8 では include だけで動作します
end
