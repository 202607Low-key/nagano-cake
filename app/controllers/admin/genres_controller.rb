module Admin
  class GenresController < ApplicationController
    def index
      @genres = Genre.all
      @genre = Genre.new
    end

    def create
      @genre = Genre.new(genre_params)
      if @genre.save
        redirect_to admin_genres_path, notice: "ジャンルを登録しました"
      else
        @genres = Genre.all
        render :index, status: :unprocessable_entity
      end
    end

    def edit
      @genre = Genre.find(params[:id])
    end

    def update
      @genre = Genre.find(params[:id])
      if @genre.update(genre_params)
        redirect_to admin_genres_path, notice: "ジャンルを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def genre_params
      params.require(:genre).permit(:name)
    end
  end
end