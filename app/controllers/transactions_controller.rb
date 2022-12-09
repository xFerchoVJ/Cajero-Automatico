class TransactionsController < ApplicationController
  before_action :authenticate_user!

  # GET /transactions/new
  def new
    return if @no_money_balance
    @possible_cash = [500, 200, 100, 50]
    @atm_money = TableAtm.find(1).money
    balance = @possible_cash.select { |n| n > current_user.balance }
    @no_money_balance = true if balance.size > 0
    @no_money = true if @atm_money == 0
    if balance.length > 1
      flash[:alert] = "No tienes efectivo suficiente"
    end
    @transaction = Transaction.new
  end

  # POST /transactions or /transactions.json
  def create
    @atm_money = TableAtm.find(1).money
    return if (params[:transaction][:requested_money].to_i > current_user.balance ) || (@atm_money < params[:transaction][:requested_money].to_i) || @no_money
    if params[:transaction][:requested_money].to_i > 6000
      flash[:alert] = "No se permite retirar cantidades mayores a 6000"
      return
    end
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id
    subtract_user_money()
    subtract_atm_money()
    respond_to do |format|
      if @transaction.save
        format.html {redirect_to new_transaction_path, notice: 'Created!'}
      else
        format.html { render :new, status: 403}
      end
    end
  end

  def subtract_atm_money
    substract = @atm_money - params[:transaction][:requested_money].to_i
    TableAtm.find(1).update(money: substract)
  end

  def subtract_user_money
    user_balance = current_user.balance
    requested_money = params[:transaction][:requested_money].to_i
    user_balance = user_balance - requested_money
    current_user.update(balance: user_balance)
  end

  private
    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:requested_money, :user_id)
    end
end
