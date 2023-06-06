        # 前年比較のSQL
        # select a.maker_name, a.producttype_name, a.sum_amount_sold ,a.2023 , b.sum_amount_sold, b.2022
        # from (select makers.name as maker_name,producttypes.name as producttype_name, sum(sales.amount_sold) as sum_amount_sold ,2023
        #             from sales
        #               where created_at = 2023
        #               innner join makers 
        #                 on makers.id = maker_id and producttypes.id = producttype_id
        #               group by maker_id,producttype_id) a
        # left join 
        #   (select makers.name as maker_name,producttypes.name as producttype_name, sum(sales.amount_sold) as sum_amount_sold ,2022
        #     from sales
        #     where created_at = 2022
        #     left join makers 
        #     on makers.id = maker_id
        #     left join producttypes
        #     on producttypes.id = producttype_id
        #     group by maker_id,producttype_id) b
        # on a.maker_name = b.maker_name and a.producttype_name = b.producttype_name
        # order a.sum_amount_sold
        # パターン１
        # @sales.find_by_sql(SELECT makers.name as maker_name, producttypes.name as producttype_name,
        #                   SUM(sales.amount_sold) as sum_amount_sold, COUNT(*) as quantity_sold
        #                   FROM sales 
        #                   INNER JOIN makers
        #                   ON makers.id = sales.maker_id
        #                   INNER JOIN producttypes
        #                   ON producttypes.id = sales.producttype_id
        #                   GROUP BY maker_name, producttype_name)
        
        # 今年のデータのみを抽出する。
        AND s.created_at BETWEEN '2021-12-31 15:00:00' AND '2022-12-31 14:59:59.999999'


        # 商品分類とメーカーごとの合計販売額を抽出
        sql =  "SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                FROM sales s
                INNER JOIN makers m ON m.id = s.maker_id
                INNER JOIN producttypes p ON p.id = s.producttype_id
                WHERE s.user_id = 101
                AND s.created_at BETWEEN '2021-12-31 15:00:00' AND '2022-12-31 14:59:59.999999'
                GROUP BY maker_name, producttype_name
                ORDER BY sum_amount_sold DESC"
        # 仕入れごとの合計販売額を抽出
        sql2 = 'SELECT m.name maker_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                FROM sales s
                INNER JOIN makers m ON m.id = s.maker_id
                WHERE s.user_id = 101
                GROUP BY maker_name
                ORDER BY sum_amount_sold DESC'
        # 商品分類ごとの合計販売額を抽出
        sql3 = 'SELECT p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                FROM sales s
                INNER JOIN producttypes p ON p.id = s.producttype_id
                WHERE s.user_id = 101
                GROUP BY producttype_name
                ORDER BY sum_amount_sold DESC'

        # 今年と去年の結合
        sql4 =  "SELECT k.maker_name, k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
                        z.sum_amount_sold last_year_amount, z.quantity_sold last_year_quantity
                FROM (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                        FROM sales s
                        INNER JOIN makers m ON m.id = s.maker_id
                        INNER JOIN producttypes p ON p.id = s.producttype_id
                        WHERE s.user_id = 101
                        AND s.created_at BETWEEN '2022-12-31 15:00:00' AND '2023-12-31 14:59:59.999999'
                        GROUP BY maker_name, producttype_name
                        ORDER BY sum_amount_sold DESC ) k
                LEFT JOIN (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                            FROM sales s
                            INNER JOIN makers m ON m.id = s.maker_id
                            INNER JOIN producttypes p ON p.id = s.producttype_id
                            WHERE s.user_id = 101
                            AND s.created_at BETWEEN '2021-12-31 15:00:00' AND '2022-12-31 14:59:59.999999'
                            GROUP BY maker_name, producttype_name
                            ORDER BY sum_amount_sold DESC) z
                ON k.maker_name = z.maker_name AND k.producttype_name = z.producttype_name
                ORDER BY k.quantity_sold DESC"

sql4 =  "SELECT k.maker_name, k.producttype_name, k.sum_amount_sold current_year_amount, k.quantity_sold current_year_quantity,
                z.sum_amount_sold last_year_amount, z.quantity_sold last_year_quantity
        FROM (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                FROM sales s
                INNER JOIN makers m ON m.id = s.maker_id
                INNER JOIN producttypes p ON p.id = s.producttype_id
                WHERE s.user_id = :user_id
                AND s.created_at BETWEEN :current_year_start AND :current_year_end
                GROUP BY maker_name, producttype_name
                ORDER BY sum_amount_sold DESC ) k
        LEFT JOIN (SELECT m.name maker_name, p.name producttype_name, SUM(s.amount_sold) sum_amount_sold, COUNT(*) quantity_sold
                    FROM sales s
                    INNER JOIN makers m ON m.id = s.maker_id
                    INNER JOIN producttypes p ON p.id = s.producttype_id
                    WHERE s.user_id = :user_id
                    AND s.created_at BETWEEN :last_year_start AND :last_year_end
                    GROUP BY maker_name, producttype_name
                    ORDER BY sum_amount_sold DESC) z
        ON k.maker_name = z.maker_name AND k.producttype_name = z.producttype_name
        ORDER BY current_year_amount DESC"

        # 実行の使い分け
        # Saleクラスのインスタンスが配列となり返ってくる。
        result = Sale.find_by_sql([sql,{user_id: 101, current_year_start: '2022-12-31 15:00:00', current_year_end: '2023-12-31 14:59:59.999999', last_year_start:'2021-12-31 15:00:00', last_year_end:'2022-12-31 14:59:59.999999'}])
        # ActiveRecord::Resulのインスタンスを返す。
        result = ActiveRecord::Base.connection.select_all(sql)
        