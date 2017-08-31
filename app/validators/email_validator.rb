class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors.add attribute, 'must be a valid email' unless email_valid?(value)
  end

  protected

  def email_valid?(url)
    re = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    url =~ re
  end
end
