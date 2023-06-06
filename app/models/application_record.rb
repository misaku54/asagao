class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 画像ファイルのデータ形式の定数を設定
  ALLOWED_CONTENT_TYPES = %q{
    image/jpeg
    image/png
    image/gif
    image/bmp
  }
end
