Rails.application.routes.draw do
  get "*all" => "application#cors_preflight_check", :constraints => { :method => "OPTIONS" }
  namespace 'api' do
    namespace 'v1' do
      resources :room
    end
  end

  namespace 'api' do
    namespace 'v1' do
      resources :vertex
    end
  end

  namespace 'api' do
    namespace 'v1' do
      resources :user
    end
  end

  namespace 'api' do
    namespace 'v1' do
      resources :inventory
    end
  end

end
