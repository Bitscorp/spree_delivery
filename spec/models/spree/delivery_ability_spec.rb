require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::Ability, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:ability) { Spree::Ability.new(user) }
  let(:token) { nil }

  after do
    Spree::Ability.abilities = Set.new
  end

  context 'for general resource' do
    let(:resource) { Object.new }

    context 'with admin user' do
      before { allow(user).to receive(:has_spree_role?).and_return(true) }

      it_behaves_like 'access granted'
      it_behaves_like 'index allowed'
    end

    context 'with customer' do
      it_behaves_like 'access denied'
      it_behaves_like 'no index allowed'
    end
  end

  context 'for admin protected resources' do
    let(:resource_shipment) { Spree::Shipment.new }
    let(:resource_product) { Spree::Product.new }
    let(:resource_user) { FactoryBot.create(:user) }
    let(:resource_order) { Spree::Order.new }
    let(:resource_delivery) { Spree::Delivery.new }

    context 'with admin user' do
      it 'is able to admin' do
        user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')

        expect(ability).to be_able_to :admin, resource_delivery
      end
    end

    context 'with delivery user' do
      it 'is able to admin on the order and shipment pages' do
        user.spree_roles << Spree::Role.find_or_create_by(name: 'delivery')

        Spree::Ability.register_ability(Spree::DeliveryAbility)

        expect(ability).not_to be_able_to :admin, resource_shipment
        expect(ability).not_to be_able_to :admin, resource_product
        expect(ability).not_to be_able_to :admin, resource_user
        expect(ability).not_to be_able_to :admin, resource_order

        expect(ability).to be_able_to :read, resource_delivery

        Spree::Ability.remove_ability(Spree::DeliveryAbility)
      end
    end
  end
end
