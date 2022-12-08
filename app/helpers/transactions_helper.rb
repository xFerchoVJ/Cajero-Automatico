module TransactionsHelper
  def delivered_money total, demonimations
    raw_data = demonimations.inject({}) do |hash, demonimation|
      hash[demonimation] = total.divmod(demonimation)
      total -= total.divmod(demonimation).first * demonimation
      hash
    end

    raw_data.map do |k, v|
      raw_data[k] = v.first
    end
    
    raw_data
  end
end
