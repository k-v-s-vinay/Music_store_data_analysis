# 🎶 Music Store Data Analysis (SQL Project)

## 📌 Overview
This project demonstrates how SQL can be applied to a **real-world music store dataset** to uncover business insights.  
It covers database design, data import, and analytical queries that answer practical business questions such as customer behavior, revenue trends, and genre popularity.

---

## 🎯 Objectives
- Design and implement a relational database schema with proper constraints.
- Import and validate large datasets (CSV files).
- Apply SQL concepts: **joins, subqueries, aggregations, CTEs, views, triggers, and window functions**.
- Generate insights that help identify customer behavior, revenue trends, and music preferences.

---

## 🗂️ Database Schema
The database includes the following tables:
- **Employee**
- **Customer**
- **Invoice**
- **InvoiceLine**
- **Track**
- **Album**
- **Artist**
- **Genre**
- **MediaType**
- **Playlist**
- **PlaylistTrack**

Relationships:
- Customers → Invoices (one-to-many)  
- Invoices → InvoiceLines (one-to-many)  
- Tracks → Albums → Artists (hierarchical)  
- Tracks → Genre & MediaType (categorical)  

---

## 🔑 Key Analysis Questions
1. Who is the senior-most employee based on job title?  
2. Which countries have the most invoices?  
3. What are the top 3 invoice totals?  
4. Which city has the best customers (highest revenue)?  
5. Who is the best customer globally?  
6. List all Rock music listeners with their email and names.  
7. Top 10 artists with the most Rock tracks.  
8. Tracks longer than the average song length.  
9. Amount spent by each customer on artists.  
10. Most popular genre per country.  
11. Top customer per country based on spending.

---

## 📊 Insights
- **Revenue Trends**: Certain countries and cities dominate sales → useful for promotional strategies.  
- **Customer Insights**: Identified best customers globally and per country → loyalty programs.  
- **Genre Trends**: Rock emerged as a highly popular genre → artist collaborations.  
- **Track Analysis**: Longer tracks and high-value invoices highlight premium offerings.  

---

## ⚙️ Technologies Used
- **SQL** (MySQL / PostgreSQL compatible)
- **Database Design** (constraints, foreign keys, schema validation)
- **Advanced SQL Features**: CTEs, Views, Window Functions, Triggers

---

## 🚀 How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/k-v-s-vinay/Music_store_data_analysis.git
