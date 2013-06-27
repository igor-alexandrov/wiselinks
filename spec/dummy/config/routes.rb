Dummy::Application.routes.draw do
  root :to => 'application#index'

  get 'no-slash' => 'application#no_slash'
  get 'trailing-slash' => 'application#trailing_slash',
    :trailing_slash => true
end
