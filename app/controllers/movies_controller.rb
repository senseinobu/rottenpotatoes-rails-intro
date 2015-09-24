class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    session[:ratings] = params[:ratings]|| session[:ratings]|| @all_ratings.collect{|rating| [rating, "1"]}.to_h
    if params[:sort] != session[:sort] || session[:ratings] != params[:ratings]
      session[:sort] = params[:sort] || session[:sort]
      flash.keep
      redirect_to :controller => "movies", :action=>"index", :sort=>session[:sort], :ratings=>session[:ratings]
    end
    @movies = Movie.where(rating: session[:ratings].keys)
    
    @checked = @all_ratings.collect{|rating| [rating, session[:ratings].keys.include?(rating)] }.to_h
    
    if session[:sort] == "title"
      @movies = @movies.sort { |x,y| x.title.downcase <=> y.title.downcase}
      @title_header = "hilite"
    elsif session[:sort] == "release_date"
      @movies = @movies.sort { |x,y| x.release_date <=> y.release_date}
      @release_date_header = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
