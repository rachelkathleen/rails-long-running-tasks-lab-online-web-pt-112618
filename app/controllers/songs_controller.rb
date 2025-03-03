class SongsController < ApplicationController

  require 'csv'

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
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

  def upload
    CSV.foreach(params[:file].path, headers: true) do |song|
      artist = Artist.find_or_create_by(name: song[1])
      Song.create(title: song[0], artist_id: artist.id)
    end
    redirect_to songs_path
  end
  # Song Clean,ARTIST CLEAN,Release Year,COMBINED,First?,Year?,PlayCount,F*G
  # Caught Up in You,.38 Special,1982,Caught Up in You by .38 Special,1,1,82,82

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end
