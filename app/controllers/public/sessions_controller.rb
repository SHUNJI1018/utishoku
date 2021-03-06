# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  protected

  # ユーザー凍結に関する条件
  def reject_customer
    customer = Customer.find_by(email: params[:customer][:email].downcase)
    if customer && (customer.valid_password?(params[:customer][:password]) && (user.active_for_authentication? == false))
      redirect_to new_customer_session_path
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
