FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_delivery/factories'

  factory :delivery, class: Spree::Delivery do
    shipment

    trait :with_driver do
      driver
    end
  end

  factory :driver, parent: :user do
    spree_roles { [Spree::Role.find_by(name: 'delivery') || create(:role, name: 'delivery')] }
  end
end
