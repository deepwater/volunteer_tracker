class Dashboard::BecomeUsersController < DashboardController

  def index
    respond_to do |format|
      format.html
      format.json { render json: BecomeUserDatatable.new(view_context) }
    end
  end

  def get_user_list
    respond_to do |format|
      format.json { render json: TransferUserDatatable.new(view_context) }
    end
  end

  def accept_transfer
    user = User.find(params[:user_id])

    subaccounts = User.where("pending_master_id = ?", user.id)

    if not subaccounts.blank?
      subaccounts.each do |subaccount|
        subaccount.master_id = user.id
        subaccount.pending_master_id = -1
        subaccount.save(:validate => false)
      end
    end
    user.transfer_status = ""
    user.save(:validate => false)

    redirect_to dashboard_index_path
  end

  def decline_transfer
    user = User.find(params[:user_id])
    subaccounts = User.where("pending_master_id = ?", @user.id)
    if not subaccounts.blank?
      subaccounts.each do |subaccount|
        subaccount.pending_master_id = -1
        subaccount.save(:validate => false)
      end
    end
    @user.transfer_status = ""
    @user.save(:validate => false)

    redirect_to dashboard_index_path
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @accounts_exist = false
    @master_user = params[:user][:master_id].present? ? User.find(params[:user][:master_id]) : nil
    @master_exists = @master_user.nil? ? false : true

    if @master_exists
      subaccount_ids = params[:user][:subaccount_ids]

      if not subaccount_ids.blank?
        subaccount_ids.each do |id|
          if not id.blank?
            @subaccount = User.find(id)
            if not @subaccount.blank?
              @accounts_exist = true

              @subaccount.pending_master_id = @master_user.id

              @subaccount.save(:validate => false)
            end
          end
        end
      end

      if @accounts_exist
        @master_user.transfer_status = "PENDING"
        @master_user.save(:validate => false)
      end
    end

    respond_to do |format|
        format.html { redirect_to dashboard_index_path, notice:  "Successfully began a transfer. The user must now accept the transfer."  }
        format.json { head :no_content }
        format.js
    end

  end
end