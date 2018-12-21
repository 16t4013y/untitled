class ApplicationController < ActionController::Base
  # ↓これを追加↓
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:acc_id, :name, :university, :faculty, :department, :grade, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :grade, :introduction])

  end
  # ↑ここまで↑
end
