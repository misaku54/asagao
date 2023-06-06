class PasswordsController < ApplicationController
  # コールバック：ログインしていなければ例外を出す
  before_action :login_required

  def show
    redirect_to :account
  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    current_password = account_params[:current_password]

    if current_password.present? #新しいパスワードが入力されているかどうか
      if @member.authenticate(current_password) #入力した現在のパスワードがDB上のパスワードと一致しているか
        @member.assign_attributes(account_params) #
        if @member.save
          redirect_to :account, notice: "パスワードを変更しました。"
        else
          render "edit"
        end
      else
        @member.errors.add(:current_password, :wrong)
        render "edit"
      end
    else
      @member.errors.add(:current_password, :empty)
      render "edit"
    end
  end

  private
  # ストロングパラメータ設定
  def account_params
    params.require(:account).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
