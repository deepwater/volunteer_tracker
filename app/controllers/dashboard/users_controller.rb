class Dashboard::UsersController < DashboardController

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]

    respond_to do |format|
      if @user.save(validate: false) # skip username validation TODO: talk about default username value with Chris
        format.html { redirect_to :back, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, alert: "User can't be #{params[:user][:role]}" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
