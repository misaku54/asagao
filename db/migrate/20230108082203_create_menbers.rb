class CreateMenbers < ActiveRecord::Migration[5.2]
  def change
    create_table :menbers do |t|
      # t.カラムの型 ：カラム名（属性名）
      t.integer :number, nill: false                          #背番号
      t.string :name, nill: false                             #ユーザー名
      t.string :full_name                                     #本名
      t.string :email                                         #メールアドレス
      t.date :birthday                                        #生年月日
      t.integer :sex, null: false, default: 1                 #性別（1：男性、2：女性）
      t.boolean :administrator, null: false, default: false   #管理者フラグ
      t.timestamps
    end
  end
end
