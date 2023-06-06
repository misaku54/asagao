class SessionsController < ApplicationController
    def create
        member = Member.find_by(name: params[:name])
        # 対象のモデルオブジェクトのパスワードと入力値のパスワードを比較し、
        # 一致していればオブジェクト自体を返し、誤っていた場合はfalseを返す
        if member&.authenticate(params[:password])
            session[:member_id] = member.id
        else
            flash[:alert] = "名前とパスワードが一致しません。"
        end
        redirect_to :root
    end

    def destroy
        session.delete(:member_id)
        redirect_to :root
    end
end

