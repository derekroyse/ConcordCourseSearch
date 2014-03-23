SampleApp::Application.routes.draw do
  get "scraper/new"
  root 'static_pages#home'
  match '/startup', to: 'scraper#startup', via: 'get'
  match '/startup', to: 'scraper#startup', via: 'post'
  match '/search', to: 'scraper#search', via: 'get'
  match '/search', to: 'scraper#search', via: 'post'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
end
