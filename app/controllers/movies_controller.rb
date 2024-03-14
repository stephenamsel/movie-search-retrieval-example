class MoviesController < ApplicationController
  # before_action :set_movie, only: %i[ show update destroy ]

  # GET /movies
  def index
    unless params[:query].present?
      render json: [], status: 422
      return
    end
    
    credentials = JSON.parse(ENV['MOVIEDB'])
    db_url = credentials['url']
    db_params = { api_key: credentials['api_key'], query: params[:query] }
    
    db_response = Faraday.get(db_url, db_params)
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
        date: m['release_date']
      }
    end
    render json: movies
  end
end