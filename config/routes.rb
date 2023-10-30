# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  resources :cars, only: %i[index show create destroy] do
    collection do
      get 'models', to: 'cars#car_models'
    end
  end
  resources :reservations, only: %i[index create destroy]
end
