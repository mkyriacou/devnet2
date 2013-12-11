class ProjectsController < ApplicationController

  def index

    projects = Project.where("user_id = ?", current_user.id)
    @projects = projects.sort_by { |k| k[:created_at] }.reverse

    respond_to do |format|
      format.json {render json: @projects}
    end

  end

  def show
    @project = Project.where("id = ?", params[:id])

    respond_to do |format|
      format.json {render json: @project}
    end
  end



  def create
    @project = Project.create(params[:details])

    respond_to do |format|
      format.json {render json: @project}
    end

  end


end
