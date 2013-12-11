class PollsController < ApplicationController

  def index
    # project = Project.find(params[:id])
    @polls = Poll.where("project_id = ?", params[:project_id]) #29
    # polls = Project.Poll.where("user_id = ?", current_user.id)
    # @projects = projects.sort_by { |k| k[:created_at] }.reverse

    respond_to do |format|
      format.json {render json: @polls}
    end
  end

  def create
    @poll = Poll.create(params[:details])

    respond_to do |format|
      format.json {render json: @poll}
    end
end

  def show
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.json {render json: @poll}
    end
  end


end
