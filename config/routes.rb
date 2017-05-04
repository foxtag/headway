Headway::Engine.routes.draw do

  resources :requests do
    scope module: :requests do
      resources :queries, only: [] do
        member do
          put :explain
        end
      end
    end
  end

end
