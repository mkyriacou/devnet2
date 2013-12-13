class TextQuestionsController < ApplicationController

  def index
    @textQs = Text_Question.where("poll_id = ?", params[poll_id])

    respond_to do |format|
      format.json {render json: @textQs}
    end

  end

  def show
      @textQ = Text_Question.find(params[:id])

    respond_to do |format|
      format.json {render json: @textQ}
    end
  end


  def create
    @textQ = Text_Question.create(params[:details])

    respond_to do |format|
      format.json {render json: @textQ}
    end

  end



end
