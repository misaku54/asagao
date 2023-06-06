class ApplicationController < ActionController::Base
    # すべてのビューからメソッドが使用できるようになる。
    helper_method :current_member
    class LoginRequired < StandardError; end
    class Forbidden < StandardError; end

    # 例外発生時の対応
    if Rails.env.production? || ENV["RESCUE_EXCEPTIONS"]
        rescue_from StandardError, with: :rescue_internal_server_error
        rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
        rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
    end
    rescue_from LoginRequired, with: :rescue_login_required
    rescue_from Forbidden, with: :rescue_forbidden

    # プライベートメソッド
    private
    def login_required
        raise LoginRequired unless current_member
    end

    # アプリケーションコントローラに定義することですべてのコントローラーからメソッドを使用できる
    def current_member
        # セッションがあれば、そのセッションIDでモデルオブジェクトを特定する
        # セッションがなければ、実行されないnilを返す
        Member.find_by(id: session[:member_id]) if session[:member_id]
    end

    # 例外処理
    def rescue_bad_request(exception)
        render "errors/bad_request", status: 400, layout: "error", formats: [:html]
    end

    def rescue_login_required(exception)
        render "errors/login_required", status: 403, layout: "error", formats: [:html]
    end

    def rescue_forbidden(exception)
        render "errors/forbidden", status: 403, layout: "error", formats: [:html]
    end
    
    def rescue_not_found(exception)
        render "errors/not_found", status: 404, layout: "error", formats: [:html]
    end

    def rescue_internal_server_error(exception)
        render "errors/internal_server_error", status: 500, layout: "error", formats: [:html]
    end
end
