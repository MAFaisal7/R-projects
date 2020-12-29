install.packages("RSQLite")
library(DBI)
#Question 1
# Create an ephemeral in-memory RSQLite database
connection <- dbConnect(RSQLite::SQLite(), ":memory:")

df<- census_income

header <- c('age','class of worker','industry code','occupation code','education','wage per hour',
            'enrolled in edu inst last wk','marital status','major industry code',
            'major occupation code','race','hispanic Origin','sex','member of a labor union','reason for unemployment',
            'full or part time employment stat','capital gains',
            'capital losses','divdends from stocks','tax filer stat','region of prev residence','state of previous residence',
            'detailed household and family stat',
            'detailed household summary in household','migration code-change in msa','migration code-change in reg',
            'migration code-move within reg',
            'live in this house 1 year ago','migration prev res in sunbelt','num persons worked for employer','family members under 18',
            'total person earnings','country of birth father','country of birth mother','country of birth self','citizenship', 
            'own business or self employed',
            'fill inc questionnaire for veterans admin','veterans benefits','weeks worked in year','year','income')

#putting column names
names(df) <- header
View(df)
#Question 1: Data Types Q:2 (creating column SSID as primay key)
dbSendQuery(connection, 
            "CREATE Table censuss_income(
            ss_id INTEGER PRIMARY KEY AUTOINCREMENT,
            age INTEGER,
            'class of worker' VARCHAR(50),
            'industry code' VARCHAR(50),
            'occupation code' INTEGER,
            'education'VARCHAR(50),
            'wage per hour' INTEGER,
            'enrolled in edu inst last wk' VARCHAR(50),
            'marital status' VARCHAR(50),
            'major industry code' INTEGER,
            'major occupation code' INTEGER,
            'race' VARCHAR(50),
            'hispanic Origin' VARCHAR(50),
            'sex' VARCHAR(50),
            'member of a labor union' VARCHAR(50),
            'reason for unemployment' VARCHAR(50),
            'full or part time employment stat','capital gains' VARCHAR(50),
            
            'capital losses' VARCHAR(50),
            'divdends from stocks' VARCHAR(50),
            'tax filer stat' VARCHAR(50),
            'region of prev residence' VARCHAR(50),
            'state of previous residence' VARCHAR(50),
            'detailed household and family stat VARCHAR(50)',
            'detailed household summary in household' VARCHAR(50),
            'migration code-change in msa'VARCHAR(50),
            'migration code-change in reg' VARCHAR(50),
            'migration code-move within reg' VARCHAR(50),
            'live in this house 1 year ago' VARCHAR(50),
            'migration prev res in sunbelt' VARCHAR(50),
            'num persons worked for employer' VARCHAR(50),
            'family members under 18' VARCHAR(50),
            'total person earnings'VARCHAR(50),
            'country of birth father' VARCHAR(50),
            'country of birth mother'VARCHAR(50),
            'country of birth self'VARCHAR(50),
            'citizenship'VARCHAR(50), 
            'own business or self employed' VARCHAR(50),
            'fill inc questionnaire for veterans admin' VARCHAR(50),
            'veterans benefits' VARCHAR(50),
            'weeks worked in year' VARCHAR(50),
            'year' VARCHAR(50),
            'income' VARCHAR(50))")
#Checking all columns names in database
dbGetQuery(connection, "SELECT *  FROM censuss_income")


#Q3 Grouped by sex and race
con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "census_income", df)
dbGetQuery(con, "select Race,Sex, count(*) FROM census_income 
                   GROUP BY Race,Sex")

#Quesion 4 (first we will make a column of calcualted annual_income)
annual_income <- df$`wage per hour`*df$`weeks worked in year`
df$annual_income <- annual_income
con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "census_income", df)
dbListFields(con, "census_income")

#For annual average income
res <- dbExecute(con, "DELETE FROM census_income WHERE annual_income = 0")
dbGetQuery(con, "SELECT avg(annual_income) FROM census_income")

#Question 5 Creating 3 new tables
connection <- dbConnect(RSQLite::SQLite(), ":memory:")
dbListTables(connection)
dbWriteTable(connection, "census_income", df)
dbSendQuery(connection, 
            "CREATE Table Person(
            person_id INTEGER PRIMARY KEY AUTOINCREMENT,
            AAGE INT,
            AHGA VARCHAR(50),
            ASEX VARCHAR(20),
            PRCITSHP VARCHAR(50),
            GRINREG VARCHAR(50),
            AREORGN VARCHAR(50),
            AWKSTAT VARCHAR(50)
)")

dbSendQuery(connection, 
            "CREATE Table Job(
            occjd INTEGER PRIMARY KEY AUTOINCREMENT,
            ADTIND INT,
            ADTOCC INTEGER,
            AMJOCC INTEGER,
            AMJIND INTEGER
)")

dbSendQuery(connection, 
            "CREATE Table Pay(
            job_id INTEGER PRIMARY KEY AUTOINCREMENT,
            AHRSPAY INT,
            WKSWORK INTEGER
)")
dbListTables(connection)    
            