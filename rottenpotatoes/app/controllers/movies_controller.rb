class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def new
    if !session[:username]
      redirect_to root_url
      flash[:warning] = "Sign In With Facebook to Continue"
    end
    @title_name = params[:title]
    @desc = params[:overview]
    puts '================================================='
  end

  def create
    if !session[:username]
      redirect_to root_url
      flash[:warning] = "Sign In With Facebook to Continue"
    else
      @movie = Movie.create!(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
    
  end

  def edit
    if !session[:username]
      redirect_to root_url
      flash[:warning] = "Sign In With Facebook to Continue"
    end
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    if !session[:username]
      redirect_to root_url
      flash[:warning] = "Sign In With Facebook to Continue"
    else
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
    
  end

  def search_tmdb

    api_key = "45b8f2a24416e159871bef83285e8107"
    url = URI("https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{params[:search_terms]}&page=1")
    response = Net::HTTP.get_response(url)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      # puts "THIS ---------------------- #{data["results"]}"
      if data["results"] == []
        flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
        redirect_to movies_path   
      else
        @title_name = data["results"][0]["title"]
        @overview = data["results"][0]["overview"]

        @movies = {
          "title" => "#{@title_name}",
          "overview" => "#{@overview}"
        }
        redirect_to new_movie_path(@movies)        
      end

    end 
  end

end
