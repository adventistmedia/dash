class URLValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if options[:hostname]
      record.errors.add attribute, "must include #{options[:hostname]}" unless value.include?(options[:hostname])
    end
    record.errors.add attribute, 'must be a valid url' unless url_valid?(value)
  end

  private

  def url_valid?(url)
    re = /(\A\z)|(\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[:a-z]{2,5}(([0-9]{1,5})?\/.*)?\z)/ix
    url =~ re
  end

end