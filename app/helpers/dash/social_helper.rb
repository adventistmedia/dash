module Dash::SocialHelper

  def social_icon(platform)
    case platform
    when "website"
      "share-alt"
    else
      platform
    end
  end
end