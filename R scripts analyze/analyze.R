library(tidyverse)

original_tripdata_2024 <- read_csv("C:/Users/there/Documents/Certifications/Google Data Analytics Professional Certificate/Case Study - Cyclistic/divvy_tripdata_2024_full_year.csv")
spec(original_tripdata_2024)
glimpse(original_tripdata_2024)

library(dplyr)

avg_ride_length_member <- original_tripdata_2024 %>%
                          filter(member_casual == "member") %>%
                          summarise(avg = mean(trip_duration, na.rm = TRUE)) %>%
                          pull(avg)
avg_ride_length_casual <- original_tripdata_2024 %>%
                          filter(member_casual == "casual") %>%
                          summarise(avg = mean(trip_duration, na.rm = TRUE)) %>%
                          pull(avg)

library(ggplot2)
library(plotrix)


#Total Rides by Member Type
count_rides_by_member_type <- original_tripdata_2024 %>%
                              count(member_casual)
counts <- count_rides_by_member_type$n
labels <- count_rides_by_member_type$member_casual
percentages <- round(counts/sum(counts)*100, 1)
labels_with_percentages <- paste0(labels, " (", percentages, "%)")
colors <- c("#1081eb", "#f58507")
pie3D(counts, labels = labels_with_percentages, explode = 0.05, main = "Total Rides by Member Type", radius = 1, height = 0.1, theta = 0.8, border = "white", col = colors)


#Distribution of trip duration
filtered_data_casual <- original_tripdata_2024 %>%
                  filter(member_casual == "casual")
filtered_data_member <- original_tripdata_2024 %>%
                  filter(member_casual == "member")
ggplot(filtered_data_casual, aes(x = trip_duration)) + geom_histogram(binwidth = 0.5, fill = "#1081eb", color = "#1081eb", alpha = 0.8) + labs(y = "Count", x = "Trip Duration", title = "Distribution of Trip Duration for Casual Riders")
ggplot(filtered_data_member, aes(x = trip_duration)) + geom_histogram(binwidth = 0.5, fill = "#f58507", color = "#f58507", alpha = 0.8) + labs(y = "Count", x = "Trip Duration", title = "Distribution of Trip Duration for Member Riders")

ggplot(mapping = aes(x = trip_duration)) +
  geom_histogram(
    data = filtered_data_member,
    aes(fill = "member"),
    binwidth = 0.5,
    position = "identity",
    alpha = 0.4
  ) +
  geom_histogram(
    data = filtered_data_casual,
    aes(fill = "casual"),
    binwidth = 0.5,
    position = "identity",
    alpha = 0.4
  ) +
  scale_fill_manual(
    name = "Rider Type",
    values = c("member" = "#f58507", "casual" = "#1081eb"),
  ) +
  labs(
    y = "Count",
    x = "Trip Duration",
    title = "Distribution of Trip Duration for Member and Casual Riders"
  )



#Analysis of Routes
routes_ordered_by_popularity_and_member_type <- original_tripdata_2024 %>%
                                                mutate(
                                                  route = if_else(
                                                    start_station_name < end_station_name,
                                                    paste(start_station_name, end_station_name, sep = " <-> "),
                                                    paste(end_station_name, start_station_name, sep = " <-> ")
                                                  )
                                                ) %>%
                                                group_by(route, member_casual) %>%
                                                summarise(num_rides = n()) %>%
                                                arrange(desc(num_rides))

top_routes <- routes_ordered_by_popularity_and_member_type %>%
              group_by(route) %>%
              summarise(total_rides = sum(num_rides)) %>%
              slice_max(total_rides, n = 10)

routes_percent <- routes_ordered_by_popularity_and_member_type %>%
                  group_by(route) %>%
                  mutate(rides_pct = 100 * (num_rides/sum(num_rides))) %>%
                  ungroup()

routes_percent_top10 <- routes_percent %>%
                        semi_join(top_routes, by = "route")

