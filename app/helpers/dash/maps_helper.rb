module Dash::MapsHelper

  def add_map(callback = "mapInitialize")
    content_for(:map_js) do
      javascript_tag do
        %Q{if(googleMapLoadCount == 0){
        $.getScript("//maps.googleapis.com/maps/api/js?callback=#{callback}&key=#{Rails.application.secrets.google_browser_key}&language=#{I18n.locale}", function(){});
        googleMapLoadCount = 1;}else{#{callback}();}}.html_safe
      end
    end
  end

end