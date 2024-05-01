

/* Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF'
(Buy One Get One Free). This information will help us identify high-value products that are currently being heavily
discounted, which can be useful for evaluating our pricing and promotion strategies */ 

SELECT   p.[product_name] 
		,FORMAT(f.base_price, 'C', 'en-in') Base_Price 
		,f.promo_type as Promo_Type 
FROM	[dbo].[dim_products] p 
INNER JOIN [dbo].[fact_events] f on p.product_code  = f.product_code
WHERE f.base_price > 500 and f.promo_type = 'BOGOF' 
ORDER BY 2 DESC

/* Generate a report that provides an overview of the number of stores in each city. 
The results will be sorted in descending order of store counts, allowing us to identify the cities with 
the highest store presence. The report includes two essential fields: city and store count,
which will assist in optimizing our retail operations.
 */ 

 SELECT city, COUNT(distinct store_id) AS Store_CNT 
 FROM [dbo].[dim_stores]
 GROUP BY city 
 ORDER BY Store_CNT DESC 


 /* 3.	Generate a report that displays each campaign along with the total revenue generated before 
 and after the campaign? The report includes three key fields: campaign _name, total revenue(before_promotion), 
 total revenue(after_promotion). This report should help in evaluating the financial 
 impact of our promotional campaigns.  (Display the values in millions)
  */ 


SELECT 
     c.campaign_name as Campaign_Name
    ,FORMAT( SUM(f.base_price * f.[quantity_sold(before_promo)])/1000000, 'c', 'EN-IN') AS Revenue_Before_Campaign_Millions
    ,FORMAT(SUM(f.base_price * f.[quantity_sold(after_promo)])/1000000, 'C', 'EN-IN') AS Revenue_After_Campaign_Millions
FROM 
    [dbo].[fact_events] f 
INNER JOIN  
    [dbo].[dim_campaigns] c ON f.campaign_id = c.campaign_id
GROUP BY 
    c.campaign_name;


 /* Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category 
 during the Diwali campaign. Additionally, provide rankings for the categories based on their ISU%. 
 The report will include three key fields: category, isu%, and rank order.
 This information will assist in assessing the category-wise success 
 and impact of the Diwali campaign on incremental sales.
Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage
increase/decrease in quantity sold (after promo) compared to quantity sold (before promo)  */ 



WITH Incremental_Sold_Quantity_CTE AS (SELECT	c.campaign_name as CampaignName 
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
SELECT	Category
	   ,FORMAT (Incremental_Sold_Quantity / Quantity_Sold_before, 'P') AS 'ISU%'
	   ,RANK() OVER(ORDER BY Incremental_Sold_Quantity / Quantity_Sold_before DESC) AS rank 
FROM Incremental_Sold_Quantity_CTE




/*Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%),
 across all campaigns. The report will provide essential information including product name, 
 category, and ir%. This analysis helps identify the most successful products in terms
 of incremental revenue across our campaigns, assisting in product optimization.
  */ 

   


SELECT	TOP 5 Product_Name
		,category
		,FORMAT(IR/Revenue_Before_Campaing , 'p') as 'IR%' 
		,ROW_NUMBER() over(order by  IR/Revenue_Before_Campaing DESC ) Rank 
FROM( SELECT  c.campaign_name
			   , P.[product_name] as Product_Name 
			   , p.category
			   ,sum(f.base_price * f.[quantity_sold(before_promo)]	) AS Revenue_Before_Campaing
			   ,sum (f.base_price * f.[quantity_sold(after_promo)]) AS Revenue_After_Campaing 
			   ,sum ((f.base_price * f.[quantity_sold(after_promo)]) - (f.base_price * f.[quantity_sold(before_promo)]))
			   as 'IR' 
	   	FROM    [dbo].[fact_events] f 
		inner join [dbo].[dim_products] p  on p.product_code = f.product_code 
		inner join [dbo].[dim_campaigns] c on c.campaign_id = f.campaign_id 
		group by p.product_name, c.campaign_name , p.category) as query 
