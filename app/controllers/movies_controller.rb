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
    if session[:sort] == 'title'
      @title_hilite = "hilite"
    elsif session[:sort] == "release date"
      @release_hilite = "hilite"
    end

    if params.key?("ratings")
      session[:ratings] = params[:ratings]
      @possible = params[:ratings].keys
    else
      if session.key?("ratings")
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings], :sort => params[:sort])
        return
      else
        @possible = @all_ratings
      end
    end

    if params[:sort] == 'release date'
      @movies = Movie.where(:rating => @possible).order(:release_date)
      @release_hilite = 'hilite'
      @title_hilite = nil
      session[:release_hilite] = @release_hilite
      session[:sort] = 'release date'

    elsif params[:sort] == 'title'
      @movies = Movie.where(:rating => @possible).order(:title)
      @title_hilite = 'hilite'
      @release_hilite = nil
      session[:sort] = 'title'
    else
      if session[:sort]
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
        return
      end
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
end
