class Entry < ApplicationRecord
  # リレーションの設定
  belongs_to :author, class_name: "Member", foreign_key: "member_id" #メソッド名をauthorに変更。関連するカラム名をmember_idに設定

  # ヴァリデーション設定
  STATUS_VALUES = %w(draft member_only public)
  validates :title, presence: true, length: { maximum: 200 }
  validates :body, :posted_at, presence: true
  validates :status, inclusion: { in: STATUS_VALUES }

  # スコープ設定
  scope :common, -> { where(status: "public") } #公開記事のみ
  scope :published, ->{ where("status <> ?", "draft") } #下書き以外の記事
  scope :full, ->(member) { where("status <> ? OR member_id = ?", "draft", member.id) } #下書き以外の記事または、本人の下書き
  scope :readable_for, ->(member) { member ? full(member) : common } #ログインしているかでスコープを分岐させる。

  # クラスメソッド設定
  class << self
    def status_text(status)
      I18n.t("activerecord.attributes.entry.status_#{status}")
    end

    def status_options
      # [["下書き","draft"],["会員限定","member_only"],["公開","public"]]を返すメソッド
      STATUS_VALUES.map { |status| [status_text(status), status] }
    end
  end
  
end
