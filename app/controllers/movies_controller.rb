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
    # if there is a sort param
    if(!params.has_key?(:sort))
      # if there is a session, reload
      if(session.has_key?(:sort))
        redirect_to movies_path(:sort=>session[:sort])
      end
    end
    # set the sort session
    @sort = params.has_key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
    
    @all_ratings = Movie.all_ratings.keys
    @ratings = params[:ratings]
    
    if(@ratings != nil)
      ratings = @ratings.keys
      session[:ratings] = @ratings
    else
      if(!params.has_key?(:commit) && !params.has_key?(:sort))
        ratings = Movie.all_ratings.keys
        session[:ratings] = Movie.all_ratings
      else
        ratings = session[:ratings].keys
      end
    end
    
    # order the movies
    @movies = Movie.order(session[:sort])
    
    # update the checked
    @check = ratings
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
