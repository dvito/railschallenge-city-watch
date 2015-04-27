class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update, :destroy]
  # GET /emergencies
  # GET /emergencies.json
  def index
    @emergencies = Emergency.all
  end

  # GET /emergencies/1
  # GET /emergencies/1.json
  def show
    render :show, status: :ok, location: @emergency
  end

  # GET /emergencies/new
  def new
    @emergency = Emergency.new
  end

  # GET /emergencies/1/edit
  def edit
  end

  # POST /emergencies
  # POST /emergencies.json
  def create
    @emergency = Emergency.new(create_emergency_params)
    if @emergency.save
      render :show, status: :created, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emergencies/1
  # PATCH/PUT /emergencies/1.json
  def update
    if @emergency.update(update_emergency_params)
      render :show, status: :ok, location: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @emergency.destroy
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:id])
    fail ActiveRecord::RecordNotFound unless @emergency
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def update_emergency_params
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end
end
