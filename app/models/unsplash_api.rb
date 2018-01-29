class UnsplashApi

  def self.search(term, options={})
    options.reverse_merge!(
      page: 1,
      per_page: 20,
      query: term
    )
    get "/search/photos", options
  end

  def self.photo(id)
    get "/photos/#{id}"
  end

  def self.download(id)
    get "/photos/#{id}/download"
  end

  private

  def self.connection
    @connection ||= Faraday.new(
      url: "https://api.unsplash.com",
      headers: {
        "Content-Type" => "application/json",
        "Accept-Version" => "v1",
        "Authorization" => "Client-ID #{Rails.application.secrets.unsplash_app_id}"
      }
    )
  end

  def self.get(path, params={})
    response = connection.get path, params

    status_code = response.respond_to?(:status) ? response.status : response.code

    if !(200..299).include?(status_code)
      body = JSON.parse(response.body)
      msg = body["error"] || body["errors"].join(" ")
      Rails.logger.debug "Unsplash API request failed: #{response.status} code - #{response.body}"
      raise StandardError.new msg
    end
    JSON.parse(response.body)
  end

end