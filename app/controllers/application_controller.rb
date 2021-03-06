class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_q

  # 検索機能
  def search
    @results = @q.result.order(created_at: :desc)
  end

  protected

  # ログイン後の遷移先の設定
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      index_path
    when Customer
      index_path
    end
  end

  # ログアウト、退会した場合の遷移先
  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
    when :customer
      root_path
    when :admin
      new_admin_session_path
    end
  end

  def configure_permitted_parameters
    # ユーザー用の新規登録情報用
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[nickname last_name first_name last_kana_name first_kana_name email])
    # 管理者用のログイン画面と会員側のサインイン画面用
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end

  private

  # 検索機能
  def set_q
    @q = Diy.ransack(params[:q])
  end
end
