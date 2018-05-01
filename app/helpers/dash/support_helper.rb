module Dash::SupportHelper

  # an array of help scout page ids
  def article_suggestions(suggestions=[])
    @helpscout_suggestions = suggestions
  end

  def helpscout_beacon
    beacon_config = %Q{{
      docs:{enabled:!0,baseUrl:"#{Rails.application.credentials.dig(:helpscout, :beacon_url)}"},
      contact:{enabled:!0,formId:"#{Rails.application.credentials.dig(:helpscout, :form_id)}"}
    }}
    beacon_custom_config = %Q{HS.beacon.config({topArticles: true,poweredBy: false, topics: [{val: "help", label: "Help"}, {val: "feature-request", label: "Feature request"}, {val: "bug", label: "Report a bug"}]});}
    beacon_base_js = %Q{!function(e,o,n){window.HSCW=o,window.HS=n,n.beacon=n.beacon||{};var t=n.beacon;t.userConfig={},t.readyQueue=[],t.config=function(e){this.userConfig=e},t.ready=function(e){this.readyQueue.push(e)},o.config=#{beacon_config};var r=e.getElementsByTagName("script")[0],c=e.createElement("script");c.type="text/javascript",c.async=!0,c.src="https://djtflbt20bdde.cloudfront.net/",r.parentNode.insertBefore(c,r)}(document,window.HSCW||{},window.HS||{});}
    beacon_options = []
    beacon_options << %Q{HS.beacon.prefill({subject: "#{Rails.application.credentials.dig(:helpscout, :contact_form_subject}"});}
    if @current_user
      beacon_options << %Q{HS.beacon.identify({name: "#{@current_user.name}", email: "#{@current_user.email}"});}
    end
    if @helpscout_suggestions
      beacon_options << %Q{HS.beacon.suggest(#{@helpscout_suggestions.to_json});}
    end
    beacon_options_js = %Q{HS.beacon.ready(function() {#{beacon_options.join("")}});}
    js = (beacon_base_js + beacon_custom_config + beacon_options_js).html_safe
    javascript_tag(js, nonce: true)
  end

end