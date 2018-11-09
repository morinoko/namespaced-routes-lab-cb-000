class SongsController < ApplicationController
  before_action :set_preferences, only: [:index, :new]
  
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = sort_songs(@artist.songs, @preferences)
      end
    else
      @songs = sort_songs(Song.all, @preferences)
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if @preferences.allow_create_songs
      @song = Song.new
    else
      redirect_to songs_path
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end

  def set_preferences
    @preferences = Preference.first
  end

  def sort_songs(songs, preferences)
    if preferences
      sort_order = preferences.song_sort_order
    
      if sort_order == "ASC"
        songs.sort_by(&:title)
      else
        songs.sort_by(&:title).reverse
      end
    else
      songs
    end
  end
end
