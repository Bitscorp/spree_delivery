module Spree
  class DeliveryAbility
    include CanCan::Ability

    def initialize(user)
      unless user.respond_to?(:has_spree_role?)
        return
      end

      if user.has_spree_role?('delivery')
        # Driver can see only deliveries that are not taken yet or taken by him.
        # Driver can start only deliveries that are not taken yet (pending).
        # Driver can finish only deliveries that are taken by him.
        can %i[read start], Spree::Delivery, state: 'pending', driver: nil

        # owned resource once the driver started
        can %i[read], Spree::Delivery, user_id: user.id
        can %i[read finish], Spree::Delivery, state: 'in_progress', user_id: user.id
      end

      if user.has_spree_role?('admin')
        can %i[admin manage start finish], Spree::Delivery
      end
    end
  end
end

::Spree::Ability.register_ability(Spree::DeliveryAbility)
