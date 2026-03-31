-- Viewing the table in order to inspect each column
select * from `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1` limit 10;

--- A) EDA (Exploratory Data Analysis)

---------------------------------------------------------------------------------------------------
-- 1. Checking the Date Range (Aggregate Function)
---------------------------------------------------------------------------------------------------
SELECT MIN(transaction_date) AS min_date
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;
-- Therefore, Data Collection started in 2023-01-01 (Minimum Date)

SELECT MAX(transaction_date) AS max_date
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;
-- Therefore, Data Collection ended in 2023-06-30 (Maximum Date)

-- Hence, the duration of the Data collection is 6 months
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- 2. Checking the names and number of different store locations
---------------------------------------------------------------------------------------------------
SELECT DISTINCT store_location
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;
-- Therefore, we have 3 different store locations namely: Lower Manhattan, Hell's Kitchen & Astoria

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;
-- Therefore, we have 3 different store locations
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- 3. Checking the products that are being sold at our stores
---------------------------------------------------------------------------------------------------
SELECT DISTINCT product_category
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_detail
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_category AS category,
                product_detail AS product_name
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT DISTINCT product_type
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

---------------------------------------------------------------------------------------------------

-- 3.1 Checking for NULLS in various columns
SELECT *
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`
WHERE unit_price IS NULL
OR transaction_qty IS NULL
OR transaction_date IS NULL;

-- Checking the day name and month name
SELECT transaction_date,
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

-- Calculating the revenue
SELECT unit_price,
        transaction_qty,
        transaction_qty * unit_price AS revenue
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;




---------------------------------------------------------------------------------------------------
-- 4. Checking the Prices
---------------------------------------------------------------------------------------------------
SELECT MIN(unit_price) AS cheapest_price
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

SELECT MAX(unit_price) AS expensive_price
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- 5. Checking the number of rows, sales, products and stores
---------------------------------------------------------------------------------------------------
SELECT COUNT(*) as number_of_rows,
        COUNT(DISTINCT transaction_id) AS number_of_sales,
        COUNT(DISTINCT product_id) AS number_of_products,
        COUNT(DISTINCT store_id) AS number_of_stores
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
SELECT transaction_id,
        transaction_date,
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name,
        transaction_qty * unit_price AS revenue_per_trans
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;


-- Processing the data to gain valuable insights
SELECT 
-- Dates
        transaction_date,
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name,
        -- date_format(transaction_time, 'HH:MM:SS') AS purchase_time,

        CASE
                WHEN Dayname(transaction_date) IN('Sun', 'Sat') THEN 'Weekend'
                ELSE 'Weekday'
        END AS day_classification, 

        CASE
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
                WHEN date_format(transaction_time, 'HH:MM:SS') >= '17:00:00' THEN '03. Evening'
        END AS time_buckets,


-- Counts of IDs
        COUNT(DISTINCT transaction_id) AS number_of_sales,
        COUNT(DISTINCT product_id) AS number_of_products,
        COUNT(DISTINCT store_id) AS number_of_stores,

-- Revenue
        SUM(transaction_qty * unit_price) AS revenue_per_day,

        CASE
                WHEN revenue_per_day <= 50 THEN '01. Low_Spend'
                WHEN revenue_per_day BETWEEN 51 AND 100 THEN '02. Mid-Spend'
                ELSE '03. High-Spend'
        END AS spend_buckets,

-- Categorical Columns
        store_location,
        product_category,
        product_detail
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`
GROUP BY transaction_date, 
         Dayname(transaction_date),
         Monthname(transaction_date),
         store_location,
         product_category,
         product_detail,
         date_format(transaction_time, 'HH:MM:SS');


-- 10. Combining functions to get a clean and enhanced dataset (Lerato)
SELECT transaction_id,
        transaction_date,
        transaction_time,
        transaction_qty,
        store_id,
        store_location,
        product_id,
        unit_price,
        product_category,
        product_type,
        product_detail,
-- Adding columns to enhance the table for better insights
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name,
        Dayofmonth(transaction_date) AS date_of_month,

        CASE
                WHEN Dayname(transaction_date) IN ('Sunday', 'Saturday') THEN 'Weekend'
                ELSE 'Weekday'
        END AS day_classification,

-- Adding the time buckets column
        CASE
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '05:00:00' AND '08:59:59' THEN '01. Rush Hour'
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:59' THEN '02. Mid Morning'
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
                WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '16:00:00' AND '18:59:59' THEN '04. Rush Hour'
                ELSE '05. Night'
        END AS time_classification,

-- Adding the Spend bucket column based on revenue
        CASE
                WHEN (transaction_qty * unit_price) <=50 THEN '01. Low spend'
                WHEN (transaction_qty * unit_price) BETWEEN 51 AND 200 THEN '02. Medium Spend'
                WHEN (transaction_qty * unit_price) BETWEEN 201 AND 300 THEN '03. Expensive'
                ELSE 'Highly Expensive'
        END AS spend_bucket, 

-- Therefore I have added 6 new columns to enhance the insights

-- Now I am adding a very significant column, the revenue
        transaction_qty * unit_price AS revenue

FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_analysis_case_study_1`;

