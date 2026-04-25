# Bank_Analysis

# 🏦 Bank Service & Transaction Analysis

## 🎓 Project Context
This project was developed as a final course project for the **Database and Data Mining** course during the **"Digital Pioneers Initiative - مبادرة الرواد الرقميون"**, under the supervision of **Dr. Mohamed Sobhy**.

## Project Presentation
https://bank-ai-show.lovable.app/

## Live Demo
https://esraamahmoud09.github.io/Bank_Analysis/


## 📌 Project Overview

This project delivers a comprehensive, data-driven analysis of banking operations, focusing on **customer demographics**, **transaction behavior**, and **service status optimization**.

By combining **Exploratory Data Analysis (EDA)** and **Machine Learning techniques**, the analysis uncovers key drivers behind service outcomes and transaction patterns, helping improve decision-making and operational efficiency.

---

## 📊 Business Insights & Key Findings

### 1️⃣ Service Performance

* **Service Distribution:**
  *Bill Payment* dominates service requests (~83%), followed by Loans and Insurance services.

* **Service Status Tracking:**
  A large portion of services are still **In Progress (42.5%)**, while **Rejected services account for ~13.4%**, indicating potential inefficiencies in processing or eligibility criteria.

* **Customer Demographics:**
  The **Senior age group** shows the highest engagement with banking services compared to Young Adults and Middle-Aged customers.

---

### 2️⃣ Transaction Patterns

* **Transaction Medium:**
  Cash is the most commonly used payment method (**55.7%**), followed by Credit Cards (**25.4%**).

* **Transaction Type Distribution:**
  **Balance Inquiries (42.3%)** are the most frequent transactions, reflecting high customer interest in monitoring account activity.

---

### 3️⃣ Geographical Insights

* The **Chicago Branch** is the main operational hub, handling approximately **75.5% of total activity**, indicating a strong regional concentration.

---

## 🤖 Machine Learning Insights

### 🔍 Feature Importance (Random Forest Model)

The model identifies the most influential features affecting **Service Status**:

* **Service_Amount** → Strongest predictor
* **Customer_Name & Age** → Key demographic factors
* **Balance** → Indicator of financial eligibility

---

### 📈 Correlation Analysis

A detailed **Correlation Heatmap** is used to:

* Identify relationships between numerical and encoded variables
* Detect and reduce **multicollinearity**
* Highlight important features such as:

  * `Service_Amount_Log`
  * `Transaction_Amount`

---

## 🛠️ Tech Stack

* **Python** → Core programming language
* **Pandas & NumPy** → Data cleaning & feature engineering
* **Matplotlib & Seaborn** → Data visualization & heatmaps
* **Scikit-learn** → Machine learning modeling & evaluation

---

## 🎯 Project Objectives

* Understand customer behavior and service usage patterns
* Improve service approval and processing efficiency
* Identify key factors influencing banking operations
* Support data-driven decision-making in financial services

---

## 🚀 Future Enhancements

* Deploy model as an API for real-time predictions
* Build interactive dashboards using Power BI or Streamlit
* Apply advanced models (XGBoost, Neural Networks)
* Incorporate time-series analysis for transaction forecasting

---

## 👥 Team Members

| Name | Responsibility | Role |
| :--- | :--- | :--- |
| **Hayam Medhat Wahdan** | Report Implementation + Bank System | **Team Leader** |
| Hoda Mohamed Ezzat | Data Integration + Database Implementation | Member |
| Nada Fahmy Fahmy | SQL Questions + ER Diagram | Member |
| Esraa Mohamed Attia | EDA + Python Scripts | Member |
| Esraa Shawky Mahmoud | EDA + Orange Data Mining | Member |

---

## 📬 Contact

If you have any questions or suggestions, feel free to reach out or open an issue.

📧 **Email:** [hayamm.wahdan@gmail.com](mailto:hayamm.wahdan@gmail.com)  
🔗 **LinkedIn:** [Hayam Wahdan](https://www.linkedin.com/in/hayamwahdan/)

📧 **Email:** [huda.elhamahmy@gmail.com](mailto:huda.elhamahmy@gmail.com)  
🔗 **LinkedIn:** [Hoda Elhamahmy](https://www.linkedin.com/in/hoda-elhamahmy1/)


📧 **Email:** [nada.fahmy2244@gmail.com](mailto:nada.fahmy2244@gmail.com)  
🔗 **LinkedIn:** [Nada Fahmy](www.linkedin.com/in/nada-fahmy-)


---

✨ *This project demonstrates practical application of data analysis and machine learning in the banking domain.*
