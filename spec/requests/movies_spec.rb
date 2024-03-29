require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/movies", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Movie. As you add validations to Movie, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # MoviesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  let(:movie_parameters) { {:api_key=>"a99cc60fc2b34dbb18cb806b8a88ed14", :query=>"speed"}  }
  let(:movie_db_uri) { "https://api.themoviedb.org/3/search/movie?#{movie_parameters.to_query}" }
  let(:quiery_speed_uri) { "#{movies_url}?query=speed" }
  let(:movie_db_sample) {{
    "page"=>1,
    "results"=>[{"adult"=>false,
    "backdrop_path"=>"/pE1WR83KMP1wMzmqOLMUKUq8M6V.jpg",
    "genre_ids"=>[28, 12, 80],
    "id"=>1637,
    "original_language"=>"en",
    "original_title"=>"Speed",
    "overview"=>
     "Jack Traven, an LAPD cop on SWAT detail, and veteran SWAT officer Harry Temple thwart an extortionist-bomber's scheme for a $3 million ransom. As they corner the bomber, he flees and detonates a bomb vest, seemingly killing himself. Weeks later, Jack witnesses a mass transit city bus explode and nearby a pay phone rings. On the phone is that same bomber looking for vengeance and the money he's owed. He gives a personal challenge to Jack: a bomb is rigged on another city bus - if it slows down below 50 mph, it will explode - bad enough any day, but a nightmare in LA traffic. And that's just the beginning...",
    "popularity"=>72.55,
    "poster_path"=>"/o1Zs7VaS9y2GYH9CLeWxaVLWd3x.jpg",
    "release_date"=>"1994-06-09",
    "title"=>"Speed",
    "video"=>false,
    "vote_average"=>7.129,
    "vote_count"=>5823}]
  }}

  let(:expected_params) { { api_key: 'a99cc60fc2b34dbb18cb806b8a88ed14', query: 'speed' } }

  before(:each) do
    movie_db_sample_return = movie_db_sample.to_json
    WebMock.stub_request(:get, movie_db_uri).to_return(
      :status => 200, 
      :body => movie_db_sample_return, 
      :headers => {}
    )
  end

  describe "GET /index" do

    it "renders a 422 response with no query" do
      # Movie.create! valid_attributes
      get movies_url, headers: valid_headers, as: :json
      expect(response.status).to eq(422)
    end

    it "forwards requests to MovieDB" do
      # NOTE: passing a "params" argument passes Body parameters and converts the Request into a Post
      # There is no route corresponding to POST for this URI

      expect(Faraday).to receive(:get).with('https://api.themoviedb.org/3/search/movie', expected_params).and_call_original
      get quiery_speed_uri, headers: valid_headers, as: :json
    end

    it "returns the expected output" do
      get quiery_speed_uri, headers: valid_headers, as: :json
      response_data = JSON.parse(response.body)

      expect(response_data.length).to eq(1)
      sorted_keys = ['overview', 'popularity', 'release_date', 'title']
      expect(response_data.first.keys.sort).to eq(sorted_keys)
      sorted_keys.each do |key|
        expect(response_data.first[key]).to eq(movie_db_sample['results'].first[key])
      end
    end

    it 'caches results from the API call' do
      expect(Faraday).to receive(:get).
        with('https://api.themoviedb.org/3/search/movie', expected_params).
        once.and_call_original

      2.times do
        get quiery_speed_uri, headers: valid_headers, as: :json
      end
    end
  end
end
