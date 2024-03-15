class MoviesController < ApplicationController

  # GET /movies
  def index
    unless params[:query].present?
      render json: [], status: 422
      return
    end
    
    credentials = JSON.parse(ENV['MOVIEDB'])
    db_url = credentials['url']
    db_params = { query: params[:query] }
    db_params = db_params.merge(page: params[:page]) if params[:page].present?
    auth_params = { api_key: credentials['api_key'] }
    cache_key = db_params.merge({MoviesController: :index}).to_json
    
    db_response = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Faraday.get(db_url, db_params.merge(auth_params))
    end
    response_data = JSON.parse(db_response.body)

    unless db_response.status == 200
      render json: response_data, status: db_response.status
      return
    end
  
    movies = response_data['results'].map do |m|
      {
        title: m['title'], 
        overview: m['overview'], 
        popularity: m['popularity'],
        release_date: m['release_date']
      }
    end
    render json: movies
  end
end