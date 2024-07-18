# Promotional Campaign Performance Analysis

## Table of Contents 
- [Project Overview](project-overview)
- [Business and Data Intelligence Initiative](business-and-data-intelligence-initiative)
- [Data Source](data-source)
- [Tools](tools)
- [Data Cleaning/Preparation](data-cleaning/preparation)
- [Exploratory Data Analysis](exploratory-data-analysis)
- [Data Analysis](data-analysis)
- [Results](results)
- [Recommandations](recommandations)

### Project Overview: -
The project aims to evaluate the effectiveness of promotions conducted by ATLIQ Mart, a prominent retail chain operating over 50 supermarkets in southern India. Its primary objectives include assessing promotion performance, providing actionable recommendations, and ensuring that promotional strategies align with organiSational objectives.

![image](https://github.com/AxmedGabtan/Analysis-of-Promotional-Campaigns-with-Actionable-Insights/assets/121066015/79bdc716-76e1-42a6-81e7-fd4c9fa21116)



### Business and Data Intelligence Initiative: - 
This data analysis project aims to review the promotional performance, providing insights that will shape the future of sales strategies at AtliQ Mart.

### Data Source
The dataset was downloaded from Codebasics challenge #9 as CSV files, containing detailed information about Atliq marts' massive promotion during the Diwali 2023 and Sankranti 2024 (festive time in India) on their AtliQ branded products. [Dowload here](https://codebasics.io/challenge/codebasics-resume-project-challenge)
### Tools 
- SQL Server - Cleaning / Data Analysis 
- Power BI  - Creating Reports

### Data Cleaning / Preparation 
The initial data preparation phase, we performed following tasks 
1. Data Exploration: Understand dataset structure, contents, and potential issues.
2. Data Profiling: Identify data types, distributions, missing values, and anomalies for cleaning or preprocessing.
3. Data Sampling: Extract a representative subset for initial analysis and testing of cleaning procedures.
4. Data Documentation Review: Review metadata to grasp dataset structure, meaning, and potential quality issues prior to cleaning

### Exploratory Data Analysis
EDA utiliSed promotional data to investigate some of these inquiries.

- Which are the top 10 stores in terms of Incremental Revenue (IR) generated from the promotions?
- Is there a significant difference in the performance of discount-based promotions versus BOGOF (Buy One Get One Free) or cashback promotions?
- Which product categories saw the most significant lift in sales from the promotions?
  
### Data Analysis 
``` SQL
WITH Incremental_Sold_Quantity_CTE AS (
      SELECT
            c.campaign_name as CampaignName 
           ,p.category as Category
           ,SUM(f.[quantity_sold(before_promo)]) AS Quantity_Sold_before 
	   ,SUM(f.[quantity_sold(after_promo)]) AS quantity_Sold_after
	   ,SUM(f.[quantity_sold(after_promo)]-f.[quantity_sold(before_promo)]) AS Incremental_Sold_Quantity
   FROM [dbo].[fact_events] f
   INNER JOIN [dbo].[dim_products] p ON p.product_code = f.product_code 
   INNER JOIN [dbo].[dim_campaigns] c ON c.campaign_id = f.campaign_id
   WHERE c.campaign_name = 'Diwali'	  
   GROUP BY  p.category, c.campaign_name 
)
SELECT
      Category
     ,FORMAT (Incremental_Sold_Quantity / Quantity_Sold_before, 'P') AS 'ISU%'
     ,RANK() OVER(ORDER BY Incremental_Sold_Quantity / Quantity_Sold_before) AS rank 
FROM Incremental_Sold_Quantity_CTE
ORDER BY 3 DESC

```



### Findings 
1. Promotions such as BOGOF (Buy One Get One Free) and the $500 Cashback offer demonstrate significant effectiveness in boosting incremental sales volume.
2. Discount-based promotions like 33% OFF and 50% OFF also have a positive impact on sales, although they may require a more targeted approach.
3. The 25% OFF promotion may require adjustments to enhance its effectiveness in driving sales volume.
4. The top two performers belong to the Home Appliances category, with the third and fourth coming from the Home Care category, and the fifth from Combined Category 1
5. The top 10 performing stores are distributed across Bengaluru, Chennai, and Mysuru, with Bengaluru leading in Incremental Revenue (IR) at 50M, followed by Chennai at 40M, and Mysuru at 18M. Despite Hyderabad's higher IR compared to Mysuru by 12M, none of its seven stores rank among the top performers, indicating underperformance.

### Recommandation 
1. Maintain BOGOF and Cashback offers for their significant sales impact.
2. Tailor discount promotions for targeted customer segments.
3. Adjust 25% OFF promotion for improved sales performance.
4. Focus resources on high-performing categories and regions.
5. Implement targeted strategies to improve underperforming stores.
















