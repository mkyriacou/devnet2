class UsersController < Devise::SessionsController
  def create
    super
  end

  def update
   #edit here
  end

  def details
    @user_details = User.find(params[:id])

    respond_to do |format|
      format.json {render json: @user_details}
    end
  end

end