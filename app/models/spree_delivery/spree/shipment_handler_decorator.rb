# frozen_string_literal: true

module SpreeDelivery
  module Spree
    module ShipmentHandlerDecorator
      def perform
        @shipment.inventory_units.each(&:ship!)
        @shipment.process_order_payments if ::Spree::Config[:auto_capture_on_dispatch]
        @shipment.touch :shipped_at
        update_order_shipment_state

        ::Spree::Delivery.create!(shipment: @shipment)
      end
    end
  end
end

if Spree::ShipmentHandler.included_modules.exclude?(SpreeDelivery::Spree::ShipmentHandlerDecorator)
  Spree::ShipmentHandler.prepend SpreeDelivery::Spree::ShipmentHandlerDecorator
end