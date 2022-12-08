class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :validatable, password_length: 3..4

  validates :card_digits, presence: true, length: {maximum: 16}
  validates_length_of :balance, :maximum => 50000, :message => "Saldo sobresaliente en la cuenta..."
  has_many :transactions
  #Use this method to change de auth way
  def email_required?
    false
  end

  # use this instead of email_changed? for rails >= 5.1
  def will_save_change_to_email?
    false
  end
end
