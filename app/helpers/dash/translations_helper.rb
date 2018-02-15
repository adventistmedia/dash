module Dash::TranslationsHelper

  def ldate(dt)
    dt ? l(dt) : ""
  end

end