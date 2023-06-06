class TopController < ApplicationController
  def index
    # 掲載期間中のニュースを５件まで掲載開始順
    @articles = Article.visible.order(released_at: :desc).limit(5)
    # ログインしていなければ、会員限定ニュースは非表示
    @articles = @articles.open_to_the_public unless current_member
  end

  def about
  end


  def bad_request
    raise ActionController::ParameterMissing, ""
  end
  def forbidden
    raise Forbidden, ""
  end
  def internal_server_error
    raise
  end
end
