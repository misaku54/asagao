class MembersController < ApplicationController
    before_action :login_required
    # 会員一覧
    def index
        @members = Member.order("number").page(params[:page]).per(15)
    end
    
    def show
        @member = Member.find(params[:id])
    end

    def new
        @member = Member.new(birthday: Date.new(1980,1,1))
    end

    def edit
        @member = Member.find(params[:id])
    end

    # 会員の新規登録
    def create
        @member = Member.new(member_params) #ストロングパラメータ対応
        if @member.save
            redirect_to @member,notice: "会員を登録しました。" #詳細画面へ
        else
            render "new" #新規登録画面へ
        end
    end

    # 会員情報の更新
    def update
        @member = Member.find(params[:id])
        @member.assign_attributes(member_params) #ストロングパラメータ対応
        if @member.save
            redirect_to @member,notice: "会員情報を更新しました" #詳細画面へ
        else
            render "edit" #編集画面へ 
        end
    end

    # 会員の削除
    def destroy
        @member = Member.find(params[:id])
        @member.destroy
        redirect_to :members,notice: "会員を削除しました。"
    end

    # 会員検索
    def search
        @members = Member.search(params[:q]).page(params[:page]).per(15)
        render "index"
    end

    # ストロングパラメータ設定
    private
    def member_params
        attrs = [
            :new_profile_picture,
            :remove_profile_picture,
            :number,
            :name,
            :full_name,
            :sex,
            :birthday,
            :email,
            :administrator
        ]
        # createアクションの時だけパスワードをストロングパラメータに渡す。
        # これによりupdateアクションの時にユーザー側のHTMLの書き換えなどで
        # pasowordが入力され送信されたとしても、ストロングパラメータに設定されていないので無視される。
        attrs << :password if params[:action] == "create"
        params.require(:member).permit(attrs)
    end
end
