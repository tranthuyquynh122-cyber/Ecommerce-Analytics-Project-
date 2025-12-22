# Ecommerce Analytics Project (SQL – BigQuery)

## 📌 Project Overview
This project analyzes **e-commerce user behavior and sales performance** using **SQL on Google BigQuery**, based on the **Google Analytics Sample Dataset**.

The goal is to answer key **business and marketing questions**, including traffic quality, conversion behavior, revenue contribution, and product association patterns.

This project demonstrates practical **SQL analytics skills** and the ability to translate data into **business insights**.


## 🛠 Tools & Technologies
- SQL (Standard SQL)
- Google BigQuery
- Google Analytics Sample Dataset

**Key techniques applied:**
- Common Table Expressions (CTEs)
- EXISTS / NOT EXISTS
- CASE WHEN logic
- Aggregation & filtering

## 📂 Dataset
- **Source:** `bigquery-public-data.google_analytics_sample`
- **Main table:** `ga_sessions_2017`
- **Time period:** January – July 2017


## 📈 Business Questions & Analysis

### 1. Traffic & Engagement Trend
- Total visits, pageviews, and transactions by month
- Identify changes in user activity over time

### 2. Bounce Rate by Traffic Source
- Evaluate traffic quality across acquisition channels
- Rank sources by total visits and bounce rate

### 3. Revenue Performance by Time
- Revenue by traffic source on:
  - Monthly level
  - Weekly level
- Compare revenue contribution across time dimensions

### 4. Conversion Rate Analysis
- Conversion rate = Transactions / Visits
- Filtered to include only meaningful traffic sources

### 5. Purchaser vs Non-Purchaser Behavior
- Average pageviews for:
  - Purchasers
  - Non-purchasers
- Identify engagement differences leading to conversion

### 6. Purchasing Intensity
- Average number of transactions per purchasing user
- Measure customer purchasing behavior

### 7. Revenue Contribution by Device
- Revenue share by device category:
  - Desktop
  - Mobile
  - Tablet
- Support device-based optimization strategies

### 8. Product Association Analysis
- Identify products frequently purchased together
- Provide insights for cross-selling opportunities


## 💡 Key Insights
- High traffic volume does not always correlate with high conversion
- Purchasers show significantly higher engagement than non-purchasers
- Desktop users contribute the largest share of revenue
- Product association analysis highlights cross-selling potential


## 📌 Key Learnings
- Handling nested and repeated fields in BigQuery
- Avoiding data duplication using EXISTS instead of direct joins
- Writing clean, modular, and scalable SQL queries
- Converting analytical outputs into business-ready insights


## 📁 Project Files
- `DAC K37 - Tran Thuy Quynh (Final).sql`  
  → Contains all SQL queries used in this analysis


## 🚀 Conclusion
This project reflects a **job-ready SQL analytics workflow**, demonstrating the ability to:
- Analyze real-world e-commerce data
- Apply SQL to solve business problems
- Communicate insights clearly for business stakeholders
