Rails.application.routes.draw do
  root :to => "feeds#index"
  get '/:name' => 'feeds#show', :format => 'rss'
end
