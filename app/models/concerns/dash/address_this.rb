# define address
# addressable name: :street, type: :street
# geocoded_by :to_s, latitude: :lat, longitude: :lng
# addressable name: :postal, type, :postal
# addressable type: :street


# the following fields should be created on

module Dash::AddressThis
  extend ActiveSupport::Concern

  included do
    #before_validation :set_address
    #before_save :clear_address
  end

  module ClassMethods

    def addressable(options={})
      prepend_name = options[:name] ? "#{options[:name]}_" : ""

      define_method("#{prepend_name}address?") do
        send("#{prepend_name}country_code").present? && send("#{prepend_name}address_line1").present?
          # (send("#{prepend_name}address_line1").present? ||
          # send("#{prepend_name}city").present? ||
          # send("#{prepend_name}region").present?)
      end

      define_method("#{prepend_name}summary") do
        [
          (send("#{prepend_name}city").present? ? send("#{prepend_name}city") : send("#{prepend_name}region")),
          send("#{prepend_name}country")
        ].reject(&:blank?).join(", ")
      end

      # Clear all address fields if address_line1 empty
      define_method("clear_#{prepend_name}address") do
        if send("#{prepend_name}address_line1").blank?
          send("#{prepend_name}address_line2=", nil)
          send("#{prepend_name}city=", nil)
          send("#{prepend_name}region=", nil)
          send("#{prepend_name}postcode=", nil)
          send("#{prepend_name}country_code=", nil)
          send("#{prepend_name}country=", nil)
          send("#{prepend_name}address_full=", nil)
          if has_attribute?("#{prepend_name}lat")
            send("#{prepend_name}lat=", nil)
            send("#{prepend_name}lng=", nil)
          end
        end
      end

      define_method("#{prepend_name}worldly") do
        Worldly::Country[send("#{prepend_name}country_code")]
      end

      define_method("#{prepend_name}geocoded?") do
        has_attribute?("#{prepend_name}lat")
      end

      define_method("#{prepend_name}address_changed?") do
        send("saved_change_to_#{prepend_name}address_line1?") ||
        send("saved_change_to_#{prepend_name}address_line2?") ||
        send("saved_change_to_#{prepend_name}city?") ||
        send("saved_change_to_#{prepend_name}region?") ||
        send("saved_change_to_#{prepend_name}postcode?") ||
        send("saved_change_to_#{prepend_name}country_code?")
      end

      # 2. set address_full
      # set the full address
      define_method("set_#{prepend_name}address") do
        # 1. set the country_name or country_code
        if send("#{prepend_name}country_code").present? && (send("#{prepend_name}country").blank? || send("#{prepend_name}country_code_changed?"))
          send("#{prepend_name}country=", Worldly::Country[send("#{prepend_name}country_code")]&.name)
        end
        # if send("#{prepend_name}country").present? && (send("#{prepend_name}country_code").blank? || send("#{prepend_name}country_changed?"))
        #   send("#{prepend_name}country_code=", Worldly::Country[send("#{prepend_name}country_code")]&.name)
        # end
        if send("#{prepend_name}address_changed?")
          full_address = send("#{prepend_name}worldly").to_display({
            address1: send("#{prepend_name}address_line1"),
            address2: send("#{prepend_name}address_line2"),
            city: send("#{prepend_name}city"),
            region: send("#{prepend_name}region"),
            postcode: send("#{prepend_name}postcode")
          }).gsub("\n",", ")
          send("#{prepend_name}address_full=", full_address)
        end
      end

    end

  end

end