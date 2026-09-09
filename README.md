# Olist E-Commerce Data Analysis

## Project Overview

This project analyzes the Olist Brazilian E-Commerce dataset to uncover insights into sales performance, customer behavior, product performance, payments, delivery operations, and customer satisfaction.

The project follows an end-to-end data analytics workflow using Python, SQL, and Power BI.

## Tools & Technologies

- Python
  - Pandas
  - NumPy
  - Matplotlib
  - Seaborn
  - SciPy
  - Scikit-learn
- SQL
- Power BI
- DAX
- Jupyter Notebook
- GitHub

## Project Workflow

Raw Data
↓
Data Cleaning
↓
Exploratory Data Analysis
↓
Statistical Analysis
↓
SQL Business Analysis
↓
Power BI Dashboard
↓
Business Insights

## Data Cleaning & EDA

Python was used to:

- Handle missing values
- Convert data types
- Standardize inconsistent text values
- Clean product categories
- Clean geographical data
- Convert date columns
- Analyze distributions and outliers
- Perform exploratory data analysis
- Perform statistical analysis including ANOVA, Chi-Square, ACF/PACF, and PCA

Notebook:

`python/olist_data_cleaning_and_eda.ipynb`

## SQL Analysis

SQL was used to answer business questions related to:

- Overall sales performance
- Monthly revenue
- Product category performance
- Top-selling products
- Customer distribution
- Repeat customers
- Payment methods
- Order status
- Seller performance
- Customer reviews
- Delivery performance
- Revenue growth

SQL queries:

`sql/olist_analysis.sql`

## Power BI Dashboard

The Power BI report contains three pages:

### Page 1 — Executive Sales Overview

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Average Review Score
- Monthly Revenue Trend
- Revenue by Product Category
- Orders by Order Status
- Revenue by Customer State

### Page 2 — Customer & Product Analysis

- Customers by State
- Average Product Price by Category
- Payment Type Distribution
- Payment Value by Payment Type

### Page 3 — Operations & Customer Experience

- Average Delivery Days
- Late Delivery %
- Average Review Score
- Cancellation Rate
- Average Delivery Days by State
- Late vs On-Time Orders
- Review Score Distribution
- Average Review Score by Product Category
- Delivery Time Trend

The `.pbix` file is hosted externally because of GitHub file-size limitations.

[Download Power BI Dashboard](https://drive.google.com/file/d/1YWpcEBcRcmfxkgt70b5E3xFjq3gw1b9J/view?usp=drive_link)

## Dashboard Preview

### Executive Sales Overview

![Executive Sales Overview](Screenshots/page1_executive_overview.png)

### Customer & Product Analysis

![Customer & Product Analysis](Screenshots/page2_customer_product.png)

### Operations & Customer Experience

![Operations & Customer Experience](Screenshots/page3_operations.png)

## Key Business Questions

This project answers questions such as:

1. How is revenue changing over time?
2. Which product categories generate the most revenue?
3. Which states contribute the most customers and revenue?
4. What are the most commonly used payment methods?
5. How many customers are repeat customers?
6. Which sellers generate the highest revenue?
7. What percentage of orders are delivered late?
8. Which states have the longest delivery times?
9. How does delivery performance affect customer reviews?
10. What is the overall customer satisfaction level?

## Repository Structure

```text
Olist-Ecommerce-Analysis/
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── python/
│   └── olist_data_cleaning_and_eda.ipynb
│
├── sql/
│   └── olist_analysis.sql
│
├── powerbi/
│   └── README.md
│
├── screenshots/
│   ├── page1_executive_overview.png
│   ├── page2_customer_product.png
│   └── page3_operations.png
│
└── README.md
