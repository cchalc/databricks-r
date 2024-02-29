# Exploratory Data Analysis with Databricks

**Table of Contents:**<br>
I. [Introduction](#introduction)<br>
II. [Demo Script](#demo-script)<br>
III. [Data Dictionary](#data-dictionary)

### Introduction
In this demo we analyze the [Titanic Dataset](https://www.kaggle.com/c/titanic) with some of the latest features for Repos and Notebooks in Databricks.  In particular, we will demonstrate how to:


* Use Repos and Files to iterate on modular code
* Use Data Profiles and DBSQL Visualizations in the Databricks Notebook
* Use `bamboolib` to clean a dataset and uncover relationships between variables
* Share our discoveries!


We’re going to do all of that and we’re going to do it quickly.  This demo should only take about 10-15 minutes, and if you are just showing `bamboolib`, 5-10 minutes. The steps are spelled out in detail, and you can find a video here soon, but feel free to riff on the theme and modify it to suit your needs.

### Demo Script
 You’ve been tasked with analyzing the Titanic dataset and have been pointed to a git repo with some pre-work already done for you by a teammate.  Open up Databricks and finish the initial round of data exploration.
 
1. **Highlight: Repos + Files**

    a. Add the remote repo to Databricks Repos     
    b. Open up the EDA notebook and run the convert CSV to Delta commands     
    c. Upon error the stacktrace will point to line 26 in /utils/create_tables.py    
    d. Navigate to create_tables.py and use the file editor search capability to look up ‘table’. Correct line 26 to read ‘table_name’ instead of simply ‘table’.    
    e. Make sure the results are saved and return to the EDA notebook
2. **Highlight: Data Profiles and DBSQL Visualizations**  
  a. Create the view of the titanic dataset by joining the three datasets, then run the select * to begin exploring the data    
  b. Take a brief moment to look at the data table, then move on to the Data Profile.   
  c. Point out the distribution of values for Sex, Age, and Survived.      
  d. Notice the number of NaNs in the Cabin column    
  e. Create a new ‘Bubble Chart’ DBSQL visualization
   - Y-axis: Cabin  
   - X-axis: Age    
   - Color: Survived.  The default settings have non-survivors coded as green and survivors coded as red.  Go into the color settings and flip this.      
   - Size: Fare    
   - Adjust the size so that the output renders clearly    
   - Save the output  
   - Step back and analyze the visualization.  Notice how many NaNs there are and how many different Cabins are on the X-axis.  The visualization is too busy and granular to show a clear signal, so some data wrangling is needed to go any further. 
3. **Highlight: `bamboolib`**    
  a. Install `bamboolib` and import it as bam.  Note, you might need to run the import cell twice to get it to render.  This will be ironed out prior to GA.    
  b. Use `bamboolib` to further analyze and wrangle data
   - Choose ‘Databricks: load database table’ , enter ‘titanic’ as the table name, then execute
   - After noting the data table, click on ‘Explore Dataframe’
     * Notice how we see missing values in Age (about 20%), but not in Cabin!
     * Notice that ‘Survived’ is not a boolean
     * Click on the ‘Cabin’ row
     * There are all of the NaNs again, but they are encoded as strings.  We’ll have to fix that.
   - Clean up and analyze the ‘Survived’ column
     * Change the type to boolean by clicking on the ‘i’ next to it in the Data tab
     * Click on the ‘Survived’ column, then open the ‘Bivariate plots’ tab. 
     * Plot ‘Survived’ against ‘Sex’
     * The resulting mosaic plot tells us that despite there being a higher ratio of men to women, women have a much higher survivorship 
     * Click on the Predictors tab to see that Sex is indeed a predictor of survivorship
   - Back on the Data tab, use the Search Actions box to finish cleaning 
     * Use ‘Find and replace (global)’ to replace NaNs in ‘Cabin’ with actual missing values (nan)
     * Use ‘Split text column’ on ‘Cabin’.  Check the regex box and use [0-9] as the separator
     * Use ‘Select or drop columns’ to subset Survived, Sex, Age, Fare and Cabin_0
     * Drop all missing values
     * The resulting set should contain 185 rows and 5 columns    
  c. Use `bamboolib` to visualize data   
   - Click on Create plot
     * Choose Scatter plot as the figure type
     * Y-axis: Age
     * X-axis: Cabin_0
     * Color: Survived
     * Size: Fare
     * Facet column: Sex
   - This plot should very clearly illustrate that women in the similar cabin classes experience much higher survival rates    
  d. Use `bamboolib` to generate and share code    
   - Click on the Data tab and copy the code into a new code cell
   - Add a single line to the generated output: display(df)
   - Click on the Plot creator tab and copy the code into another new code cell

4. **Highlight: Sharing**    
  a. Run both cells with the generated code    
  b. Click on the ‘View’ tab in the notebook  and create a new dashboard    
  c. Arrange the elements to show the data table, the data profile, the DBSQL viz and the plotly viz from `bamboolib`   
  d. When you are done, present the dashboard     
  e. Come back to the dashboard editor or notebook, click on the share button and share it with someone. Note that they can be notified via email    

#### Conclusion
The work isn’t over, but you have discovered some important initial findings about who survived the Titanic and communicated them with your stakeholders.  What will you discover in your next iteration?    


### Data Dictionary

From: [Kaggle](https://www.kaggle.com/c/titanic/data)


| Variable | Definition                                 | Key                                            |   |   |
|----------|--------------------------------------------|------------------------------------------------|---|---|
| survival | Survival                                   | 0 = No, 1 = Yes                                |   |   |
| pclass   | Ticket class                               | 1 = 1st, 2 = 2nd, 3 = 3rd                      |   |   |
| sex      | Sex                                        |                                                |   |   |
| Age      | Age in years                               |                                                |   |   |
| sibsp    | # of siblings / spouses aboard the Titanic |                                                |   |   |
| parch    | # of parents / children aboard the Titanic |                                                |   |   |
| ticket   | Ticket number                              |                                                |   |   |
| fare     | Passenger fare                             |                                                |   |   |
| cabin    | Cabin number                               |                                                |   |   |
| embarked | Port of Embarkation                        | C = Cherbourg, Q = Queenstown, S = Southampton |   |   |

#### Variable Notes

`pclass`: A proxy for socio-economic status (SES)

* 1st = Upper

* 2nd = Middle

* 3rd = Lower

`age`: Age is fractional if less than 1. If the age is estimated, is it in the form of xx.5

`sibsp`: The dataset defines family relations in this way...

* Sibling = brother, sister, stepbrother, stepsister

* Spouse = husband, wife (mistresses and fiancés were ignored)

`parch`: The dataset defines family relations in this way...

* Parent = mother, father

* Child = daughter, son, stepdaughter, stepson

Some children travelled only with a nanny, therefore parch=0 for them.
