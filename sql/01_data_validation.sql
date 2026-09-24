-- STEP 1: Check customers table columns
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'customers'
ORDER BY ordinal_position;
-- STEP 2: Compare customer IDs
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM public.customers;
-- STEP 3: Find customers with multiple customer_id values
SELECT
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS customer_id_count
FROM public.customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY customer_id_count DESC
LIMIT 20;
-- STEP 4: Checks whether the customer_id itself is duplicated in the customers table.
SELECT
    customer_id,
    COUNT(*) AS row_count
FROM public.customers
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 20;
-- STEP 5 — check for missing customer IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS missing_customer_unique_id
FROM public.customers;
-- STEP 6: Check whether orders have multiple payment records
SELECT
    order_id,
    COUNT(*) AS payment_rows
FROM public.olist_order_payments_dataset
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_rows DESC
LIMIT 20;
-- STEP 7: Check total payment rows and unique orders
SELECT
    COUNT(*) AS payment_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM public.olist_order_payments_dataset;
-- STEP 8: Check how many items each order contains
SELECT
    order_id,
    COUNT(*) AS item_count
FROM public.olist_order_items_dataset
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 20;
-- STEP 9: Check total order-item rows, unique orders, and unique products
SELECT
    COUNT(*) AS item_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products
FROM public.olist_order_items_dataset;
-- STEP 10: Check the number of unique order IDs in the order-items table
SELECT
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM public.olist_order_items_dataset;
-- STEP 11: Find orders with the most items
SELECT
    order_id,
    COUNT(*) AS item_count
FROM public.olist_order_items_dataset
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 20;
-- STEP 12: Check for multiple reviews per order
SELECT
    order_id,
    COUNT(*) AS review_count
FROM public.olist_order_reviews_dataset
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC
LIMIT 20;
-- STEP 13: Check total review rows and unique orders
SELECT
    COUNT(*) AS review_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM public.olist_order_reviews_dataset;
-- STEP 14: Check for duplicate review IDs
SELECT
    review_id,
    COUNT(*) AS row_count
FROM public.olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 20;
-- STEP 15: Quantify duplicate and missing review IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(*) FILTER (WHERE review_id IS NULL) AS missing_review_ids
FROM public.olist_order_reviews_dataset;
-- STEP 16: Check for exact duplicate review records
SELECT
    review_id,
    order_id,
    review_score,
    COUNT(*) AS row_count
FROM public.olist_order_reviews_dataset
GROUP BY
    review_id,
    order_id,
    review_score
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 20;
-- STEP 17: Count rows that belong to duplicated review records
SELECT
    COUNT(*) AS duplicated_rows
FROM (
    SELECT
        review_id,
        order_id,
        review_score,
        COUNT(*) AS row_count
    FROM public.olist_order_reviews_dataset
    GROUP BY
        review_id,
        order_id,
        review_score
    HAVING COUNT(*) > 1
) AS duplicates;
-- STEP 18: Measure exact duplicate review rows
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (review_id, order_id, review_score)) AS unique_review_records
FROM public.olist_order_reviews_dataset;
-- STEP 19: Check for completely identical review rows
SELECT
    COUNT(*) AS total_rows,
    (
        SELECT COUNT(*)
        FROM (
            SELECT DISTINCT *
            FROM public.olist_order_reviews_dataset
        ) AS unique_rows
    ) AS unique_full_rows;
-- STEP 19: Count completely unique review rows
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids
FROM public.olist_order_reviews_dataset;
-- STEP 20: Check row counts for the main Olist tables
SELECT COUNT(*) AS customer_rows
FROM public.customers;
-- STEP 20: Check row count for customers
SELECT COUNT(*) AS customer_rows
FROM public.customers;
-- STEP 20B: Check row count for orders
SELECT COUNT(*) AS order_rows
FROM public.olist_orders_dataset;
-- STEP 20C: Check row count for order items
SELECT COUNT(*) AS order_item_rows
FROM public.olist_order_items_dataset;
-- STEP 20D: Check row count for payments
SELECT COUNT(*) AS payment_rows
FROM public.olist_order_payments_dataset;
-- STEP 20E: Check row count for reviews
SELECT COUNT(*) AS review_rows
FROM public.olist_order_reviews_dataset;
-- STEP 20F: Check row count for products
SELECT COUNT(*) AS product_rows
FROM public.olist_products;
-- STEP 20G: Check row count for sellers
SELECT COUNT(*) AS seller_rows
FROM public.olist_sellers_dataset;
-- STEP 20H: Check row count for geolocation
SELECT COUNT(*) AS geolocation_rows
FROM public.geolocation;
-- STEP 20I: Check row count for category translation
SELECT COUNT(*) AS translation_rows
FROM public.product_category_name_translation;
-- STEP 21: Check order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM public.olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;
-- STEP 22: Check missing order dates
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS missing_purchase_dates
FROM public.olist_orders_dataset;
-- STEP 23: Check order purchase date range
SELECT
    MIN(order_purchase_timestamp) AS earliest_order,
    MAX(order_purchase_timestamp) AS latest_order