ggplot(routes_percent_top10, aes(x = route, y = rides_pct, fill = member_casual)) +
  geom_col(position = "fill") +
  coord_flip() +
  labs(
    title = "Relative Popularity of Routes by Rider Type (Top 10 Overall Routes)",
    x = "Route",
    y = "Percentage of Rides"
  ) +
  scale_fill_manual(values = c("member" = "#f58507", "casual" = "#1081eb")) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 25))

top_routes_with_majority_casual <- routes_percent %>%
                                filter(rides_pct > 75.0, num_rides > 500)


#Types of Rides by Member Type
count_member_classicbike <- filtered_data_member %>%
                            filter(rideable_type == "classic_bike") %>%
                            nrow()
count_member_electricbike <- filtered_data_member %>%
                              filter(rideable_type == "electric_bike") %>%
                              nrow()
count_member_electricscooter <- filtered_data_member %>%
                              filter(rideable_type == "electric_scooter") %>%
                              nrow()
count_casual_classicbike <- filtered_data_casual %>%
                            filter(rideable_type == "classic_bike") %>%
                            nrow()
count_casual_electricbike <- filtered_data_casual %>%
                              filter(rideable_type == "electric_bike") %>%
                              nrow()
count_casual_electricscooter <- filtered_data_casual %>%
                                filter(rideable_type == "electric_scooter") %>%
                                nrow()
#####
tempcounts <- c(count_casual_classicbike, count_member_classicbike)
templabels <- c("Casual", "Member")
temppct <- round(tempcounts/sum(tempcounts)*100, 1)
templabels_with_pct <- paste0(templabels, " (", temppct, "%)")
 
pie3D(
  tempcounts, 
  labels = templabels_with_pct, 
  explode = 0.05, 
  main = "Proportion of Types of Classic Bike Riders", 
  radius = 1, 
  height = 0.1, 
  theta = 0.8, 
  border = "white", 
  col = colors
  )


######
tempcounts <- c(count_casual_electricbike, count_member_electricbike)
templabels <- c("Casual", "Member")
temppct <- round(tempcounts/sum(tempcounts)*100, 1)
templabels_with_pct <- paste0(templabels, " (", temppct, "%)")

pie3D(
  tempcounts, 
  labels = templabels_with_pct, 
  explode = 0.05, 
  main = "Proportion of Types of Electric Bike Riders", 
  radius = 1, 
  height = 0.1, 
  theta = 0.8, 
  border = "white", 
  col = colors
 )


######
tempcounts <- c(count_casual_electricscooter, count_member_electricscooter)
templabels <- c("Casual", "Member")
temppct <- round(tempcounts/sum(tempcounts)*100, 1)
templabels_with_pct <- paste0(templabels, " (", temppct, "%)")

pie3D(
  tempcounts, 
  labels = templabels_with_pct, 
  explode = 0.05, 
  main = "Proportion of Types of Electric Scooter Riders", 
  radius = 1, 
  height = 0.1, 
  theta = 0.8, 
  border = "white", 
  col = colors
 )


#####
tempcounts <- c(count_member_classicbike, count_member_electricbike, count_member_electricscooter)
templabels <- c("Classic Bike", "Electric Bike", "Electric Scooter")
temppct <- round(tempcounts/sum(tempcounts)*100, 1)
templabels_with_pct <- paste0(templabels, " (", temppct, "%)")
colors <- c("#1081eb", "#f58507", "#ff03a2")

pie3D(
  tempcounts, 
  labels = templabels_with_pct, 
  explode = 0.05, 
  main = "Proportion of Member Rides by Ride Type", 
  radius = 1, 
  height = 0.1, 
  theta = 0.8, 
  border = "white",
  col = colors
 )


#####
tempcounts <- c(count_casual_classicbike, count_casual_electricbike, count_casual_electricscooter)
templabels <- c("Classic Bike", "Electric Bike", "Electric Scooter")
temppct <- round(tempcounts/sum(tempcounts)*100, 1)
templabels_with_pct <- paste0(templabels, " (", temppct, "%)")

pie3D(
  tempcounts, 
  labels = templabels_with_pct, 
  explode = 0.05, 
  main = "Proportion of Casual Rides by Ride Type", 
  radius = 1, 
  height = 0.1, 
  theta = 0.8, 
  border = "white",
  col = colors
)
