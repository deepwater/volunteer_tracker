class RegistrationsController < Devise::RegistrationsController

  def update
    @user = current_user

    successfully_updated =  if needs_password?(@user, params)
                              @user.update_with_password(params[:user])
                            else
                              # remove the virtual current_password attribute
                              # update_without_password doesn't know how to ignore it
                              params[:user].delete(:current_password)
                              @user.update_without_password(params[:user])
                            end

    if successfully_updated
      set_flash_message :notice, :updated
      sign_in @user, bypass: true
      respond_to do |format|
        format.html { redirect_to after_update_path_for(@user) }
        format.js { render js: "window.location.href='"+after_update_path_for(@user)+"'"}
      end
      
    else
      if request.format.try(:js?)
        respond_to do |format|
          format.js { render "users/edit" }
        end
      else
        render "edit"
      end
    end
  end

  private

    def needs_password?(user, params)
      params[:user][:password].present?
    end

  protected

    def after_inactive_sign_up_path_for(resource)
      welcome_path
    end
end
