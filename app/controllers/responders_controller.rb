class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :edit, :update, :destroy]

  # GET /responders
  # GET /responders.json
  def index
    @responders = Responder.all
    respond_to do |format|
      format.json {
        if params[:show] == "capacity"
          render "capacities"
        else 
          render "index"
        end
      }
    end
  end

  # GET /responders/1
  # GET /responders/1.json
  def show
    respond_to do |format|
      format.json { render :show, status: :ok, location: responder_url(@responder) }
    end
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

    respond_to do |format|
      if @responder.save
        format.json { render :show, status: :created, location: responder_url(@responder) }
      else
        format.json { render json: { message: @responder.errors }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responders/1
  # PATCH/PUT /responders/1.json
  def update
    respond_to do |format|
      if @responder.update(update_responder_params)
        format.json { render :show, status: :ok, location: responder_url(@responder) }
      else
        format.json { render json: { message: @responder.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responders/1
  # DELETE /responders/1.json
  def destroy
    @responder.try(:destroy)
    respond_to do |format|
      format.json { head :no_content }
    end
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
