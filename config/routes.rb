Rails.application.routes.draw do
  root to: proc { [ 200, {}, [ "GALLERY API" ] ] }
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users

  namespace :api do
    namespace :v1 do
      draw :users
      draw :profiles
    end
  end
end
