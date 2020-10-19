module Spree
  module Admin
    class DeliveriesController < ResourceController
      include Spree::Admin::DeliveryHelper

      def start
        # assign driver
        # change state
        # redirect to show
        unless @delivery.pending?
          flash[:error] = Spree.t(:delivery_taken_or_finished)
          return redirect_back fallback_location: admin_deliveries_path
        end

        ActiveRecord::Base.transaction do
          @delivery.update!(user_id: try_spree_current_user&.id)
          if @delivery.start
            flash[:success] = Spree.t(:delivery_started)
            redirect_to admin_delivery_path(@delivery)
          else
            flash[:error] = @delivery.errors.full_messages.join(', ')
            redirect_back fallback_location: admin_deliveries_path
          end
        end
      end

      def finish
        # change state
        # redirect back
        if @delivery.finish
          flash[:success] = Spree.t(:delivery_finished)
        else
          flash[:error] = @delivery.errors.full_messages.join(', ')
        end
        redirect_back fallback_location: admin_deliveries_path
      end

      private

      def model_class
        Spree::Delivery
      end

      def permitted_resource_params
        params.require(:delivery).permit(permitted_delivery_params)
      end

      def permitted_delivery_params
        %i[state user_id shipment_id]
      end
    end
  end
end
