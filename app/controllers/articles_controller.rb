class ArticlesController < ApplicationController
  # index、showアクション以外はログインしていないと例外となる。
  before_action :login_required, except: [:index, :show]

  # 記事一覧
  def index
    # articlesテーブルを掲載日時の降順にしたモデルオブジェクトを生成する。
    @articles = Article.order(released_at: :desc)
    # ログインしていない場合は会員限定のニュースは表示しない
    @articles.open_to_the_public unless current_member
    # 管理者以外には掲載期間内のニュースを表示し、管理者にはすべてのニュースを表示する。
    unless current_member&.administrator? 
      @article = Article.visible
    end

    @articles = @articles.page(params[:page]).per(5)
  end

  # 記事詳細
  def show
    articles = Article.all
    articles = articles.open_to_the_public unless current_member

    unless current_member&.administrator?
      articles = articles.visible
    end
    @article = articles.find(params[:id])
  end

  # 新規登録フォーム
  def new
    @article = Article.new
  end

  # 編集フォーム
  def edit
    @article = Article.find(params[:id])
  end

  # 新規作成
  def create
    @article = Article.new(article_params)
    if @article.save
      # 詳細画面へ
      redirect_to @article, notice: "ニュースを作成しました。"
    else
      # 新規登録フォームへレンダリング
      render "new" #コントローラーを経由せずに、アクション直後にビューを表示する。
    end
  end

  def update
    @article = Article.find(params[:id])
    @article.assign_attributes(article_params)
    if @article.save
      redirect_to @article, notice: "ニュース記事を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :articles
  end
  
  private
  # ストロングパラメータ設定
  def article_params
    params.require(:article).permit(
      :title,
      :body,
      :released_at,
      :no_expiration,
      :expired_at,
      :member_only
    )
  end
end
