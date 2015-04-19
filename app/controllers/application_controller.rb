class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from ActionController::RoutingError, with: :page_not_found
  #rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  private

  def page_not_found
    render file: "#{Rails.root}/public/404.json", status: :not_found
  end

  # def unpermitted_parameters
  #   respond_to do |format|
  #     format.json { render json: { message: , status: :not_found}
  #   end
  # end

end
