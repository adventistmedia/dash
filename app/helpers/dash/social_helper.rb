module Dash::SocialHelper

  def social_icon(platform)
    case platform.to_s
    when "website"
      "share-alt"
    when "youtube"
      "youtube-play"
    else
      platform
    end
  end
end