--Query 1: Customer ratings changed overtime:
            --Uses inner join from customer’s details to stream data 
            --Query gives us an overall picture of the fluctuations in customer ratings
            --It also helps in making strategic decisions about the future content depending on the most liked or viewed content by an individual customer


SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, C.EMAIL_ID, 
  S.STREAM_DATE,S.STREAM_RATING,J.TITLE
FROM CUSTOMER C,STREAMS S,CONTENT J  
WHERE C.CUSTOMER_ID = S.CUSTOMER_ID AND S.CONTENT_ID = J.CONTENT_ID
ORDER BY C.CUSTOMER_ID, S.STREAM_DATE DESC;


--Query 2: Trends of Streams
           --Uses left outer join between content and streams, to display the trend of streams, details of content and customer details
           --Helps Netflix to discontinue content not being watched by its user base

SELECT C.CONTENT_ID, S.STREAM_ID, S.CUSTOMER_ID, S.STREAM_DATE, 
  S.STREAM_TIME , C.RELEASE_DATE
FROM CONTENT C LEFT OUTER JOIN STREAMS S ON S.CONTENT_ID = C.CONTENT_ID
ORDER BY S.STREAM_ID DESC;


--Query 3: Average Rating of the Content
           --Query to display title, episode and the average ratings of each content to analyze the performance of each content in the company’s database
           --Helps Netflix to consider which content streaming should be discontinued based on avearge rating


SELECT C.TITLE,C.EPISODE,ROUND(AVG(S.STREAM_RATING),2) AS AVERAGERATING
FROM CONTENT C,STREAMS S
WHERE C.CONTENT_ID = S.CONTENT_ID
GROUP BY C.TITLE,C.EPISODE;


--Query 4: Content Acquisition  
           --Uses right outer join to display the Title, Percentage view, Customer amount and Content cost
           --The percentage view gives the percentage of customers viewing a content. The percentage viewis restricted to less than 10% of total customers. 
           --Customer amount calculated is the total amount Netflix receives from customers watching the content. The content cost is calculated as a product of cost_per_stream and episodes columns. This gives the total amount invested by Netflix to acquire a content
           --Help Netflix analyze if the investment on content acquired is worth it by comparing customer amount with content cost

SELECT C.TITLE,COUNT(CU.CUSTOMER_ID)/100 AS "PERCENTAGE_VIEW",
   SUM(replace(I.TOTAL,'Rs.','')) AS CUSTOMER_AMOUNT,
   SUM(cast(replace(C.cost_per_stream,'Rs','') as decimal(8,2))) as CONTENT_COST
FROM CONTENT C,INVOICE I, CUSTOMER CU RIGHT OUTER JOIN STREAMS S ON 
   S.CUSTOMER_ID = CU.CUSTOMER_ID
WHERE C.CONTENT_ID = S.CONTENT_ID AND I.CUSTOMER_ID = CU.CUSTOMER_ID
GROUP BY C.TITLE,C.cost_per_stream
HAVING COUNT(CU.CUSTOMER_ID)/100  < 0.1
ORDER BY "PERCENTAGE_VIEW" DESC;


--Query 5: Content Popularity 
           --Query displays movie or show title available in each country and the number of streams
           --Helps Netflix understand which content they need to keep to satisfy their customers
           --Location was taken into consideration as specific content may be popular in certain countries but not in others

SELECT C.STATE, T.TITLE, COUNT(S.STREAM_ID) AS "VIEWS FOR EACH CONTENT FOR EACH STATE"
FROM STREAMS S, CUSTOMER C, CONTENT T
WHERE C.CUSTOMER_ID = S.CUSTOMER_ID AND T.CONTENT_ID = S.CONTENT_ID
GROUP BY C.STATE, S.CONTENT_ID, T.TITLE
ORDER BY C.STATE, COUNT(S.STREAM_ID) DESC;