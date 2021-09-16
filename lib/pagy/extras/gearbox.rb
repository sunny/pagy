# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/gearbox
# frozen_string_literal: true

class Pagy
  VARS[:gearbox_extra] = true # extra enabled by default
  VARS[:gearbox_items] = [15, 30, 60, 100]
  # Automatically change the number of items depending on the page number
  # accepts an array as the :gearbox_items variable, that will determine the items for the first pages
  module GearboxExtra
    # setup @items based on the :items variable
    def setup_items_var
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      gearbox_items = @vars[:gearbox_items]
      raise VariableError.new(self), "expected :items to be an Array of positives; got #{gearbox_items.inspect}" \
            unless gearbox_items.is_a?(Array) && gearbox_items.all? { |num| num.positive? rescue false } # rubocop:disable Style/RescueModifier

      @items = gearbox_items[@page - 1] || gearbox_items.last
    end

    # setup @pages and @last based on the :items variable
    def setup_pages_var
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      gearbox_items = @vars[:gearbox_items]
      # this algorithm is thousands of times faster than the one in the geared_pagination gem
      @pages = @last = (if @count > (sum = gearbox_items.sum)
                          [((@count - sum).to_f / gearbox_items.last).ceil, 1].max + gearbox_items.count
                        else
                          pages    = 0
                          reminder = @count
                          while reminder.positive?
                            pages    += 1
                            reminder -= gearbox_items[pages - 1]
                          end
                          [pages, 1].max
                        end)
    end
  end
  prepend GearboxExtra
end
