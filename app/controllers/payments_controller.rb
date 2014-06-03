class PaymentsController < ApplicationController

  respond_to :html

  def index
    redirect_to root_path
  end

  def new

    payment = Payment.new
    payment.amount = params[:amount]

    @payment = payment

  end

  def create

    payment = Payment.create payment_params

    @payment = payment
    respond_with @payment

  end

  def show
    flash[:notice] = "Payment received. Thanks!"
    redirect_to root_path
  end

  private

  def payment_params
    params.require(:payment).permit :from, :amount, :note, :card_token
  end

end