FROM public.olist_orders_dataset;
-- STEP 24: Check for missing order and customer IDs
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id
FROM public.olist_orders_dataset;
-- STEP 25: Check for orders without a matching customer
SELECT
    COUNT(*) AS unmatched_orders
FROM public.olist_orders_dataset o
LEFT JOIN public.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- STEP 26: Check for order items without a matching order
SELECT
    COUNT(*) AS unmatched_order_items
FROM public.olist_order_items_dataset oi
LEFT JOIN public.olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
-- STEP 27: Check for order items without a matching product
SELECT
    COUNT(*) AS unmatched_order_items
FROM public.olist_order_items_dataset oi
LEFT JOIN public.olist_products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
-- STEP 28: Check for order items without a matching seller
SELECT
    COUNT(*) AS unmatched_order_items
FROM public.olist_order_items_dataset oi
LEFT JOIN public.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
-- STEP 29: Check for payments without a matching order
SELECT
    COUNT(*) AS unmatched_payments
FROM public.olist_order_payments_dataset p
LEFT JOIN public.olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;
-- STEP 30: Check for reviews without a matching order
SELECT
    COUNT(*) AS unmatched_reviews
FROM public.olist_order_reviews_dataset r
LEFT JOIN public.olist_orders_dataset o
    ON r.order_id = o.order_id
WHERE r.order_id IS NOT NULL
  AND o.order_id IS NULL;
-- STEP 31: Check missing review order IDs
SELECT
    COUNT(*) AS missing_review_order_ids
FROM public.olist_order_reviews_dataset
WHERE order_id IS NULL;
-- STEP 32: Final review data-quality summary
SELECT
    COUNT(*) AS total_review_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_ids
FROM public.olist_order_reviews_dataset;
-- STEP 33: Check for exact duplicate review rows
SELECT COUNT(*)
FROM (
    SELECT DISTINCT *
    FROM public.olist_order_reviews_dataset
) AS t;
-- STEP 34: Clear contaminated review table before clean re-import
TRUNCATE TABLE public.olist_order_reviews_dataset;
-- STEP 36: Verify clean review import
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids
FROM public.olist_order_reviews_dataset;
-- STEP 36: Verify clean review import
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids
FROM public.olist_order_reviews_dataset;
-- STEP 37: Confirm order-level grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM public.olist_orders_dataset;
-- STEP 38: Confirm customer table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM public.customers;
-- STEP 39: Confirm order-item table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products
FROM public.olist_order_items_dataset;
-- STEP 40: Confirm payment table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM public.olist_order_payments_dataset;
-- STEP 41: Confirm review table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS unique_orders
FROM public.olist_order_reviews_dataset;
-- STEP 42: Confirm product table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM public.olist_products;
-- STEP 43: Confirm seller table grain
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM public.olist_sellers_dataset;
-- STEP 44: Check for order items without a valid product or seller
SELECT
    COUNT(*) AS unmatched_items
FROM public.olist_order_items_dataset oi
LEFT JOIN public.olist_products p
    ON oi.product_id = p.product_id
LEFT JOIN public.olist_sellers_dataset s
    ON oi.seller_id = s.seller_id
WHERE p.product_id IS NULL
   OR s.seller_id IS NULL;
-- STEP 45: Analyze order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders
FROM public.olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;
-- STEP 45: Calculate total item sales (GMV)
SELECT
    SUM(price) AS total_gmv
FROM public.olist_order_items_dataset;
-- STEP 46: Calculate realized sales for delivered orders
SELECT
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS realized_sales
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 47: Count delivered orders
SELECT
    COUNT(*) AS delivered_orders
