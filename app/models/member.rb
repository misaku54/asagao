class Member < ApplicationRecord
    # has_secure_passwordメソッドを使用
    has_secure_password
    
# Active_Storageの設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    # クラスメソッド　モデルオブジェクトに対して１個のファイルを添付できるようになる
    has_one_attached :profile_picture
    # クラスメソッド　モデルに読み書き可能な属性を追加する。この属性に一時的に画像を保存する。
    attribute :new_profile_picture
    attribute :remove_profile_picture, :boolean

    # エントリーテーブルとの関連付け。オプションでメンバーテーブルが削除されたときに、関連するエントリーテーブルも削除する。
    has_many :entries,dependent: :destroy

# ヴァリテーション設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    # 背番号が空値禁止、１以上１００未満の整数
    validates :number, presence: true,
        numericality: {
            only_integer: true,
            greater_then: 0,
            less_then: 100,
            allow_blank: true
        },
        uniqueness: true
    # 名前が空値禁止、半角英数字のみ、文字列の先頭はアルファベット２文字以上２０文字以下、会員の間で重複禁止
    # withオプションで与えられた正規表現と属性の値がマッチするかどうかを検証
    validates :name, presence: true,
        format: { with: /\A[A-Za-z][A-Za-z0-9]*\z/, allow_blank: true, message: :invalid_member_name },
        length: { minimum: 2,maximum: 20, allow_blank: true },
        uniqueness: { case_sensitive: false } 
    validates :full_name,presence: true,length: { maximum: 20 }
    validates :email, email: { allow_blank: true }
    
    attr_accessor :current_password #ゲッターとセッターの設定
    validates :password, presence: { if: :current_password } # current_passwordに値がセットされている場合に、空値チェックのバリテーションが働く
    validate if: :new_profile_picture do
        if new_profile_picture.respond_to?(:content_type)
            unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
                errors.add(:new_profile_picture, :invalid_image_type)
            end
        else
            errors.add(:new_profile_picture, :invalid)
        end
    end

# コールバック設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    before_save do
        # save前に仮属性new_profile_pictureに値が入っていれば、それをprofile_pictureに代入する。
        if new_profile_picture
            self.profile_picture = new_profile_picture
        # 仮属性remove_profile_pictureに値が入っていれば、profile_pictureを削除する。
        elsif remove_profile_picture
            self.profile_picture.purge
        end
    end

# クラスメソッド（モデルオブジェクトから直接呼び出せるが、インスタンスからは呼び出せない    
    class << self
        # 会員検索機能
        def search(query)
            rel = order("number")
            # 検索キーがあるかどうか確認
            if query.present?
                rel = rel.where("name LIKE ? OR full_name LIKE ?","%#{query}%","%#{query}%")
            end
            #戻り値
            rel
        end
    end
# インスタンスメソッド（インスタンス化しないと呼び出せない
    def aaa
        puts "もどる"
    end
end
