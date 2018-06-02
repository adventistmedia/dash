module Dash::Chooser
  extend ActiveSupport::Concern

  included do
    layout "dashboard_lightbox"
    authorize_resource class: false
    before_action :set_tabs, only: [:upload_document, :upload_image, :images, :stock_images, :documents]
    before_action :set_chooser_path
    before_action :find_asset, only: [:edit, :update, :destroy]
  end

  def edit
    render template: "/dash/chooser/edit"
  end

  def update
    @success = @asset.update_attributes( asset_params )
    if params[:inline] == "1"
      render template: "/dash/chooser/update_inline"
    else
      render template: "/dash/chooser/update"
    end
  end

  def destroy
    @asset.destroy
    render template: "/dash/chooser/destroy"
  end

  # POST
  # recieve uploaded data to create asset
  def complete_upload_image
    @dom_id = "##{params[:photo][:dom_id]}"

    @asset = Image.new(uploaded_asset_attributes.reverse_merge(uploaded_by: current_user))
    @asset.add_meta(params[:photo])
    @asset.save
    render template: "/dash/chooser/complete_upload"
  end


  # POST
  # recieve uploaded data to create asset
  def complete_upload_document
    @dom_id = "##{params[:file][:dom_id]}"

    @asset = Document.new(uploaded_asset_attributes.reverse_merge(uploaded_by: current_user))
    key = @asset.add_meta(params[:file])
    if @asset.save
      @asset.update_columns(media: key)
    end
    render template: "/dash/chooser/complete_upload"
  end

  # GET
  # Upload document screen
  def upload_document
    render template: "/dash/chooser/upload_document"
  end

  # GET
  # Upload image screen
  def upload_image
    render template: "/dash/chooser/upload_image"
  end

  # GET
  # Uploaded documents accessible to user
  def documents
    @assets = filtered_assets.where(type: "Document").order("created_at DESC").paginate(params)
    @assets = @assets.search(params[:q], fuzzy: true) if params[:q].present?
    respond_to do |format|
      format.html do
        render template: "/dash/chooser/documents"
      end
      format.js do
        render template: "/dash/chooser/documents_search"
      end
    end
  end

  # GET
  # Uploaded images accessible to user
  def images
    @assets = filtered_assets.where(type: "Image").order("created_at DESC").paginate(params)
    @assets = @assets.search(params[:q], fuzzy: true) if params[:q].present?
    respond_to do |format|
      format.html do
        render template: "/dash/chooser/images"
      end
      format.js do
        render template: "/dash/chooser/images_search"
      end
    end
  end

  # GET
  # Stock images
  def stock_images
    options = {}
    options[:page] = params[:page] if params[:page].present?
    options[:collection] = params[:collection] if params[:collection].present?
    @assets = UnsplashImage.search(params[:q], options)
    @collections = UnsplashApi.collections
    render template: "/dash/chooser/stock_images"
  end

  # POST JSON
  def unsplash_download
    @asset = UnsplashImage.get_photo(params[:id], uploaded_asset_attributes)
    render json: @asset ? @asset.chooser_data : nil
  end

  private

  def filtered_assets
    Asset
  end

  def set_tabs
    tab_options = ["images", "documents", "upload_document", "upload_image"]
    if params[:tabs].present?
      @chooser_tabs = params[:tabs].split(",").reject{|t| !tab_options.include?(t) }
      cookies[:chooser_tabs] = @chooser_tabs
    else
      @chooser_tabs = cookies[:chooser_tabs]
    end
    @chooser_tabs ||= tab_options
  end

  def find_asset
    @asset = filtered_assets.find(params[:id])
  end

  def uploaded_asset_attributes
    {}
  end

  def asset_params
    params.fetch(:asset, {}).permit(:name, :summary, :tags, :credit,
      :credit_url, :stock, :published_on)
  end

  def set_chooser_path
    @chooser_path = "/dashboard/chooser"
  end

end
