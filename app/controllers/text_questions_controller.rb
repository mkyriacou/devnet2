class TextQuestionsController < ApplicationController

  def index
    @text_qs = TextQuestion.where("poll_id = ?", params[:poll_id])

    respond_to do |format|
      format.json {render json: @text_qs}
    end

  end

  def show
    @text_q = TextQuestion.find(params[:id])

    respond_to do |format|
      format.json {render json: @text_q}
    end
  end


  def create
    @text_q = TextQuestion.create(params[:details])

    respond_to do |format|
      format.json {render json: @text_q}
    end

  end



end
