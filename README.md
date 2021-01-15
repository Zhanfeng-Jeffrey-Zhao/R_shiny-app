# R_shiny-app
 R Shiny application is based off of a dataset of Airbnb listings in New York City for 2019.
 (data link:https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data#AB_NYC_2019.csv)
 
 The application launches the user will be able to see a menu bar at the top in the form of tabs where they can easily navigate between the different features.
 
 In the first tab of the application subsetted the dataset to include the columns that users would likely be most interested in when searching for an Airbnb. 
 
 ![](Image/1st%20Tab.png)
 
 In the second tab the user can select a borough and a price range, and the app will show them a histogram of how many days out of the year Airbnb’s with those   parameters are available.
 
  ![](Image/2nd%20Tab.png)
  
 In the third tab the user can select the borough from a drop down menu, and then manipulate the histogram to adjust number of bins.
 
  ![](Image/3rd%20Tab.png)
  
 In the final tab  I used a new packaged called leaflet to plot the Airbnb locations on a map from their longitude and latitude coordinates.  The user can select a borough and dots will appear on the map where Airbnb’s are located. 
 
  ![](Image/4th%20Tab.png)