FROM public.olist_orders_dataset
WHERE order_status = 'delivered';
-- STEP 48: Calculate Average Order Value
SELECT
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 49: Count items sold in delivered orders
SELECT
    COUNT(*) AS items_sold
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 50: Monthly realized sales
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS sales_month,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp::timestamp
)
ORDER BY sales_month;
-- STEP 51: Monthly realized sales and AOV
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS sales_month,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp::timestamp
)
ORDER BY sales_month;
-- STEP 52: Calculate delivery completion rate
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE order_status = 'delivered') AS delivered_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'delivered')
        / COUNT(*),
        2
    ) AS delivery_completion_rate
FROM public.olist_orders_dataset;
-- STEP 53: Monthly delivered order volume
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS sales_month,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM public.olist_orders_dataset o
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp::timestamp
)
ORDER BY sales_month;
-- STEP 54: Monthly sales growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp::timestamp
        ) AS sales_month,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.olist_orders_dataset o
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    )
)
SELECT
    sales_month,
    ROUND(realized_sales, 2) AS realized_sales,
    ROUND(
        100.0 * (
            realized_sales - LAG(realized_sales) OVER (ORDER BY sales_month)
        ) / NULLIF(
            LAG(realized_sales) OVER (ORDER BY sales_month),
            0
        ),
        2
    ) AS month_over_month_growth_pct
FROM monthly_sales
ORDER BY sales_month;
-- STEP 55: Sales performance summary
SELECT
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(*) AS items_sold,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 56: Realized sales by product category
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'unknown'
    ) AS product_category,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS delivered_orders
FROM public.olist_order_items_dataset oi
JOIN public.olist_orders_dataset o
    ON oi.order_id = o.order_id
JOIN public.olist_products p
    ON oi.product_id = p.product_id
LEFT JOIN public.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'unknown'
    )
ORDER BY realized_sales DESC;
-- STEP 57: Category share of realized sales
WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) AS product_category,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.olist_order_items_dataset oi
    JOIN public.olist_orders_dataset o
        ON oi.order_id = o.order_id
    JOIN public.olist_products p
        ON oi.product_id = p.product_id
    LEFT JOIN public.product_category_name_translation t
        ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        )
)
SELECT
    product_category,
    ROUND(realized_sales, 2) AS realized_sales,
    ROUND(
        100.0 * realized_sales / SUM(realized_sales) OVER (),
        2
    ) AS sales_share_pct
FROM category_sales
ORDER BY realized_sales DESC;
-- STEP 58: Top 20 product categories by realized sales
WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) AS product_category,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales,
        COUNT(*) AS items_sold
    FROM public.olist_order_items_dataset oi
    JOIN public.olist_orders_dataset o
        ON oi.order_id = o.order_id
    JOIN public.olist_products p
        ON oi.product_id = p.product_id
    LEFT JOIN public.product_category_name_translation t
        ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY
        COALESCE(
            t.product_category_name_english,
            p.product_category_name,
            'unknown'
        )
)
SELECT
    product_category,
    ROUND(realized_sales, 2) AS realized_sales,
    items_sold
FROM category_sales
ORDER BY realized_sales DESC
LIMIT 20;
-- STEP 59: Top 20 products by realized sales
SELECT
    oi.product_id,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS delivered_orders
FROM public.olist_order_items_dataset oi
JOIN public.olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY realized_sales DESC
LIMIT 20;
-- STEP 60: Product sales summary with category
SELECT
    oi.product_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'unknown'
    ) AS product_category,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS delivered_orders
FROM public.olist_order_items_dataset oi
JOIN public.olist_orders_dataset o
    ON oi.order_id = o.order_id
JOIN public.olist_products p
    ON oi.product_id = p.product_id
LEFT JOIN public.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    oi.product_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'unknown'
    )
ORDER BY realized_sales DESC
LIMIT 20;
-- STEP 61: Sales by customer state
SELECT
    c.customer_state,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN public.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY realized_sales DESC;
-- STEP 62: Customer concentration by state
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN public.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY realized_sales DESC;
-- STEP 63: Sales by customer state with sales share
WITH state_sales AS (
    SELECT
        c.customer_state,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.olist_orders_dataset o
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    JOIN public.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_state
)
SELECT
    customer_state,
    ROUND(realized_sales, 2) AS realized_sales,
    ROUND(
        100.0 * realized_sales / SUM(realized_sales) OVER (),
        2
    ) AS sales_share_pct
FROM state_sales
ORDER BY realized_sales DESC;
-- STEP 64: Average order value by customer state
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
JOIN public.customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY average_order_value DESC;
-- STEP 65: Sales by order status
SELECT
    order_status,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'delivered'
                THEN 1
                ELSE 0
            END
        )::numeric,
        0
    ) AS delivered_orders
