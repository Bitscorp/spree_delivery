# This migration comes from spree_delivery (originally 20200902161051)
class AddDeliveryRole < ActiveRecord::Migration[6.0]
  def up
    Spree::Role.where(name: 'delivery').first_or_create
  end

  def down
    Spree::Role.where(name: 'delivery').destroy
  end
end
