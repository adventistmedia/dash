class UnsplashApi

  def self.search(term, options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30,
      query: term,
      collections: options[:collection]
    )
    get "/search/photos", options
  end

  def self.all_photos(options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/photos_curated/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      results = get "/photos/curated", options
      {"results" => results, "total" => 1000}
    end
  end

  def self.collections(options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/user-collections/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      response = get "/users/adventistmedia/collections", options
    end
  end

  def self.collection_photos(collection_id, options={})
    options.reverse_merge!(
      page: 1,
      per_page: 30
    )
    Rails.cache.fetch("unsplash/user-collection/#{collection_id}/page-#{options[:page]}-#{options[:per_page]}", expires_in: 12.hours) do
      results = get "/collections/#{collection_id}/photos", options
      {"results" => results, "total" => 1000}
    end
  end

  def paginated(response)
    results = []
    response["results"].each do |result|
      url = result["urls"]["raw"]
      if url[/photo\-[a-zA-Z0-9\_\-\.]+/] # hack to get aroung issue with reserve urls
        s = UnsplashImage.new(external_id: result["id"], name: result["description"])
        s.media.add_photo(url)
        results << s
      end
    end
    Kaminari.paginate_array(results, total_count: response["total"]).page(options[:page]).per(options[:per_page])
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
    JSON.parse(response.body)
  end

end