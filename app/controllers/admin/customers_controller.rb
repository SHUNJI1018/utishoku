class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.all
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customers_path
    else
      render :edit
    end
  end


  private

  def customer_params
    params.require(:customer).permit(:nickname, :first_name, :last_name, :first_kana_name, :last_kana_name, :is_valid, :email)
  end

end
