# 📊 E-commerce Traffic & Behavior Analysis using Google Analytics Data | SQL (BigQuery)

**Business Question:**  
How do user traffic, engagement, and purchasing behavior evolve over time, and how can businesses optimize marketing and conversion performance?

**Domain:** E-commerce / Digital Marketing Analytics  
**Tools Used:** SQL (Google BigQuery)  

Author: Your Name  
Date: 2017-XX-XX  

---

## 📑 Table of Contents

1. 📌 [Background & Overview](#background--overview)  
2. 📂 [Dataset Description & Data Structure](#dataset-description--data-structure)  
3. 📊 [Final Conclusion & Recommendations](#final-conclusion--recommendations)

---

## 📌 Background & Overview  

### 📖 Project Objective  

This project analyzes **e-commerce website traffic and user behavior** using the Google Analytics Sample Dataset available on BigQuery. The goal is to understand how users interact with the website across different time periods, traffic sources, and purchase stages, and to extract actionable insights that help improve **conversion performance and revenue generation**.

Specifically, this project aims to:

✔️ Measure traffic volume and engagement trends over time  
✔️ Analyze bounce rate across different traffic sources  
✔️ Understand revenue contribution by channel and by time  
✔️ Compare behavior between purchasers and non-purchasers  
✔️ Evaluate the conversion funnel from product view → add to cart → purchase  
✔️ Identify cross-sell opportunities from product co-purchase behavior  

---

### 👤 Who is this project for?

This project is designed for:

✔️ Data Analysts / Business Analysts  
✔️ Marketing Analysts  
✔️ Growth & Performance teams  
✔️ E-commerce stakeholders  
✔️ Hiring managers reviewing analytics portfolios  

---

## 📂 Dataset Description & Data Structure  

### 📌 Data Source  

- **Source:** Google Analytics Sample Dataset (BigQuery Public Dataset)  
- **Dataset name:** `bigquery-public-data.google_analytics_sample`  
- **Format:** BigQuery tables  
- **Time period analyzed:** January – July 2017  

---

## 📊 Data Structure & Relationships  

### 1️⃣ Tables Used  

This project uses **one primary table** from the dataset:

- `ga_sessions_2017*`

This table contains session-level Google Analytics data with nested structures that capture user behavior, traffic source information, and ecommerce interactions.

---

### 2️⃣ Table Schema & Data Snapshot  

👉 *(Insert screenshot of table schema here — only include columns used in the analysis)*  

📌 If the table is too large, only capture key columns related to traffic, engagement, and ecommerce metrics.

---

### Key Columns Used

| Column Name | Description |
|------------|-------------|
| fullVisitorId | Unique identifier for each user |
| date | Session date (YYYYMMDD) |
| totals.visits | Number of visits |
| totals.pageviews | Number of page views |
| totals.transactions | Number of transactions |
| totals.bounces | Bounce indicator |
| trafficSource.source | Traffic acquisition source |
| hits | Nested hit-level records |
| hits.eCommerceAction.action_type | User action type (view, add-to-cart, purchase) |
| product.productRevenue | Revenue per product (stored in micros) |
| product.productQuantity | Quantity purchased |
| product.v2ProductName | Product name |

---

### 🔎 Notes on Data Structure  

- The dataset uses a **nested schema**:
  - One user → multiple sessions  
  - Each session → multiple hits  
  - Each hit → optional product-level data  

- Nested fields are flattened using `UNNEST()` during analysis.

- Revenue values are stored in **micro-units**, so they must be divided by `1,000,000` to convert to standard currency.

- Time filtering is applied using `_TABLE_SUFFIX`.

- Ecommerce actions are encoded as:
  - `2` → Product View  
  - `3` → Add to Cart  
  - `6` → Purchase  


## ⚒️ Main Process

### 1️⃣ Data Cleaning & Preprocessing  

Before performing any analysis, the raw Google Analytics data must be cleaned and transformed to ensure accuracy and consistency. Since the dataset contains nested structures and raw event-level records, preprocessing is required before meaningful aggregation.

The following data preparation steps were applied:

- Filtered data by specific time ranges using `_TABLE_SUFFIX`
- Parsed `date` from string format (`YYYYMMDD`) into a usable date format
- Flattened nested fields (`hits`, `hits.product`) using `UNNEST()`
- Removed records with null revenue when analyzing purchase behavior
- Converted revenue values from micro-units to standard currency
- Aggregated data at appropriate levels (user, session, month, week)
- Ensured no double counting when working with nested records

These steps ensure that all metrics used in later analysis are reliable, consistent, and correctly aggregated.

---

## 🔍 Exploratory Data Analysis (EDA)

EDA is used to understand traffic behavior, engagement patterns, and purchasing activities before drawing business conclusions. This section explores how users interact with the website from different perspectives such as time, traffic source, and purchase behavior.

---

### ✅ Task 1: Monthly Traffic Overview (Jan–Mar 2017)

**Purpose & Business Meaning**

This task analyzes overall website activity over time by measuring visits, pageviews, and transactions on a monthly basis. Understanding traffic trends helps stakeholders evaluate seasonality, campaign performance, and general user engagement.

A stable or growing trend may indicate healthy acquisition performance, while fluctuations may suggest campaign effects or external influences.

**Metrics analyzed:**
- Total visits  
- Total pageviews  
- Total transactions  

📌 <img width="886" height="233" alt="image" src="https://github.com/user-attachments/assets/b353c9b5-c50d-45db-940b-29bd973149a3" />


**Key observations:**
- Traffic and engagement fluctuate across months.
- Helps identify seasonal or campaign-driven patterns.
- Provides baseline KPIs for deeper funnel analysis.

---

### ✅ Task 2: Bounce Rate by Traffic Source (July 2017)

**Purpose & Business Meaning**

Bounce rate represents the percentage of sessions in which users leave the website after viewing only one page. A high bounce rate may indicate poor traffic quality, irrelevant landing pages, or unmet user expectations.

Analyzing bounce rate by traffic source helps identify which acquisition channels bring high-quality users versus low-engagement traffic.

**Metric definition:**



## 📊 Final Conclusion & Recommendations  

### 📍 Key Insights  

✔️ High traffic volume alone does not guarantee high revenue — engagement quality plays a critical role.  

✔️ Bounce rate varies significantly across traffic sources, reflecting differences in traffic quality and landing page relevance.  

✔️ Purchasers consistently show higher engagement (pageviews) than non-purchasers.  

✔️ Revenue contribution differs substantially across acquisition channels and time periods.  

✔️ Conversion funnel analysis reveals clear drop-offs between product view, add-to-cart, and purchase stages.  

✔️ Product co-purchase behavior uncovers strong opportunities for cross-selling and bundling strategies.  

---

### ✅ Business Recommendations  

1. **Optimize low-quality traffic sources**  
   Improve targeting, messaging, and landing page relevance for channels with high bounce rates.

2. **Prioritize high-performing acquisition channels**  
   Allocate marketing budget toward sources that consistently generate higher revenue rather than high traffic volume alone.

3. **Improve on-site engagement and navigation**  
   Enhance internal search, category structure, and product discovery to increase page depth.

4. **Reduce funnel friction**  
   Optimize product detail pages, add-to-cart flow, and checkout experience to minimize drop-offs.

5. **Apply cross-selling and bundling strategies**  
   Use product co-purchase insights to recommend related items and increase average order value.

---

✅ *This project demonstrates strong SQL querying skills, structured analytical thinking, and the ability to translate raw web analytics data into actionable business insights.*
