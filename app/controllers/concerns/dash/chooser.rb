module Dash::Chooser
  extend ActiveSupport::Concern

  included do
    layout "dashboard_lightbox"
    authorize_resource class: false
    before_action :set_tabs, only: [:upload, :images, :stock_images]
    before_action :set_chooser_path
    before_action :find_asset, only: [:update, :destroy]
  end

  def update
    @success = @asset.update_attributes( asset_params )
    render template: "/dash/chooser/update"
  end

  def destroy
    @asset.destroy
    render template: "/dash/chooser/destroy"
  end

  # POST
  # recieve uploaded data to create asset
  def complete_upload
    @dom_id = "##{params[:photo][:dom_id]}"

    @asset = Asset.new(uploaded_asset_attributes.reverse_merge(uploaded_by: current_user))
    @asset.add_meta(params[:photo])
    @asset.save
    render template: "/dash/chooser/complete_upload"
  end

  # GET
  # Upload screen
  def upload
    render template: "/dash/chooser/upload"
  end

  # GET
  # Uploaded images accessible to user
  def images
    @assets = filtered_assets.page(params[:page]).order("created_at DESC").per(12)
    @assets = @assets.search(params[:q], fuzzy: true) if params[:q].present?
    return_assets
  end

  # GET
  # Stock images
  def stock_images
    @assets = Asset.stock.paginate(params).filter(params[:filter], filter: StockImageFilter).order("created_at DESC").per(12)
    @assets = @assets.search(params[:q], fuzzy: true) if params[:q].present?
    return_assets
  end

  private

  def filtered_assets
    Asset
  end

  def set_tabs
    tab_options = ["images", "upload"]
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

  def return_assets
    respond_to do |format|
      format.html do
        @assets_for_json = Asset.to_chooser_json(@assets)
        render template: "/dash/chooser/#{params[:action]}"
      end
      format.js do
        @assets_for_json = Asset.to_chooser_json(@assets)
        render template: "/dash/chooser/#{params[:action]}_search"
      end
    end
  end

  def uploaded_asset_attributes
    {}
  end

  def asset_params
    params.fetch(:asset, {}).permit(:name, :tags, :credit, :credit_url, :stock)
  end

  def set_chooser_path
    @chooser_path = "/dashboard/chooser"
  end

end
