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
    @all_ratings = Movie.get_ratings
    if params.key?("ratings")
      @possible = params[:ratings].keys
    else
      @possible = @all_ratings
    end

    if params[:sort] == 'release date'
      @movies = Movie.where(:rating => @possible).order(:release_date)
      @release_hilite = 'hilite'
      puts @release_hilite
    elsif params[:sort] == 'title'
      @movies = Movie.where(:rating => @possible).order(:title)
      @title_hilite = 'hilite'
    else
      @movies = Movie.where(:rating => @possible)
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
# put this inside index
  # def title_order
  #   @movies = Movie.all.order(:title)
  #   render "index"
  # end
  
  # def release_order
  #   @movies = Movie.all.order(:release_date)
  #   render "index"
  # end
  
end
