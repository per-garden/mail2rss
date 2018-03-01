Rails.application.routes.draw do
  root :to => "messages#index", :format => 'rss'
end
