Deface::Override.new(
  virtual_path:  'spree/admin/shared/_main_menu',
  name:          'delivery_main_menu_tabs',
  insert_bottom: 'nav',
  text:       <<-HTML
    <% if can? :admin, Spree::Delivery %>
      <ul class="nav nav-sidebar border-bottom">
        <%= tab :deliveries, icon: 'shopping-cart' %>
      </ul>
    <% end %>
HTML
)