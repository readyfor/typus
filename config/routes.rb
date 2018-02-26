Rails.application.routes.draw do

  routes_block = lambda do

    dashboard = Typus.subdomain ? "/dashboard" : "/admin/dashboard"

    get "/" => redirect(dashboard)
    get "dashboard" => "dashboard#index", :as => "dashboard_index"
    get "dashboard/:application" => "dashboard#show", :as => "dashboard"

    if Typus.authentication == :session
      resource :session, :only => [:new, :create], :controller => :session do
        delete :destroy, :as => "destroy"
      end

      resources :account, :only => [:new, :create, :show] do
        collection do
          get :forgot_password
          post :send_password
        end
      end
    end

    Typus.models.map(&:to_resource).each do |_resource|
      get "#{_resource}(.:format)", controller: _resource, action: 'index'
      %w(new edit show toggle position destroy).each do |_action|
        get "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
      end
      %w(new create update position bulk autocomplete toggle restore trash wipe).each do |_action|
        post "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
        patch "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
        delete "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
      end
      delete "#{_resource}/destroy/:id", controller: _resource, action: 'destroy'
    end

    Typus.resources.map(&:underscore).each do |_resource|
      get "#{_resource}(.:format)", controller: _resource, action: 'index'
      %w(edit show destroy).each do |_action|
        get "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
        post "#{_resource}(/#{_action}(/:id))(.:format)", controller: _resource, action: _action
      end
    end

  end

  if Typus.subdomain
    constraints :subdomain => Typus.subdomain do
      namespace :admin, :path => "", &routes_block
    end
  else
    scope "admin", {:module => :admin, :as => "admin"}, &routes_block
  end

end
