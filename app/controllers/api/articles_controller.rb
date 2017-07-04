#class Api::ArticlesController < Api::BaseController
class Api::ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy,:upload_avatar]
  before_action :increase_article_view, only: [:show]
  before_action :doorkeeper_authorize!,except:[:userList]
  before_action :profile_authorize!,except:[:create,:destroy,:update,:upload_avatar,:userList]
  before_action :admin_authorize!, only:[:create,:destroy,:update,:upload_avatar]
  # GET /articles
  # GET /articles.json

  def userList
    arr=[]
    arr.push(name: "Hussein")
    arr.push(name:"ojhaghi")
    arr.push(name: "jafari")
    render json: arr, status:200
  end  

  def index

    if params[:page] and params[:per_page]
      if params[:visit]
        @articles = Article.where(add_category_tables_id: params[:cat_id]).page(params[:page]).per(params[:per_page]).order(:visit)
        render json:@articles, status:200
        return
      elsif params[:popular]
        @articles = Article.where(add_category_tables_id: params[:cat_id]).page(params[:page]).per(params[:per_page]).order(:popular)
        render json:@articles, status:200
        return
      else
        @articles = Article.where(add_category_tables_id: params[:cat_id]).page(params[:page]).per(params[:per_page]).order(:updated_at)
        render json:@articles, status:200
      end
    else
      if not params[:visit].nil?
        @articles = Article.all.order(visit: :desc)
        render json:@articles, status:200
        return
      elsif not params[:popular].nil?
        @articles = Article.all.order(popular: :desc)
        render json:@articles, status:200
        return
      else
        @articles = Article.all.order(updated_at: :desc)
        render json:@articles, status:200
      end
    end

  end
  def search
    query=params[:query]
    if query.nil?
       render json:{message:"please specify query message"},status:400
       return
    end
    if not params[:category].nil?
      if params[:order]=="desc"
        @query=Article.where("title like ? OR description like ?OR add_category_tables_id = ?","%#{query}%","%#{query}%",params[:category]).order(updated_at: :desc)
        render json:{result:@query},status:200
      else
        @query=Article.where("title like ? OR description like ? OR add_category_tables_id = ?","%#{query}%","%#{query}%",params[:category])
        render json:{result:@query},status:200
      end
    else
      if params[:order]=="desc"
        @query=Article.where("title like ? OR description like ?","%#{query}%","%#{query}%").order(updated_at: :desc)
        render json:{result:@query},status:200
      else
        @query=Article.where("title like ? OR description like ?","%#{query}%","%#{query}%")
        render json:{result:@query},status:200
      end
    end
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
    if @article.nil?
      render json:{message:"we don't have such an article"},status:200
      return
    end
    render json:@article,status:200
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # POST /articles
  # POST /articles.json
  def create
    if params[:add_category_tables_id].nil?
      render json:{message:"please specify the category"},status:400
      return
    end
    @article = Article.new(article_params)
    if @article.save
      render json: @article, status:200
    else
      render json: @article.errors, status:400
    end

  end
  # PATCH/PUT /api/upload_avatar
  def upload_avatar
    image_params = params.permit(:image,:id)
    if image_params[:image].nil?
      render json: { message: "image string is empty" }, status: 400
      return
    else
      content_type, encoding, string = image_params[:image].split(/[:\;\,]/)[1..3]
    end
    if image_params[:id].nil?
      render json:{message:"please specify article id"},status:200
      return
    end
    if image_params[:image] and (content_type.nil? or encoding.nil? or string.nil?)
      render json: { message: 'image string is invalid. valid example "data:image/png;base64,BASE64"'},
             status: 400
    else

      if @article.nil?
        render json:{message:"we don't have such an article"},status:200
        return
      end
      if @article.update(image_params)
        render json: { avatar_url: @article.image.url }
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end
  end
  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
      if @article.update(article_params)
         render json: @article, status: 200
      else
        render json: @article.errors, status: 400
      end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    if @article.nil?
      render json:{message: "can't find article"},status:400
    else
    @article.destroy
    render json:@article,status:200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.permit(:title, :description,:add_category_tables_id)
    end
    def increase_article_view
      @article=Article.find(params[:id])
      @article.visit +=1
      @article.save
    end
end
