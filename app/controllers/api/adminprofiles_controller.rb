class Api::AdminprofilesController < ApplicationController
  before_action :set_adminprofile, only: [:show, :edit, :update, :destroy]
  before_action :doorkeeper_authorize!
  before_action :admin_authorize!
  # GET /adminprofiles
  # GET /adminprofiles.json
  def index
    @adminprofiles = Adminprofile.all
  end

  # GET /adminprofiles/1
  # GET /adminprofiles/1.json
  def show
  end

  # GET /adminprofiles/new
  def new
    @adminprofile = Adminprofile.new
  end

  # GET /adminprofiles/1/edit
  def edit
  end

  # POST /adminprofiles
  # POST /adminprofiles.json
  def create
    @adminprofile = Adminprofile.new(adminprofile_params)

    respond_to do |format|
      if @adminprofile.save
        format.html { redirect_to @adminprofile, notice: 'Adminprofile was successfully created.' }
        format.json { render :show, status: :created, location: @adminprofile }
      else
        format.html { render :new }
        format.json { render json: @adminprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adminprofiles/1
  # PATCH/PUT /adminprofiles/1.json
  def update
    respond_to do |format|
      if @adminprofile.update(adminprofile_params)
        format.html { redirect_to @adminprofile, notice: 'Adminprofile was successfully updated.' }
        format.json { render :show, status: :ok, location: @adminprofile }
      else
        format.html { render :edit }
        format.json { render json: @adminprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adminprofiles/1
  # DELETE /adminprofiles/1.json
  def destroy
    @adminprofile.destroy
    respond_to do |format|
      format.html { redirect_to adminprofiles_url, notice: 'Adminprofile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adminprofile
      @adminprofile = Adminprofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adminprofile_params
      params.fetch(:adminprofile, {})
    end
end