FROM public.olist_orders_dataset
GROUP BY order_status
ORDER BY delivered_orders DESC;
-- STEP 66: Average order value by month
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS sales_month,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp::timestamp
)
ORDER BY sales_month;
-- STEP 67: Items per delivered order
SELECT
    ROUND(
        COUNT(*)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_items_per_order
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 68: Average product price and freight value
SELECT
    ROUND(AVG(oi.price)::numeric, 2) AS average_product_price,
    ROUND(AVG(oi.freight_value)::numeric, 2) AS average_freight_value,
    ROUND(
        AVG(oi.price + oi.freight_value)::numeric,
        2
    ) AS average_item_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 69: Monthly sales, orders, and items
SELECT
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp::timestamp
    ) AS sales_month,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(*) AS items_sold,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp::timestamp
)
ORDER BY sales_month;
-- STEP 70: Sales performance summary
SELECT
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS realized_sales,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(*) AS items_sold,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value,
    ROUND(
        COUNT(*)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_items_per_order
FROM public.olist_orders_dataset o
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
-- STEP 71: One-time vs repeat customers
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'one-time'
        ELSE 'repeat'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'one-time'
        ELSE 'repeat'
    END
ORDER BY customer_count DESC;
-- STEP 72: Orders per customer
SELECT
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT c.customer_unique_id) AS customer_count,
    ROUND(
        100.0 * COUNT(DISTINCT c.customer_unique_id)
        / SUM(COUNT(DISTINCT c.customer_unique_id)) OVER (),
        2
    ) AS customer_share_pct
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY order_count DESC;
-- STEP 73: Customer sales contribution
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS realized_sales
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY realized_sales DESC
LIMIT 20;
-- STEP 74: Customer order frequency distribution
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    order_count,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;
-- STEP 75: Customer sales distribution
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(MIN(realized_sales), 2) AS minimum_customer_sales,
    ROUND(AVG(realized_sales), 2) AS average_customer_sales,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY realized_sales)::numeric,
        2
    ) AS median_customer_sales,
    ROUND(MAX(realized_sales), 2) AS maximum_customer_sales
FROM customer_sales;
-- STEP 76: Top 20 customers by realized sales
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    delivered_orders,
    ROUND(realized_sales, 2) AS realized_sales
FROM customer_sales
ORDER BY realized_sales DESC
LIMIT 20;
-- STEP 77: Customer sales concentration
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
ranked_customers AS (
    SELECT
        customer_unique_id,
        realized_sales,
        ROW_NUMBER() OVER (
            ORDER BY realized_sales DESC
        ) AS customer_rank,
        SUM(realized_sales) OVER () AS total_sales
    FROM customer_sales
)
SELECT
    customer_rank,
    ROUND(realized_sales, 2) AS realized_sales,
    ROUND(
        100.0 * realized_sales / total_sales,
        2
    ) AS sales_share_pct
FROM ranked_customers
WHERE customer_rank <= 100
ORDER BY customer_rank;
-- STEP 78: One-time vs repeat customer sales
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'one-time'
        ELSE 'repeat'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(SUM(realized_sales), 2) AS realized_sales,
    ROUND(
        100.0 * SUM(realized_sales)
        / SUM(SUM(realized_sales)) OVER (),
        2
    ) AS sales_share_pct
FROM customer_sales
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'one-time'
        ELSE 'repeat'
    END
ORDER BY realized_sales DESC;
-- STEP 79: Customer intelligence summary
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (
        WHERE delivered_orders = 1
    ) AS one_time_customers,
    COUNT(*) FILTER (
        WHERE delivered_orders > 1
    ) AS repeat_customers,
    ROUND(AVG(delivered_orders)::numeric, 2) AS average_orders_per_customer,
    ROUND(SUM(realized_sales), 2) AS total_realized_sales,
    ROUND(AVG(realized_sales), 2) AS average_customer_sales,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY realized_sales)::numeric,
        2
    ) AS median_customer_sales
FROM customer_data;
-- STEP 80: Customer lifetime purchase timing
SELECT
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp::timestamp) AS first_purchase,
    MAX(o.order_purchase_timestamp::timestamp) AS last_purchase,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY last_purchase DESC;
-- STEP 81: Customer average order value
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    delivered_orders,
    ROUND(
        realized_sales / delivered_orders,
        2
    ) AS customer_average_order_value
