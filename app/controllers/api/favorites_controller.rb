class Api::FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :edit, :update, :destroy]

  before_action :doorkeeper_authorize!
  before_action :profile_authorize!
  # GET /favorites
  # GET /favorites.json
  def index
    @favorites = Favorite.all
    if @favorites.nil?
      render json:{message:"favorite is empty"},status:400
    else
      render json:@favorites, status:200
    end
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
    if @favorite.nil?
      render json:{message:"can't find favorite"},status:400
    else
      render json:@favorite,status:200
    end
  end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @article=Article.find(params[:article_id])
    if @article.nil?
      render json:{message:"we don't have such an article"},status:400
    end
    @favorite =Favorite.find_by(user_id:current_resource_owner.id, article_id: params[:article_id])

     if not @favorite.nil?
       render json:{message:"Can't add to favorite"},status:400
       return
     end

    @favorite = Favorite.new(favorite_params)
    @favorite.user_id=current_resource_owner.id
    @article.popular +=1

    if @favorite.save
      if not @article.save
        render json:{message:"an error happened while updating article popularity"},status:400
        return
      end
      render json: @favorite , status:200
    else
      render json: @favorite.errors , status:400
    end
  end

  # PATCH/PUT /favorites/1
  # PATCH/PUT /favorites/1.json
  def update
    render json:{message:"no need to update"},status:200
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    if @favorite.destroy
      render json:{message:"deleted well"},status:200
    else
      render json:{message:"no need to delete"},status:400
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.permit(:article_id, :user_id)
    end
end
