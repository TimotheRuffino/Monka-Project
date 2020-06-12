class Quote < ApplicationRecord
  # Relations with other tables
  belongs_to :user
  belongs_to :customer
  has_many :join_goods_quotes_tables
  has_many :goods, through: :join_goods_quotes_tables

# Validations
#   validates :version_number,
#             presence: true

  validates :amount,
            presence: true

# validates :discount

# validates :sent

# validates :sending_counter

# validates :is_invoice

  def receipt
    Receipts::Receipt.new(
      id: id,
      subheading: "RECEIPT FOR CHARGE #%{id}",
      product: "GoRails",
      company: {
          name: "GoRails, LLC.",
          address: "123 Fake Street\nNew York City, NY 10012",
          email: "support@example.com",
          logo: Rails.root.join("app/assets/images/calculate_vert.png")
      },
      line_items: [
          ["Date",           created_at.to_s],
          ["Account Billed", "#{@user.first_name} (#{@user.email})"],
          ["Product",        "GoRails"],
          ["Amount",         "$#{amount / 100}.00"],
          ["Charged to",     "1234567890"],
          ["Transaction ID", uuid]
      ],
        )
  end
end

