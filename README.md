# Olist E-commerce Sales & Customer Intelligence Analysis

E-commerce sales and customer intelligence analysis using PostgreSQL, Python, and Power BI.

## Project Overview

This project analyzes the Olist Brazilian e-commerce dataset to understand sales performance, customer behavior, and customer experience.

The analysis focuses on four business areas:

- Order and sales performance
- Product and category performance
- Customer retention and RFM segmentation
- Delivery and review experience

## Business Questions

- How much realized sales does the business generate from delivered orders?
- Which product categories contribute the most sales?
- How frequently do customers make repeat purchases?
- Which customer segments contribute the most sales?
- How does delivery performance relate to customer review scores?

## Methodology

### PostgreSQL
Used for data validation, cleaning checks, joins, and business analysis.

### Python
Used for exploratory data analysis and customer RFM segmentation.

RFM analysis uses:

- Recency — days since the customer's last purchase
- Frequency — number of delivered purchases
- Monetary — realized sales from delivered orders

Customer analysis uses `customer_unique_id` to represent individual customers.

### Power BI
Built a four-page analytical dashboard:

1. Order & Sales Analysis
2. Product Performance Analysis
3. Customer Intelligence Analysis
4. Customer Experience Analysis

## Key Findings

- Delivered orders generated approximately **R$15.42M in realized sales**.
- The delivery rate was approximately **97.02%**.
- The average order value was approximately **R$159.83**.
- Only approximately **3.00% of delivered-order customers were repeat customers**.
- The **Loyal** RFM segment generated the largest share of realized sales.
- Average delivery time was **12.56 days**.
- Approximately **8.11% of delivered orders were late**.
- Late deliveries were associated with substantially lower average review scores than on-time deliveries.

## Important Limitations

- The dataset does not contain sufficient cost information to calculate true profit or margin.
- Product IDs are anonymized, limiting product-level business interpretation.
- The delivery/review relationship is observational and should not be interpreted as causal.
- RFM segments are based on quintile-based scoring of the delivered-customer population.

## Repository Structure

```text
olist-ecommerce-analysis/
├── python/
│   ├── 01_eda.ipynb
│   └── rfm_customer_segments.csv
├── sql/
│   └── 01_data_validation.sql
├── powerbi/
└── README.md
