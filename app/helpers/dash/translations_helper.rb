module Dash::TranslationsHelper

  def ldate(dt)
    dt ? l(dt) : ""
  end

  # t_enum(@user, :status)
  def t_enum(object, attr)
    object.class.human_attribute_name("#{attr}.#{object.send(attr)}")
  end

end