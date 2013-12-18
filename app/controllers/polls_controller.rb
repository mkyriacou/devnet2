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

  def publicpolls
    # Is there a better way of doing this???
    all_public_projects = Project.where(:public_proj => true)

    # @all_public_polls = []
    # all_public_projects.each do |this_pub_proj|
    #   @all_public_polls << this_pub_proj.polls.find(:all)
    # end

    @all_public_polls = []
    all_public_projects.each do |this_pub_proj|
      if this_pub_proj.polls.length > 0
        @all_public_polls.concat(this_pub_proj.polls)
      end
    end

    respond_to do |format|
      format.json {render json: @all_public_polls}
    end
  end

end
