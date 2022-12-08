class AddBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :integer, default: 0
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
