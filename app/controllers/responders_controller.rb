class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :edit, :update, :destroy]

  # GET /responders
  # GET /responders.json
  def index
    if params[:show] == 'capacity'
      render :capacities, status: :ok
    else
      @responders = Responder.all
      render :index, status: :ok
    end
  end

  # GET /responders/1
  # GET /responders/1.json
  def show
    render :show, status: :ok, location: @responder
  end

  # GET /responders/new
  def new
    @responder = Responder.new
  end

  # GET /responders/1/edit
  def edit
  end

  # POST /responders
  # POST /responders.json
  def create
    @responder = Responder.new(create_responder_params)
    if @responder.save
      render :show, status: :created, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /responders/1
  # PATCH/PUT /responders/1.json
  def update
    if @responder.update(update_responder_params)
      render :show, status: :ok, location: @responder
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /responders/1
  # DELETE /responders/1.json
  def destroy
    @responder.try(:destroy)
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_responder
    @responder = Responder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
