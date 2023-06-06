module ApplicationHelper
    def page_title
        title = "Morning Glory"
        title = @page_title + "-" + title if @page_title
        title
    end
    
    def menu_link_to(text, path, options = {}) #第３引数が省略可能、省略された場合、空のハッシュを渡す
        # リストタグを生成
        content_tag :li do
            # link_to_unless_current指定のパスが現在のリンクだった場合、リンクの代わりにテキストを表示する
            # content_tagにより、表示するテキストにspanタグをつけて表示している
            # link_to_unless_current(text, path, options) do
            #     content_tag(:span,text)
            # end
            condition = options[:method] || !current_page?(path)

            link_to_if(condition, text, path, options) do
                content_tag(:span,text)
            end
        end
    end
end
