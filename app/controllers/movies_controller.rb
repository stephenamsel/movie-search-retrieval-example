class MoviesController < ApplicationController
  # before_action :set_movie, only: %i[ show update destroy ]

  # GET /movies
  def index
    unless params[:query].present?
      render json: [], status: 422
      return
    end



    movie_sets = []
    ['MOVIEDB'].each do |source_name|

      body = get_from_source(source_name, convert_parameters_for(source_name, params[:query]))
      desired_data = convert_response_from(source_name, body)
      movie_sets.push(
        
      )
    end

    credentials = JSON.parse(ENV['MOVIEDB'])
    db_url = movie_db_credentials['url']
    db_params = { api_key: credentials['api_key'], query: params[:query] }
    db_response = Faraday.get(movie_db_url, movie_db_params)
    
    movie_sets.flatten(1).uniq

    base_url = "https://api.themoviedb.org/3/search/movie?api_key=a99cc60fc2b34dbb18cb806b8a88ed14"
    render json: @movies
  end

  def convert_parameters_for(source_name, query)
    case source_name
    when 'MOVIEDB'
      {query: query}
    else
      raise "invalid name of source for movie data"
    end
  end

  def convert_response_from(source_name, body)
    resp_data = JSON.parse(body).symbolize_keys

    case source_name

    when 'MOVIEDB'
    {title: resp_data[:], overview: }

    else

    end
  end

  def get_from_source(source_name, query_hash)
    credentials = JSON.parse(ENV[source_name])
    url = credentials['url']
    return [] unless query_hash.values.compact.present?
    faraday_params = { api_key: credentials['api_key'] }.merge(query_hash)
    return Faraday.get(url, faraday_params).body
  end

=begin
  # GET /movies/1
  def show
    render json: @movie
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render json: @movie, status: :created, location: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.fetch(:movie, {})
    end
end
=end