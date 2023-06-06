class EntriesController < ApplicationController
  # show、index以外のアクションはログインしていないと使用できない。
  before_action :login_required, except: [:index, :show]

  # 記事一覧
  def index
    # ネストされたリソースか調べる
    if params[:member_id]
      # 個人のメンバーオブジェクトを特定する。
      @member = Member.find(params[:member_id])
      # 特定したメンバーオブジェクトを元に、関連するエントリオブジェクトを特定する。
      @entries = @member.entries
    else
      # すべてのエントリオブジェクトを取得する。
      @entries = Entry.all
    end
    # ログインしているかどうかでエントリオブジェクト制限をかける。
    @entries = @entries.readable_for(current_member)
      .order(posted_at: :desc).page(params[:page]).per(3)
  end

  # 詳細記事
  def show
    # ログインしているかどうかでエントリオブジェクトに制限をかける。
    @entry = Entry.readable_for(current_member).find(params[:id])
  end

  # 新規登録フォーム
  def new
    @entry = Entry.new(posted_at: Time.current)
  end

  # 編集フォーム
  def edit
    @entry = current_member.entries.find(params[:id])
  end

  # 新規作成
  def create
    @entry = Entry.new(entry_params)
    @entry.author = current_member
    if @entry.save
      redirect_to @entry, notice: "記事を作成しました。"
    else
      render "new"
    end
  end

  # 更新
  def update
    @entry = current_member.entries.find(params[:id])
    @entry.assign_attributes(entry_params)
    if @entry.save
      redirect_to @entry, notice: "記事を更新しました。"
    else
      render "edit"
    end
  end

  # 削除
  def destroy
    @entry = current_member.entries.find(params[:id])
    @entry.destroy
    redirect_to :entries, notice: "記事を削除しました。"
  end

  private
  def entry_params
    params.require(:entry).permit(
      :member_id,
      :title,
      :body,
      :posted_at,
      :status
    )
  end
end
