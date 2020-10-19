# This migration comes from spree_delivery (originally 20200827160726)
class CreateSpreeDeliveries < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_deliveries do |t|
      t.string :state, default: :pending

      t.references :shipment
      t.references :user

      t.timestamps
    end
  end
end
