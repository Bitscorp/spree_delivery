# frozen_string_literal: true

module SpreeDelivery
  module Spree
    module AddressDecorator
      def to_delivery_address
        [address1, address2.presence, city].compact.join(', ')
      end
    end
  end
end

if Spree::Address.included_modules.exclude?(SpreeDelivery::Spree::AddressDecorator)
  Spree::Address.prepend SpreeDelivery::Spree::AddressDecorator
end