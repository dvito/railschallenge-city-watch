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
      if @responder
        format.json { render :show, status: :ok, location: responder_url(id: @responder.id) }
      else
        format.json { render file: "#{Rails.root}/public/404.json", status: :not_found}
      end
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
    begin
      @responder = Responder.new(create_responder_params)

      respond_to do |format|
        if @responder.save
          format.json { render :show, status: :created, location: responder_url(id: @responder.id) }
        else
          format.json { render json: { message: @responder.errors }, status: :unprocessable_entity }
        end
      end
    rescue ActionController::UnpermittedParameters => e
      respond_to do |format|
        format.json { render json: { message: e.message }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responders/1
  # PATCH/PUT /responders/1.json
  def update
    begin
      respond_to do |format|
        if @responder.update(update_responder_params)
          format.json { render :show, status: :ok, location: responder_url(id: @responder.id) }
        else
          format.json { render json: { message: @responder.errors }, status: :unprocessable_entity }
        end
      end
    rescue ActionController::UnpermittedParameters => e
      respond_to do |format|
        format.json { render json: { message: e.message }, status: :unprocessable_entity }
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
    @responder = Responder.find_by(name: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
