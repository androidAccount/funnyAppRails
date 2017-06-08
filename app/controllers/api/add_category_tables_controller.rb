class Api::AddCategoryTablesController < ApplicationController
  before_action :set_add_category_table, only: [:show, :edit, :update, :destroy]
  before_action :doorkeeper_authorize!,except:[:index]
  before_action :admin_authorize!
  # GET /add_category_tables
  # GET /add_category_tables.json
  def index
    @add_category_tables = AddCategoryTable.all
    render json:@add_category_tables , status:200
  end
  # GET /add_category_tables/1
  # GET /add_category_tables/1.json
  def show
    render json:@add_category_tables,status:200
  end

  # GET /add_category_tables/new
  def new
    @add_category_table = AddCategoryTable.new
  end

  # GET /add_category_tables/1/edit
  def edit
  end

  # POST /add_category_tables
  # POST /add_category_tables.json
  def create
    @add_category_table = AddCategoryTable.new(add_category_params)
      if @add_category_table.save
        render json:@add_category_table,status:200
      else
        render json: @add_category_table.errors
      end
  end

  # PATCH/PUT /add_category_tables/1
  # PATCH/PUT /add_category_tables/1.json
  def update
      if @add_category_table.update(add_category_params)
        render json: @add_category_table,status:200
      else
        render json: @add_category_table.errors, status:400
      end
  end

  # DELETE /add_category_tables/1
  # DELETE /add_category_tables/1.json
  def destroy
    if @add_category_table.destroy
      render json:@add_category_table,status:200
    else
      render json:@add_category_table.errors,status:400
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_add_category_table
      @add_category_table = AddCategoryTable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def add_category_params
      params.permit(:cat_title)
    end
end
