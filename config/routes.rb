WorkReport::Application.routes.draw do
  root "pages#home"
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  get "/contact", to: "pages#contact", as: "contact"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"

  #get "reports", to: "pages#reports", as: "reports"
  #get "reports/:id", to: "pages#show_report", as: "report"
  get "reports/drafts", to: "reports#drafts", as: "reports_drafts"
  get "reports/dashboard", to: "reports#dashboard", as: "reports_dashboard"
  get "reports/month", to: "reports#month", as: "reports_month"
  post "reports/month", to: "reports#month", as: "reports_month_post"
  resources :reports
  devise_for :users

  namespace :admin do
    root "base#index"
    resources :users
    get "reports/drafts", to: "reports#drafts", as: "reports_drafts"
    get "reports/dashboard", to: "reports#dashboard", as: "reports_dashboard"
    resources :reports
  end

end
