class ArtistsController < ApplicationController
  before_action :set_preferences, only: [:index, :new]

  def index
    @artists = sort_artists(Artist.all, @preferences)
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    if @preferences.allow_create_artists
      @artist = Artist.new
    else
      redirect_to artists_path
    end
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :new
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])

    @artist.update(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    flash[:notice] = "Artist deleted."
    redirect_to artists_path
  end

  private

  def artist_params
    params.require(:artist).permit(:name)
  end
  
  def set_preferences
    @preferences = Preference.first
  end
  
  def sort_artists(artists, preferences)
    if preferences
      sort_order = preferences.artist_sort_order
    
      if sort_order == "ASC"
        artists.sort_by(&:name)
      else
        artists.sort_by(&:name).reverse
      end
    else
      artists
    end
  end
end
