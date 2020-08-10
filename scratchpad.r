#Referendum on Leaving the EU
#The raw data are available here.

http://www.electoralcommission.org.uk/__data/assets/file/0014/212135/EU-referendum-result-data.csv

#Demographic data are available here.

https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2015/ukmye2015.zip

# Reading the dataset
d <- read.csv("C:/Users/Dell/Downloads/referendum_3.csv")
# The influence of migration

library(ggplot2)

g0<-ggplot(d,aes(x=pernonuk,y=Pct_Leave))
g1<-g0+geom_point(aes(col=win))+scale_x_log10()+geom_smooth(method=lm)
g1<-g1+labs(x="Percentage of population born outside the UK, 
            log scale",y="Percentage voting leave")
g1
#This aggregated data however may be confounded by the fact 
#that the authorities with the highest percentage of residents 
#born outside the UK were in London, which overwhelming favoured 
#remain.So the results should also be looked at by region.

g1+facet_wrap("Region")

g0<-ggplot(d,aes(x=permig,y=Pct_Leave))
g1<-g0+geom_point(aes(col=win))+geom_smooth(method=lm)
g1<-g1+labs(x="Percent net migration",y="Percentage voting leave")
g1<-g1+scale_x_log10()
g1
#Region View
g1+facet_wrap("Region")

#The areas with high inward migration also have high rates of outward migration.
g0<-ggplot(dd,aes(x=MigIn,y=MigOut))
g1<-g0+geom_point(aes(col=win))+scale_x_log10()+geom_smooth(method=loess)
g1<-g1+labs(x="Inward migration",y="Outward migration")
g1

mig<-melt(dd,id="Region",m=c("MigOut","MigIn"))
mig<-cast(mig,Region~variable,sum)
mig$Percent_outmigration<-round(100*mig$MigOut/mig$MigIn,0)
mig



### Effect of population age structure
#Percantage of voting age population 40 or more VS Perc_Leave
g0<-ggplot(dd,aes(x=POver40,y=Pct_Leave))
g1<-g0+geom_point(aes(col=win))
g1<-g1+labs(x="Percentage of voting age population aged 40 or more",y="Percentage voting leave")
g1+geom_smooth(aes(x=POver40,y=Pct_Leave),method="loess")

## Region View
g1+geom_smooth(method=lm)+facet_wrap("Region")

#percentage Turnout vs percent of voters age 40 or more
g0<-ggplot(dd,aes(x=POver40,y=Pct_Turnout))
g1<-g0+geom_point(aes(color=win))+geom_smooth(method="lm")
g1<- g1+labs(x="Percentage of voting age population aged 40 or more",y="Percent turnout")
g1

#Region View
g1+geom_smooth(method=lm)+facet_wrap("Region")


#Turnout as an influence on the vote.
## Based on the clear relationships between turnout, age strucure and voting 
#leave we might expect the leave vote to increase with turnout

g0<-ggplot(dd,aes(x=Pct_Turnout,y=Pct_Leave))
g1<-g0+geom_point(aes(color=win))+geom_smooth(method="lm")
g1<-g1+labs(x="Percent turnout",y="Percent voting leave")
g1

## Regional View
g1+facet_wrap("Region")

##Because turnout overall in Scotland was much lower than England and Wales and overwhelmingly voted to remain 
#we will remove Scotish local authorities as they would distort the model for the rest of the country.

#Percentage leave VS Turnout after holding for age
mod<-lm(Pct_Turnout~POver40,data=Eng)
Eng$turnout_residuals<-residuals(mod)
g0<-ggplot(Eng,aes(x=turnout_residuals,y=Pct_Leave))
g1<-g0+geom_point()+geom_smooth(method="lm")
g1<-g1+labs(x="Turnout after holding for age",y="Percent voting leave")
g1
## Region View
g1+facet_wrap("Region")

## A formal way to analyse this is to build an additive linear model in which the 
#percent voting leave is predicted by turnout and percentage of voters over 40.

mod<-lm(Pct_Leave~Pct_Turnout+POver40,data=Eng)
summary(mod)

# The coefficient is negative and highly significant thus confirming formally that higher 
#turnout after taking into account demography does indeed decrease the percent voting leave. 
#This calls into question claims that there was an “overwhelming mandate” in favour of leaving. 
#If more people had turned out to vote then the result would almost certainly have been to remain.
