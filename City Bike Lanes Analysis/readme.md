# City Bike Lanes Analysis

This dataset has information about local bike lanes such as the street name they're on, the year they were first installed, the year they were updated, how wide they are, and their safety rating.

* Using PostgreSQL, checked for duplicates in dataset and found that two technicians gave differing ratings for each street.
* Analyzed safety ratings and classified average safety ratings of >=4 as safe.
* Used windows functions to classify recommendations based on average safety ratings.
* Counted total number of projects per street based on classifications.
* Found that here are 14 streets with improvements needed, 34 streets to leave as-is, and 12 streets to remove the bike lanes due to low safety ratings. 