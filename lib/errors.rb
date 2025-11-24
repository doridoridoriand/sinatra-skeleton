# アプリケーション固有のエラークラス定義
# これらのエラーは webapp.rb で適切にハンドリングされる
module MyApp
  # 基底エラークラス
  # すべてのカスタムエラーはこのクラスを継承する
  class Error < StandardError; end

  # バリデーションエラー
  # ユーザー入力の検証に失敗した場合に使用（HTTPステータス: 422）
  class ValidationError < Error; end
  
  # リソースが見つからないエラー
  # データベースやファイルなどのリソースが存在しない場合に使用（HTTPステータス: 404）
  class NotFoundError < Error; end
  
  # 認証エラー
  # ユーザーがログインしていない状態で保護されたリソースにアクセスした場合に使用（HTTPステータス: 401）
  class UnauthorizedError < Error; end
  
  # 権限エラー
  # ログイン済みだが、リソースへのアクセス権限がない場合に使用（HTTPステータス: 403）
  class ForbiddenError < Error; end
end