FROM customer_data
ORDER BY customer_average_order_value DESC
LIMIT 20;
-- STEP 82: Repeat customer behavior
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    delivered_orders,
    COUNT(*) AS customer_count,
    ROUND(AVG(realized_sales)::numeric, 2) AS average_customer_sales,
    ROUND(
        AVG(
            realized_sales / delivered_orders
        )::numeric,
        2
    ) AS average_order_value
FROM customer_orders
GROUP BY delivered_orders
ORDER BY delivered_orders;
-- STEP 83: Customer acquisition by month
WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp::timestamp) AS first_purchase_date
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    DATE_TRUNC('month', first_purchase_date) AS acquisition_month,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY DATE_TRUNC('month', first_purchase_date)
ORDER BY acquisition_month;
-- STEP 84: Customer intelligence summary by acquisition month
WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp::timestamp) AS first_purchase_date
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    DATE_TRUNC('month', first_purchase_date) AS acquisition_month,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY DATE_TRUNC('month', first_purchase_date)
ORDER BY acquisition_month;
-- STEP 85: Final customer intelligence summary
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales,
        MIN(o.order_purchase_timestamp::timestamp) AS first_purchase,
        MAX(o.order_purchase_timestamp::timestamp) AS last_purchase
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (WHERE delivered_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE delivered_orders > 1) AS repeat_customers,
    ROUND(AVG(delivered_orders)::numeric, 2) AS avg_orders_per_customer,
    ROUND(AVG(realized_sales)::numeric, 2) AS avg_customer_sales,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY realized_sales)::numeric,
        2
    ) AS median_customer_sales,
    ROUND(SUM(realized_sales), 2) AS total_realized_sales,
    MIN(first_purchase) AS earliest_customer_purchase,
    MAX(last_purchase) AS latest_customer_purchase
FROM customer_data;
-- STEP 86: Customer Intelligence complete — repeat customer rate
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE delivered_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE delivered_orders > 1) AS repeat_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE delivered_orders > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;
-- STEP 87: Customer Intelligence — customer sales concentration
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
ranked AS (
    SELECT
        customer_unique_id,
        realized_sales,
        NTILE(10) OVER (ORDER BY realized_sales DESC) AS sales_decile
    FROM customer_sales
)
SELECT
    sales_decile,
    COUNT(*) AS customer_count,
    ROUND(SUM(realized_sales), 2) AS realized_sales,
    ROUND(
        100.0 * SUM(realized_sales)
        / SUM(SUM(realized_sales)) OVER (),
        2
    ) AS sales_share_pct
FROM ranked
GROUP BY sales_decile
ORDER BY sales_decile;
-- STEP 88: Customer Intelligence — customer lifetime duration
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp::timestamp) AS first_purchase,
        MAX(o.order_purchase_timestamp::timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id) AS delivered_orders
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (last_purchase - first_purchase)
            ) / 86400
        )::numeric,
        2
    ) AS average_customer_lifetime_days,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY EXTRACT(
                EPOCH FROM (last_purchase - first_purchase)
            ) / 86400
        )::numeric,
        2
    ) AS median_customer_lifetime_days
FROM customer_data
WHERE delivered_orders > 1;
-- STEP 89: Customer Intelligence — repeat purchase rate by customer order count
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    delivered_orders,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM customer_orders
GROUP BY delivered_orders
ORDER BY delivered_orders;
-- STEP 90: Customer Intelligence — repeat customer share of sales
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN delivered_orders = 1 THEN 'one-time'
        ELSE 'repeat'
    END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(SUM(realized_sales), 2) AS realized_sales,
    ROUND(
        100.0 * SUM(realized_sales)
        / SUM(SUM(realized_sales)) OVER (),
        2
    ) AS sales_share_pct
FROM customer_sales
GROUP BY
    CASE
        WHEN delivered_orders = 1 THEN 'one-time'
        ELSE 'repeat'
    END
ORDER BY realized_sales DESC;
-- STEP 91: Customer Intelligence — customer value by order frequency
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    delivered_orders,
    COUNT(*) AS customer_count,
    ROUND(AVG(realized_sales)::numeric, 2) AS avg_customer_sales,
    ROUND(SUM(realized_sales), 2) AS total_realized_sales,
    ROUND(
        100.0 * SUM(realized_sales)
        / SUM(SUM(realized_sales)) OVER (),
        2
    ) AS sales_share_pct
