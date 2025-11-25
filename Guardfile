# Guard設定ファイル
# ファイルの変更を監視し、自動的にブラウザをリロードする

# LiveReloadの設定
# views/配下のSlimとSassファイル、webapp.rb、config.ruの変更を監視
guard 'livereload' do
  watch(%r{views/.+\.(slim|sass)$})  # テンプレートとスタイルファイル
  watch("webapp.rb")                  # メインアプリケーションファイル
  watch("config.ru")                  # Rack設定ファイル
end

# Shotgunの設定
# Thinサーバーを使用して開発サーバーを起動
# すべてのインターフェース(0.0.0.0)でポート3333をリッスン
guard :shotgun, server: "thin", host: "0.0.0.0", port: "3333" do
end
