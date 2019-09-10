module Dash::MapsHelper

  def add_map(callback = "mapInitialize")
    content_for(:map_js) do
      javascript_tag nonce: true do
        %Q{if(googleMapLoadCount == 0){
        $.getScript("https://maps.googleapis.com/maps/api/js?callback=#{callback}&key=#{Rails.application.credentials.dig(:google, :browser_key)}&language=#{I18n.locale}&libraries=places", function(){});
        googleMapLoadCount = 1;}else{#{callback}();}}.html_safe
      end
    end
  end

end
