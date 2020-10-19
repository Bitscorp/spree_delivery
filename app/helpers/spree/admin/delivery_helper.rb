module Spree
  module Admin
    module DeliveryHelper
      include ActionView::Helpers::UrlHelper

      def self.included(base)
        base.send :helper_method, :link_to_map
      end

      def link_to_map(address)
        base = "https://www.google.com/maps/dir/?api=1&dir_action=navigate&destination="
        url = base + CGI.escape(address)
        link_to(address, url, target: :blank)
      end
    end
  end
end