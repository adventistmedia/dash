class UnsplashApi

  def self.search(term, options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30,
      query: term,
      collections: options[:collection]
    )
    results = get("/search/photos", options)
    results["body"]
  end

  def self.all_photos(options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/photos_curated/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      results = get "/photos/curated", options
      {"results" => results["body"], "total" => results["headers"]["x-total"].to_i}
    end
  end

  def self.collections(options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/user-collections/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      results = get "/users/adventistmedia/collections", options
      results["body"]
    end
  end

  def self.collection_photos(collection_id, options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/user-collection/#{collection_id}/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      results = get "/collections/#{collection_id}/photos", options
      {"results" => results["body"], "total" => results["headers"]["x-total"].to_i}
    end
  end

  def self.photo(id)
    results = get "/photos/#{id}"
    results["body"]
  end

  def self.download(id)
    results = get "/photos/#{id}/download"
    results["body"]
  end

  private

  def self.connection
    @connection ||= Faraday.new(
      url: "https://api.unsplash.com",
      headers: {
        "Content-Type" => "application/json",
        "Accept-Version" => "v1",
        "Authorization" => "Client-ID #{Rails.application.credentials.dig(:unsplash, :app_id)}"
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
    {"body" => JSON.parse(response.body), "headers" => response.headers}
  end

end