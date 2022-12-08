class Transaction < ApplicationRecord
  belongs_to :user

  validates :requested_money, presence: true, length: {maximum: 6000}  
end