FROM customer_sales
GROUP BY delivered_orders
ORDER BY delivered_orders;
-- STEP 92: Customer revenue contribution by customer segment
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN delivered_orders = 1 THEN 'one-time'
        WHEN delivered_orders BETWEEN 2 AND 3 THEN 'occasional-repeat'
        ELSE 'high-frequency'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(realized_sales), 2) AS realized_sales,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct,
    ROUND(
        100.0 * SUM(realized_sales)
        / SUM(SUM(realized_sales)) OVER (),
        2
    ) AS sales_share_pct
FROM customer_sales
GROUP BY
    CASE
        WHEN delivered_orders = 1 THEN 'one-time'
        WHEN delivered_orders BETWEEN 2 AND 3 THEN 'occasional-repeat'
        ELSE 'high-frequency'
    END
ORDER BY realized_sales DESC;
-- STEP 93: Final Customer Intelligence validation
WITH customer_data AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS delivered_orders,
        SUM(oi.price + oi.freight_value)::numeric AS realized_sales
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (WHERE delivered_orders = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE delivered_orders > 1) AS repeat_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE delivered_orders > 1)
        / COUNT(*),
        2
    ) AS repeat_customer_rate_pct,
    ROUND(SUM(realized_sales), 2) AS total_realized_sales,
    ROUND(AVG(realized_sales), 2) AS average_customer_sales
FROM customer_data;
-- STEP 94: Customer Experience — average review score
SELECT
    ROUND(AVG(review_score::numeric), 2) AS average_review_score,
    COUNT(*) AS total_reviews
FROM public.olist_order_reviews_dataset;
-- STEP 95: Customer Experience — review score distribution
SELECT
    review_score::numeric AS review_score,
    COUNT(*) AS review_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS review_share_pct
FROM public.olist_order_reviews_dataset
GROUP BY review_score::numeric
ORDER BY review_score::numeric;
-- STEP 96: Customer Experience — average delivery time
SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    NULLIF(o.order_delivered_customer_date, '')::timestamp
                    - NULLIF(o.order_purchase_timestamp, '')::timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS average_delivery_days
FROM public.olist_orders_dataset o
WHERE o.order_status = 'delivered'
  AND NULLIF(o.order_delivered_customer_date, '') IS NOT NULL
  AND NULLIF(o.order_purchase_timestamp, '') IS NOT NULL;
-- STEP 97: Customer Experience — average delivery time by month
SELECT
    DATE_TRUNC(
        'month',
        NULLIF(o.order_purchase_timestamp, '')::timestamp
    ) AS delivery_month,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    NULLIF(o.order_delivered_customer_date, '')::timestamp
                    - NULLIF(o.order_purchase_timestamp, '')::timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS average_delivery_days,
    COUNT(*) AS delivered_orders
FROM public.olist_orders_dataset o
WHERE o.order_status = 'delivered'
  AND NULLIF(o.order_delivered_customer_date, '') IS NOT NULL
  AND NULLIF(o.order_purchase_timestamp, '') IS NOT NULL
GROUP BY DATE_TRUNC(
    'month',
    NULLIF(o.order_purchase_timestamp, '')::timestamp
)
ORDER BY delivery_month;
-- STEP 98: Customer Experience — late delivery rate
SELECT
    COUNT(*) AS delivered_orders,
    COUNT(*) FILTER (
        WHERE NULLIF(order_delivered_customer_date, '')::timestamp
              > NULLIF(order_estimated_delivery_date, '')::timestamp
    ) AS late_deliveries,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE NULLIF(order_delivered_customer_date, '')::timestamp
                  > NULLIF(order_estimated_delivery_date, '')::timestamp
        ) / COUNT(*),
        2
    ) AS late_delivery_rate_pct
FROM public.olist_orders_dataset
WHERE order_status = 'delivered'
  AND NULLIF(order_delivered_customer_date, '') IS NOT NULL
  AND NULLIF(order_estimated_delivery_date, '') IS NOT NULL;
-- STEP 99: Customer Experience — review score vs delivery performance
WITH delivery_data AS (
    SELECT
        o.order_id,
        CASE
            WHEN NULLIF(o.order_delivered_customer_date, '')::timestamp
                 <= NULLIF(o.order_estimated_delivery_date, '')::timestamp
            THEN 'on_time'
            ELSE 'late'
        END AS delivery_status
    FROM public.olist_orders_dataset o
    WHERE o.order_status = 'delivered'
      AND NULLIF(o.order_delivered_customer_date, '') IS NOT NULL
      AND NULLIF(o.order_estimated_delivery_date, '') IS NOT NULL
)
SELECT
    d.delivery_status,
    COUNT(*) AS review_count,
    ROUND(AVG(r.review_score::numeric), 2) AS average_review_score
