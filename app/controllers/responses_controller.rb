class ResponsesController < ApplicationController

  def index
    @responses = Response.where("poll_id = ?", params[:poll_id])

    respond_to do |format|
      format.json {render json: @responses}
    end

  end

  def show
    @response = Response.find(params[:id])

    respond_to do |format|
      format.json {render json: @response}
    end
  end


  def create
    @response = Response.create(params[:details])

    respond_to do |format|
      format.json {render json: @response}
    end

  end


end
