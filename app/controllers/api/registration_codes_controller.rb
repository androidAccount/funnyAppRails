class Api::RegistrationCodesController < ApplicationController
  before_action :set_registration_code, only: [:show, :edit, :update, :destroy]

  # GET /registration_codes
  # GET /registration_codes.json
  def index
    @registration_codes = RegistrationCode.all
  end

  # GET /registration_codes/1
  # GET /registration_codes/1.json
  def show
  end

  # GET /registration_codes/new
  def new
    @registration_code = RegistrationCode.new
  end

  # GET /registration_codes/1/edit
  def edit
  end

  # POST /registration_codes
  # POST /registration_codes.json
  def create
    @registration_code = RegistrationCode.new(registration_code_params)

    respond_to do |format|
      if @registration_code.save
        format.html { redirect_to @registration_code, notice: 'Registration code was successfully created.' }
        format.json { render :show, status: :created, location: @registration_code }
      else
        format.html { render :new }
        format.json { render json: @registration_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_codes/1
  # PATCH/PUT /registration_codes/1.json
  def update
    respond_to do |format|
      if @registration_code.update(registration_code_params)
        format.html { redirect_to @registration_code, notice: 'Registration code was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration_code }
      else
        format.html { render :edit }
        format.json { render json: @registration_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_codes/1
  # DELETE /registration_codes/1.json
  def destroy
    @registration_code.destroy
    respond_to do |format|
      format.html { redirect_to registration_codes_url, notice: 'Registration code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_code
      @registration_code = RegistrationCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_code_params
      params.fetch(:registration_code, {})
    end
end
