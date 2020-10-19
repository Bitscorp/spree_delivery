module Spree
  class Delivery < Spree::Base
    belongs_to :driver, class_name: Spree.user_class.to_s, foreign_key: :user_id
    belongs_to :shipment, class_name: 'Spree::Shipment'
    has_many :state_changes, as: :stateful, class_name: 'Spree::StateChange', dependent: :destroy

    validates :shipment, presence: true
    validate :order_is_shipped
    validate :driver_role_is_delivery, if: :driver_present?

    scope :with_state, ->(*s) { where(state: s) }
    scope :pending, -> { with_state(:pending) }
    scope :in_progress, -> { with_state(:in_progress) }
    scope :ready_for_taking, -> { with_state(:pending).where(user_id: nil) }
    scope :finished, -> { with_state(:finished) }

    # delivery state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
    state_machine initial: :pending, use_transactions: false do
      event :start do
        transition from: :pending, to: :in_progress
      end
      after_transition to: :in_progress, do: :send_shipped_email

      event :pend do
        transition from: :in_progress, to: :pending
      end

      event :finish do
        transition from: :in_progress, to: :finished
      end

      after_transition do |delivery, transition|
        delivery.state_changes.create!(
          previous_state: transition.from,
          next_state: transition.to,
          name: 'delivery',
          user_id: delivery.user_id
        )
      end
    end

    private

    def driver_present?
      driver.present?
    end

    def order_is_shipped
      return if shipment.order.shipped?

      errors.add(:base, :order_not_shipped)
    end

    def driver_role_is_delivery
      return if driver.respond_to?(:has_spree_role?) && driver.has_spree_role?('delivery')

      errors.add(:driver, :wrong_role)
    end

    def send_shipped_email
      ShipmentMailer.shipped_email(shipment.id).deliver_later
    end
  end
end
