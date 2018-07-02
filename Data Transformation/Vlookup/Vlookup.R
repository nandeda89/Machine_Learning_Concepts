First_order <- read.csv("First_Order_Csv.csv")
Latest_order <- read.csv("Latest_Order_Csv.csv")

head(First_order)
head(Latest_order)

#Merge All Columns
Combined_Latest_order = merge(Latest_order, First_order[,c("orderno","ORDER_ID")],
                             all.x =  TRUE,by.x = "orderno", by.y = "orderno")

#Merge All Columns from table 1 and selected columns from table 2
Combined_Latest_order = merge(Combined_data, First_order[,c("orderno","ORDER_ID","total")],
                              all.x =  TRUE,by.x = "orderno_1", by.y = "orderno")

write.csv(Combined_First_order, abc.csv", row.names = FALSE)

# Scenario 	 	Merge Parameters
# Keep rows where there's a match in both 	- 	      N/A. This is default
# Keep all rows from x, regardless of match in y 	-   all.x = TRUE
# Keep all rows from y, regardless of match in x 	-   all.y = TRUE
# Keep all rows from x AND from y 	                  all = TRUE