FROM delivery_data d
JOIN public.olist_order_reviews_dataset r
    ON d.order_id = r.order_id
GROUP BY d.delivery_status
ORDER BY d.delivery_status;
-- STEP 100: Final Customer Experience summary
WITH delivery_data AS (
    SELECT
        o.order_id,
        EXTRACT(
            EPOCH FROM (
                NULLIF(o.order_delivered_customer_date, '')::timestamp
                - NULLIF(o.order_purchase_timestamp, '')::timestamp
            )
        ) / 86400 AS delivery_days,
        CASE
            WHEN NULLIF(o.order_delivered_customer_date, '')::timestamp
                 <= NULLIF(o.order_estimated_delivery_date, '')::timestamp
            THEN 'on_time'
            ELSE 'late'
        END AS delivery_status
    FROM public.olist_orders_dataset o
    WHERE o.order_status = 'delivered'
      AND NULLIF(o.order_delivered_customer_date, '') IS NOT NULL
      AND NULLIF(o.order_purchase_timestamp, '') IS NOT NULL
      AND NULLIF(o.order_estimated_delivery_date, '') IS NOT NULL
),
review_data AS (
    SELECT
        AVG(review_score::numeric) AS average_review_score
    FROM public.olist_order_reviews_dataset
)
SELECT
    ROUND(AVG(d.delivery_days)::numeric, 2) AS average_delivery_days,
    COUNT(*) AS delivered_orders,
    COUNT(*) FILTER (
        WHERE d.delivery_status = 'late'
    ) AS late_deliveries,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE d.delivery_status = 'late'
        ) / COUNT(*),
        2
    ) AS late_delivery_rate_pct,
    ROUND(r.average_review_score::numeric, 2) AS average_review_score
FROM delivery_data d
CROSS JOIN review_data r
GROUP BY r.average_review_score;
-- STEP 101: RFM — Recency
SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp::timestamp) AS last_purchase_date,
    CURRENT_DATE
        - MAX(o.order_purchase_timestamp::timestamp)::date AS recency_days
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY recency_days;
-- STEP 102: RFM — Frequency
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS frequency
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY frequency DESC;
-- STEP 103: RFM — Monetary
SELECT
    c.customer_unique_id,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric,
        2
    ) AS monetary_value
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN public.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY monetary_value DESC;
-- STEP 104: RFM — Combine Recency, Frequency, and Monetary
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary
FROM rfm
ORDER BY recency, frequency DESC, monetary DESC;
-- STEP 105: RFM — Quintile scores
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    recency_score,
    frequency_score,
    monetary_score
FROM rfm_scores
ORDER BY recency_score DESC, frequency_score DESC, monetary_score DESC;
-- STEP 106: RFM — Customer segments
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score
FROM rfm_scores
ORDER BY rfm_score DESC;
-- STEP 107: RFM — Segment summary
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    recency_score,
    frequency_score,
    monetary_score,
    COUNT(*) AS customer_count,
    ROUND(AVG(recency)::numeric, 2) AS avg_recency_days,
    ROUND(AVG(frequency)::numeric, 2) AS avg_frequency,
    ROUND(AVG(monetary)::numeric, 2) AS avg_monetary
FROM rfm_scores
GROUP BY
    recency_score,
    frequency_score,
    monetary_score
ORDER BY
    recency_score DESC,
    frequency_score DESC,
    monetary_score DESC;
-- STEP 108: RFM — Segment classification
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    customer_unique_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    recency_score,
    frequency_score,
    monetary_score,
    CASE
        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'High Value'
        WHEN recency_score >= 4
             AND frequency_score >= 3
            THEN 'Loyal'
        WHEN recency_score >= 4
             AND frequency_score <= 2
            THEN 'Recent'
        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At Risk'
        ELSE 'Occasional'
    END AS customer_segment
FROM rfm_scores
ORDER BY recency_score DESC, frequency_score DESC, monetary_score DESC;
-- STEP 109: RFM — Segment summary
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'High Value'
            WHEN recency_score >= 4
                 AND frequency_score >= 3
                THEN 'Loyal'
            WHEN recency_score >= 4
                 AND frequency_score <= 2
                THEN 'Recent'
            WHEN recency_score <= 2
                 AND frequency_score >= 3
                THEN 'At Risk'
            ELSE 'Occasional'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_share_pct,
    ROUND(AVG(recency)::numeric, 2) AS avg_recency_days,
    ROUND(AVG(frequency)::numeric, 2) AS avg_frequency,
    ROUND(AVG(monetary)::numeric, 2) AS avg_monetary
