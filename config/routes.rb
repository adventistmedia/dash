Rails.application.routes.draw do

  get "/legal/terms", to: "dash/legal#terms", as: :terms_legal
  get "/legal/privacy", to: "dash/legal#privacy", as: :privacy_legal
  # get "support", to: redirect(""), as: :dashboard_support

  get "dashboard/404", to: "dashboard/errors#page_not_found"
  get "dashboard/500", to: "dashboard/errors#server_error"

  # Concerns
  # concern :about do
  #   get 'about', on: :member
  # end
  # concern :export do
  #   post 'export', on: :collection
  # end
  # concern :batch_update do
  #   post 'batch_update', on: :collection
  # end
  # concern :batch_destroy do
  #   post 'batch_destroy', on: :collection
  # end
end