class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :company_id
      t.string :email
      t.boolean :is_professional
      t.string :address
      t.string :zip_code
      t.string :country
      t.string :phone_number
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
