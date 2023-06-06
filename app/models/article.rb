class Article < ApplicationRecord
  validates :title, :body, :released_at, presence: true
  validates :title, length: { maximum: 80 }
  validates :body, length: { maximum: 2000 }

  # チェックをつけたら掲載終了日時を保存しない no_expitrationをクラスの属性として定義する（アクセサメソッドを追加する
  def no_expiration
    # 掲載日時があるかどうかを調べ、あればtrue,なければfalseを返す
    expired_at.blank?
  end

  def no_expiration=(val)
    # in?は引数がtrueもしくは１の場合、trueを返す。それ以外はfalse
    @no_expiration = val.in?([true,"1"])
  end
  # バリデーションの前に実行する
  before_validation do
    self.expired_at = nil if @no_expiration
  end

  # 自作バリデーション
  validate do 
    # 掲載終了日が設定されている→かつ掲載終了日が掲載開始日よりも前の時点であれば、エラーとする。
    if expired_at && expired_at < released_at
      errors.add(:expired_at, :expired_at_too_old)
    end
  end

  # スコープ設定
  scope :open_to_the_public, -> { where(member_only: false)}
  scope :visible, -> do
    now = Time.current
    where("released_at <= ?", now)
    .where("expired_at > ? OR expired_at IS NULL", now)
  end

end
