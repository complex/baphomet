class CreatePayments < ActiveRecord::Migration

  def change
    create_table :payments do |table|
      table.string :from
      table.decimal :amount, precision: 8, scale: 2
      table.text :note
      table.string :card_token
      table.string :charge_token
      table.timestamps
    end
  end

end