FROM segmented
GROUP BY customer_segment
ORDER BY customer_count DESC;
-- STEP 110: RFM — Segment revenue contribution
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        CURRENT_DATE
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN recency_score >= 4
                 AND frequency_score >= 4
                 AND monetary_score >= 4
                THEN 'High Value'
            WHEN recency_score >= 4
                 AND frequency_score >= 3
                THEN 'Loyal'
            WHEN recency_score >= 4
                 AND frequency_score <= 2
                THEN 'Recent'
            WHEN recency_score <= 2
                 AND frequency_score >= 3
                THEN 'At Risk'
            ELSE 'Occasional'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(monetary), 2) AS realized_sales,
    ROUND(
        100.0 * SUM(monetary)
        / SUM(SUM(monetary)) OVER (),
        2
    ) AS sales_share_pct
FROM segmented
GROUP BY customer_segment
ORDER BY realized_sales DESC;
-- STEP 111: Reconcile total vs delivered customer counts
SELECT
    COUNT(DISTINCT c.customer_unique_id) AS all_customers,
    COUNT(DISTINCT c.customer_unique_id) FILTER (
        WHERE o.order_status = 'delivered'
    ) AS delivered_customers,
    COUNT(DISTINCT c.customer_unique_id) FILTER (
        WHERE o.order_status <> 'delivered'
    ) AS non_delivered_customers
FROM public.customers c
JOIN public.olist_orders_dataset o
    ON c.customer_id = o.customer_id;
--STEP 112: RFM — Reconcile SQL and Python Base Metrics
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        (
            DATE '2018-10-17'
            - MAX(o.order_purchase_timestamp::timestamp)::date
        ) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS rfm_customers,
    ROUND(AVG(recency), 2) AS avg_recency,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary), 2) AS avg_monetary,
    MAX(frequency) AS max_frequency,
    ROUND(SUM(monetary), 2) AS total_monetary
FROM rfm;
--Step 113: RFM — Compare Corrected SQL Scores
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        DATE '2018-10-17'
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    recency_score,
    frequency_score,
    monetary_score,
    COUNT(*) AS customers
FROM rfm_scores
GROUP BY
    recency_score,
    frequency_score,
    monetary_score
ORDER BY
    recency_score,
    frequency_score,
    monetary_score;
--Step 114: RFM — Compare SQL Score Distribution
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        DATE '2018-10-17'
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    'Recency' AS metric,
    recency_score AS score,
    COUNT(*) AS customers
FROM rfm_scores
GROUP BY recency_score
UNION ALL
SELECT
    'Frequency',
    frequency_score,
    COUNT(*)
FROM rfm_scores
GROUP BY frequency_score
UNION ALL
SELECT
    'Monetary',
    monetary_score,
    COUNT(*)
FROM rfm_scores
GROUP BY monetary_score
ORDER BY metric, score;
--Step 115: RFM — Compare Segment Classification
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        DATE '2018-10-17'
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM rfm
)
SELECT
    CASE
        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'High Value'
        WHEN recency_score >= 4
             AND frequency_score >= 3
            THEN 'Loyal'
        WHEN recency_score >= 4
             AND frequency_score <= 2
            THEN 'Recent'
        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At Risk'
        ELSE 'Occasional'
    END AS customer_segment,
    COUNT(*) AS customers
FROM rfm_scores
GROUP BY 1
ORDER BY customers DESC;
--Step 116 — RFM: Align SQL with Python Segmentation
WITH rfm AS (
    SELECT
        c.customer_unique_id,
        DATE '2018-10-17'
            - MAX(o.order_purchase_timestamp::timestamp)::date AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value)::numeric AS monetary
    FROM public.customers c
    JOIN public.olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN public.olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN r_score + f_score + m_score <= 3
                THEN 'At Risk'
            WHEN r_score + f_score + m_score <= 6
                THEN 'Occasional'
            WHEN r_score + f_score + m_score <= 9
                THEN 'Recent'
            WHEN r_score + f_score + m_score <= 12
                THEN 'Loyal'
            ELSE 'High Value'
        END AS segment
    FROM rfm_scores
)
SELECT
    segment,
    COUNT(*) AS customers
FROM segmented
GROUP BY segment
ORDER BY customers DESC;

























