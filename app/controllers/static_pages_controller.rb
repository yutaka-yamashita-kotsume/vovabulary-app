class StaticPagesController < ApplicationController
  # ログインしていなくても、terms と privacy だけは見れるように許可する
  allow_unauthenticated_access only: [:terms, :privacy]
  
  def terms
  end

  def privacy
  end
end
