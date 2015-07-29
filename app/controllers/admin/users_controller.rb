class Admin::UsersController < Admin::BaseController
  before_action :user, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: @user }
      format.js
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: [:admin, @user] }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    @user.skip_reconfirmation!

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to [:admin, @user], notice: 'User was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to admin_root_path }
      format.json { head :no_content }
    end
  end

  private
    def user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit!
    end
end
