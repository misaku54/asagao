body =
  "今晩は久しぶりに神宮で野球観戦。内野B席の上段に着席。\n\n" +
  "先発はヤクルトがブキャナン、広島はジョンソン。" +
  "2回裏に中村選手のセーフティスクイズなどでヤクルトが3点を先取。" +
  "そして、8回裏には代打・荒木選手がレフトスタンドへ2号満塁ホームラン。\n\n" +
  "ブキャナン投手の今季初完封を見届けて、気分良く家路に着きました。"

# Taro Jiro Hanaの３人のブログデータを10個ずつ作成する。
%w(Taro Jiro Hana).each do |name|
  # ３人の名前をキーにして、それぞれメンバーテーブルのモデルオブジェクトを作成する。
  member = Member.find_by(name: name)
  0.upto(9) do |idx|
    Entry.create(
      author: member, #memberテーブルのモデルオブジェクトを代入することで、外部キーにメンバーテーブルのidを格納し関連を持たせる。。
      title: "野球観戦#{idx}",
      body: body,
      posted_at: 10.days.ago.advance(days: idx),
      status: %w(draft member_only public)[idx % 3]
    )
  end
  
end