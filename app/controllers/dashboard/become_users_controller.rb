class Dashboard::BecomeUsersController < DashboardController

  def index
    @users = User.with_any_role(:volunteer, :volunteer_manager, :department_assistant)
    puts "#{current_user.full_name}"

    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    # create new variables
    accounts_exist = false
    @subaccounts = []
    @users = []

    subaccount_ids = params[:user][:subaccount_ids]

    if not subaccount_ids.blank?
      subaccount_ids.each do |id|
        if not id.blank?
          subaccount = User.find(id)
          if not subaccount.blank?
            accounts_exist = true
            @subaccounts << subaccount
          end
        end
      end
    end

    # if accounts exist then get all Users (otherwise unnecessary call)
    if accounts_exist
      @users = User.all
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    master_user = User.find(params[:master_id])
    master_user.transfer_status = "PENDING"
    master_user.save!

    subaccount_ids = params[:subaccounts]

    if not subaccount_ids.blank?
      subaccount_ids.each do |id|
        if not id.blank?
          subaccount = User.find(id)
          if not subaccount.blank?
            subaccount.pending_master_id = master_user.id
            subaccount.save!
          end
        end
      end
    end

    respond_to do |format|
      format.js
    end

  end

  def accept_transfer
    user = User.find(params[:user_id])
    subaccounts = User.where("pending_master_id = ?", user.id)

    if not subaccounts.blank?
      subaccounts.each do |subaccount|
        subaccount.master_id = user.id
        subaccount.pending_master_id = -1
        subaccount.save!
      end
    end
    user.transfer_status = ""
    user.save!

    redirect_to dashboard_path
  end

  def decline_transfer
    user = User.find(params[:user_id])
    subaccounts = User.where("pending_master_id = ?", @user.id)
    if not subaccounts.blank?
      subaccounts.each do |subaccount|
        subaccount.pending_master_id = -1
        subaccount.save!
      end
    end
    @user.transfer_status = ""
    @user.save!

    redirect_to dashboard_path
  end


end