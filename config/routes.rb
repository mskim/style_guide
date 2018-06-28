Rails.application.routes.draw do

  resources :wire_stories
  resources :profiles
  resources :holidays
  resources :reporters
  resources :article_plans
  resources :reporter_groups
  resources :opinion_writers
  resources :heading_bg_images
  resources :stroke_styles do
    collection do
      get 'style_view'
      get 'style_update'
    end
    member do
      get 'download_pdf'
      get 'save_current'
    end

  end
  resources :graphic_requests
  resources :section_headings
  resources :heading_ad_images
  resources :ad_box_templates
  resources :page_plans do
    member do
      get 'select_template'
      get 'update_page'
    end
  end

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  devise_scope :user do
    authenticated :user do
      root :to => 'home#welcome'
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users

  resources :ad_boxes do
    member do
      patch 'upload_ad_image'
    end

  end
  resources :ad_images do
    collection do
      # get 'current'
      get 'place_all'
    end
  end

  resources :working_articles do
    member do
      get 'download_pdf'
      get 'to_markdown_para'
      patch 'upload_images'
      get 'zoom_preview'
      patch 'assign_reporter'
      get 'add_image'
      get 'extend_zero'
      get 'extend_one'
      get 'extend_two'
      get 'extend_three'
      get 'extend_four'
      get 'reduce_one'
      get 'reduce_two'
      get 'reduce_three'
      get 'reduce_four'
      get 'swap'
      get 'quote_auto'
      get 'quote_zero'
      get 'quote_one'
      get 'quote_two'
      get 'quote_three'
      get 'quote_four'
      get 'image_1x1'
      get 'image_2x2'
      get 'image_3x3'
      get 'image_4x4'
      get 'image_5x5'
      get 'image_auto'

    end
  end

  resources :issues do
    member do
      get 'update_plan'
      get 'current_plan'
      get 'images'
      patch 'upload_images'
      get 'ad_images'
      patch 'upload_ad_images'
      get 'clone_pages'
      get 'slide_show'
      get 'assign_reporter'
      get 'send_to_cms'

      get 'first_group'
      get 'second_group'
      get 'third_group'
      get 'fourth_group'
      get 'fifth_group'
      get 'sixth_group'
      get 'seventh_group'
      get 'eighth_group'
      get 'nineth_group'
      get 'ad_group'
      get 'save_story_xml'
      get 'download_story_xml'
      get 'save_preview_xml'
      get 'download_preview_xml'



    end
  end

  resources :pages do
    member do
      get 'download_pdf'
      get 'dropbox'
      get 'change_template'
      get 'regenerate_pdf'
      get 'save_current_as_default'
      get 'clone'
      get 'save_proof_reading_pdf'
      get 'send_pdf_to_printer'
    end

  end

  resources :page_headings do
    member do
      get 'download_pdf'
      patch 'upload_images'
    end
  end
  resources :image_templates do
    collection do
      get 'six'
      get 'seven'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
    end
  end

  resources :ads
  resources :sections do
    collection do
      get 'five'
      get 'six'
      get 'seven'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
      get 'regenerate_pdf'
    end
  end

  resources :images do
    collection do
      get 'current'
      get 'place_all'
    end
  end

  match 'news_layout_hello' => Api::NewsLayout, :via => :get
  match 'new_issue/:date' => Api::NewsLayout, :via => :get
  match 'issue_plan/:date' => Api::NewsLayout, :via => :get
  match 'api/v1/layout_article/:date/:page/:order' => Api::NewsLayout, :via => :post
  match 'refresh_page/:date/:page' => Api::NewsLayout, :via => :get

  get 'home/welcome'
  get 'home/help'

  resources :articles do
    collection do
      get 'one'
      get 'two'
      get 'three'
      get 'four'
      get 'five'
      get 'six'
      get 'seven'
    end
    member do
      get 'download_pdf'
      get 'fill'
      get 'add_image'
      get 'select_image'
      get 'add_personal_image'
      get 'add_quote'
    end
  end

  resources :publications do
    member do
      get 'download_pdf'
    end

  end
  resources :text_styles do
    collection do
      get 'style_view'
      get 'style_update'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
      get 'save_current'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#welcome'

end
