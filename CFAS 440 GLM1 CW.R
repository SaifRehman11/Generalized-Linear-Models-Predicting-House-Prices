library(MASS)
library(car)

houseprices <- read.csv("houseprices.csv", header=TRUE)
names(houseprices)

#
#data read in and recoded - no missing values
#
houseprices$garageF = factor(houseprices$garage_spaces)
houseprices$fullbathF = factor(houseprices$no_full_baths)
houseprices$halfbathF = factor(houseprices$no_half_baths) 
houseprices$roomF = factor(houseprices$no_rooms)
houseprices$zipF = factor(houseprices$zip)
houseprices$bedF = factor(houseprices$bedgroup)
attach(houseprices)

#
#exploration of data
#
summary(houseprices)
#out <- capture.output(summary(houseprices))
#cat("Summary Output", out, file="Summary Output GLM 1.txt", sep = "n", append=TRUE)
hist(price2014)
plot(distance, walkscore, xlab = "Distance to the trail", ylab = "Walkscore", main = "Comparing distance to the trail with walkscore", cex=1.4, pch = 20)
hist(no_rooms)
hist(walkscore)
plot(walkscore, bikescore, cex=1.4, pch=20, xlab = "Walkscore", ylab = "Bikescore", main = "Comparing correlation between walkscore and bikescore")
plot(bikescore, walkscore, cex=1.4, pch=20)

plot(walkscore, price2014, xlab = "Walkscore", ylab = "Price 2014", main = "Comparing walkscore with house prices", cex=1.4, pch = 20)

plot(walkscore, price2014, cex=1.4, pch=20)
plot(distance, price2014, cex=1.4, pch=20, xlab = "Distance to the trail", ylab = "Price 2014", main = "Comparing distance to the trail to house prices")
plot(price2014, distance)
plot(garageF, price2014, xlab = "Number of Garages", ylab = "Price 2014", main= "Comparing number of garages to Price 2014")

plot(fullbathF, price2014, xlab = "Number of Full Bathrooms", ylab = "Price 2014", main= "Comparing number of full bathrooms to Price 2014")

plot(acre, price2014)
plot(distance, price2014)
plot(zipF, price2014, xlab = "Zipcode", ylab = "Price 2014", main= "Comparing zipcode to Price 2014")
plot(no_rooms, bedF)
plot(no_rooms, price2014)
plot(roomF, bedF, xlab = "Number of Rooms", ylab = "Bed Group Factors", main= "Comparing Number of Rooms to Bed Group Factors")
plot(roomF, price2014, xlab = "Number of Rooms", ylab = "Price 2014", main= "Comparing Number of Rooms to Price 2014")
plot(squarefeet, acre)
plot(acre, squarefeet)

plot(zipF, distance, xlab = "Zip Code", ylab = "Distance to the trail", main = "Comparing zipcode to distance to trail")
#
#model fitting
#

#Number 1, doing simple linear regression to examine relationship between distance and houseprices

mdistance <- lm(price2014 ~ distance , data = houseprices)
Anova(mdistance)
sresid <- rstandard(mdistance)
qqnorm(sresid)
qqline(sresid)

#This shows that distance is highly significant predictor of house prices


#Number 2, doing a multiple linear regression, just doing a simple one without assuming any interactions 
#This is the one without the factors except fullbathF and halfbathF and zipF
#m1 = lm(price2014 ~ acre + distance + bedgroup + bikescore + fullbathF + halfbathF + no_rooms + squarefeet + walkscore + zipF, data = houseprices)
#Anova(m1)

m1 = lm(price2014 ~ acre + bedF + bikescore + distance + garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m1)
summary(m1)

m1test = lm(price2014 ~ acre + bedF + bikescore + distance + garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices, direction = "backward")
summary(m1test)
step(m1, direction = "backward")
#Previously Dropped out Bikescore as it had the least significant P value

#m2 = lm(price2014 ~ acre + distance + bedgroup + fullbathF + halfbathF + roomF + squarefeet + walkscore)
#Anova(m2)

#Dropping out acre as it is the least significant
m2 = lm(price2014 ~ bedF + bikescore + distance + garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m2)

#Old#Dropped out Distance as it had the least significant P value

#m3 = lm(price2014 ~ acre + bedgroup + fullbathF + halfbathF + roomF + squarefeet + walkscore)
#Anova(m3)

#Dropped out bedF as it is the least significant
m3 = lm(price2014 ~ bikescore + distance + garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m3)


#Old#Dropped out bedgroup as it had the least significant P value 

#m4 = lm(price2014 ~ acre + fullbathF + halfbathF + roomF + squarefeet + walkscore)
#Anova(m4)

#Dropped out distance 
m4 = lm(price2014 ~ bikescore + garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m4)


#Old#Dropped out acre as it had the least significant P value

#m5 = lm(price2014 ~  fullbathF + halfbathF + roomF + squarefeet + walkscore)
#Anova(m5)

#Dropped out bikescore as it has the least significant P value
m5 = lm(price2014 ~ garageF + fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m5)


#Old#Dropped out halfbathF as it had the least significant P value

#m6 = lm(price2014 ~  fullbathF + roomF + squarefeet + walkscore)
#Anova(m6)

#Dropped out garageF as it has the highest P value

m6 = lm(price2014 ~ fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m6)
summary(m6)
#All values are now significant so now m6 is the final simple model
#Checkign the residuals

simpleresid <- rstandard(m6)
qqnorm(simpleresid)
qqline(simpleresid)

par(mfrow=c(2,2))
plot(m6)
#Residuals do not fit well at both ends


plot(fitted(m6),simpleresid)
#Old#Dropped out fullbathF as it had the least significant P value

#m7 = lm(price2014 ~  roomF + squarefeet + walkscore)
#Anova(m7)

##Just testing out different things 

#m8 = lm(price2014 ~ bikescore + roomF + squarefeet)
#Anova(m8)
##However, when I switch things up, bikescore now became significant

#m9 = lm(price2014 ~ roomF + fullbathF + squarefeet)
#Anova(m9)
#fullbathF is still not significant 

#m10 <- lm(price2014 ~ roomF + squarefeet + distance)
#Anova(m10)

#Now distance is significant with a p-value 0.0175 so this shows a complex relationship


##Now setting up a complex linear model based on the assumed interactions between the variables


m11 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance, data = houseprices)
Anova(m11)

#Removing all of the interactions that have 0df (are repeats), starting taking out three of the least significant interactions
m12 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF, data = houseprices)
Anova(m12)

#Removed halfbathF:bedF, roomF:fullbathF , fullbathF:halfbathF
m13 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF, data = houseprices)
Anova(m13)

#Got rid of all the triple interactions as they were colluding the results
m14 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance, data = houseprices)
Anova(m14)

#Got rid of fullbathF:garageF , halfbathF:garageF , bikescore:zipF , walkscore:distance , squarefeet:acre
m15 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre, data = houseprices)
Anova(m15)

#Got rid of bedF, acre, zipF:distance
m16 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance, data = houseprices)
Anova(m16)


#Got rid of squarefeet , roomF:bedF, bedF:garageF, bikescore:distance
m17 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance, data = houseprices)
Anova(m17)


#Got rid of fullbathF:bedF , walkscore:zipF , distance
m18 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance -fullbathF -walkscore:zipF - distance, data = houseprices)
Anova(m18)

##Got rid of bikescore
m19 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance -fullbathF -walkscore:zipF - distance
          -bikescore, data = houseprices)
Anova(m19)

#Got rid of roomF:halfbathF
m20 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance -fullbathF -walkscore:zipF - distance
          -bikescore -roomF:halfbathF, data = houseprices)
Anova(m20)

#Final model, got rid of roomF:garageF
m21 <- lm(price2014 ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance -fullbathF -walkscore:zipF - distance
          -bikescore -roomF:halfbathF-roomF:garageF, data = houseprices)
Anova(m21)

#Testing out the residuals of the complex final model (m21)
complexresid <- rstandard(m21)
qqnorm(complexresid)
qqline(complexresid)

#The residuals are still not that good at the ends, but it is a better fit then the simplified model

plot(fitted(m21),complexresid)
#Doing a boxcox analysis to check how to better improve the model

boxcox(m6)
#For the simple model, it is close to 0 which means that it makes sense to log it

boxcox(m21)
#For the complex model, it is also close to 0 which further reinforces that I should log it

#Adding log to the simple model
m7 <- lm(log(price2014) ~ fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
Anova(m7)

simplelogresid <- rstandard(m7)
qqnorm(simplelogresid)
qqline(simplelogresid)
#Adding log to the complex model
m22 <- lm(log(price2014) ~ squarefeet*acre + roomF*fullbathF*halfbathF*bedF*garageF + bikescore*walkscore*zipF*distance 
          -roomF:fullbathF:halfbathF -roomF:halfbathF:bedF -fullbathF:halfbathF:bedF -roomF:halfbathF:garageF 
          -fullbathF:halfbathF:garageF -roomF:bedF:garageF -halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF
          -roomF:fullbathF:halfbathF:garageF -roomF:fullbathF:bedF:garageF -roomF:halfbathF:bedF:garageF 
          -fullbathF:halfbathF:bedF:garageF -roomF:fullbathF:halfbathF:bedF:garageF -halfbathF:bedF
          -roomF:fullbathF -fullbathF:halfbathF -roomF:fullbathF:bedF -roomF:fullbathF:garageF 
          -fullbathF:bedF:garageF -bikescore:walkscore:zipF -bikescore:walkscore:distance -bikescore:zipF:distance
          -walkscore:zipF:distance -bikescore:walkscore:zipF:distance -fullbathF:garageF -halfbathF:garageF
          -bikescore:zipF -walkscore:distance -squarefeet:acre -bedF -acre -zipF:distance
          -squarefeet - roomF:bedF -bedF:garageF -bikescore:distance -fullbathF -walkscore:zipF - distance
          -bikescore -roomF:halfbathF-roomF:garageF, data = houseprices)
Anova(m22)
summary(m22)
complexlogresid <- rstandard(m22)
qqnorm(complexlogresid)
qqline(complexlogresid)
#Testing out the residuals for the final model (m7) and it shows that this is not a really good fit for this model as the residuals are not normal
#sresid = rstandard(m7)
#qqnorm(sresid)
#qqline(sresid)


#sresid = rstandard(m8)
#qqnorm(sresid)
#qqline(sresid)

#boxCox(m7)


#Simplified complex model 
m31 <- lm(price2014 ~ (squarefeet+acre)^2 + (roomF+fullbathF+halfbathF+bedF+garageF)^2 + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m31)

#Dropped halfbathF:bedF

m32 <- lm(price2014 ~ (squarefeet+acre)^2 + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -halfbathF:bedF + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m32)

#Dropped squarefeet:acre
m33 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -halfbathF:bedF + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m33)

#Dropped roomF:fullbathF
m34 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m34)

#Dropped bedF
m35 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m35)

#Dropped fullbathF:garageF 
m36 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF + (bikescore+walkscore+zipF+distance)^2, data = houseprices)
Anova(m36)

#Dropped bikescore 
m37 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF + (bikescore+walkscore+zipF+distance)^2 -bikescore, data = houseprices)
Anova(m37)

#Dropped bikescore:distance 
m38 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance, data = houseprices)
Anova(m38)

#Dropped distance
m39 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance, data = houseprices)
Anova(m39)

#Dropped fullbathF;bedF
m40 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance, data = houseprices)
Anova(m40)

#Dropped halfbathF: garageF
m41 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF, data = houseprices)
Anova(m41)

#Dropped walkscore:distance
m42 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance, data = houseprices)
Anova(m42)

#Dropped roomF:garageF
m43 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF, data = houseprices)
Anova(m43)

#Dropped bedF:garageF
m44 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF, data = houseprices)
Anova(m44)

#Dropped walkscore
m45 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore, data = houseprices)
Anova(m45)

#Dropped bikescore:walkscore
m46 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore, data = houseprices)
Anova(m46)

#Dropped roomF:halfbathF
m47 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore-roomF:halfbathF, data = houseprices)
Anova(m47)


#Dropped roomF:bedF
m48 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore-roomF:halfbathF-roomF:bedF, data = houseprices)
Anova(m48)

#Dropped bikescore:zipF
m49 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore-roomF:halfbathF-roomF:bedF-bikescore:zipF, data = houseprices)
Anova(m49)

#Dropped walkscore:zipF
m50 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore-roomF:halfbathF-roomF:bedF-bikescore:zipF-walkscore:zipF, data = houseprices)
Anova(m50)

#Dropped zipF:distance
m51 <- lm(price2014 ~ squarefeet+acre + (roomF+fullbathF+halfbathF+bedF+garageF)^2 -roomF:fullbathF -halfbathF:bedF-bedF-fullbathF:garageF-fullbathF:bedF + (bikescore+walkscore+zipF+distance)^2 -bikescore-bikescore:distance-distance-halfbathF:garageF-walkscore:distance-roomF:garageF-bedF:garageF-walkscore-bikescore:walkscore-roomF:halfbathF-roomF:bedF-bikescore:zipF-walkscore:zipF-zipF:distance, data = houseprices)
Anova(m51)

#Dropped acre
m52 <- lm(price2014 ~ squarefeet + roomF + fullbathF + halfbathF + garageF + zipF + fullbathF:halfbathF , data = houseprices)
Anova(m52)

#Dropped garageF for final model
m53 <- lm(price2014 ~ squarefeet + roomF + fullbathF + halfbathF + zipF + fullbathF:halfbathF , data = houseprices)
Anova(m53)

summary(m53)





##Final semi-complex model


m60 <- lm(price2014 ~ squarefeet + acre + (bikescore + walkscore)^2 + (zipF + distance)^2 + (bedF + roomF)^2 + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m60)

#Dropped distance 

m61 <- lm(price2014 ~ squarefeet + acre + (bikescore + walkscore)^2 + zipF + zipF:distance + (bedF + roomF)^2 + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m61)

#Dropped bedF:roomF

m62 <- lm(price2014 ~ squarefeet + acre + (bikescore + walkscore)^2 + zipF + zipF:distance + bedF + roomF + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m62)

#Dropped zipF:distance

m63 <- lm(price2014 ~ squarefeet + acre + (bikescore + walkscore)^2 + zipF + bedF + roomF + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m63)

#Dropped bikescore

m64 <- lm(price2014 ~ squarefeet + acre + walkscore + bikescore:walkscore + zipF + bedF + roomF + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m64)

#Dropped bedF

m65 <- lm(price2014 ~ squarefeet + acre + walkscore + bikescore:walkscore + zipF + roomF + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m65)

#Dropped acre

m66 <- lm(price2014 ~ squarefeet + walkscore + bikescore:walkscore + zipF + roomF + garageF + fullbathF + halfbathF, data = houseprices)
Anova(m66)

#Dropped halfbathF

m67 <- lm(price2014 ~ squarefeet + walkscore + bikescore:walkscore + zipF + roomF + garageF + fullbathF, data = houseprices)
Anova(m67)
summary(m67)

complexresid <- rstandard(m67)
qqnorm(complexresid)
qqline(complexresid)

boxcox(m67)


m68 <- lm(log(price2014) ~ squarefeet + walkscore + bikescore:walkscore + zipF + roomF + garageF + fullbathF, data = houseprices)
Anova(m68)

#Drop walkscore:bikescore as it is the least significant 

m69 <- lm(log(price2014) ~ squarefeet + walkscore + zipF + roomF + garageF + fullbathF, data = houseprices)
Anova(m69)

#Dropped off garageF

m70 <- lm(log(price2014) ~ squarefeet + walkscore + zipF + roomF + fullbathF, data = houseprices)
Anova(m70)

#Dropped off fullbathF

m71 <- lm(log(price2014) ~ squarefeet + walkscore + zipF + roomF, data = houseprices)
Anova(m71)

#Drop off zipF 

m72 <- lm(log(price2014) ~ squarefeet + walkscore + roomF, data = houseprices)
Anova(m72)

#Drop roomF 
m73 <- lm(log(price2014) ~ squarefeet + walkscore, data = houseprices)
Anova(m73)

summary(m73)

complexlogresid <- rstandard(m73)
hist(complexlogresid)
qqnorm(complexlogresid)
qqline(complexlogresid)


#boxcox(m6)

#Adding log to the simple model
#m7 <- lm(log(price2014) ~ fullbathF + halfbathF + roomF + squarefeet + walkscore + zipF, data = houseprices)
#Anova(m7)

#simplelogresid <- rstandard(m7)
#qqnorm(simplelogresid)
#qqline(simplelogresid)



library(calibrate)

rstandard = rstandard(m73)
#index = seq(1, 104, 1)
plot(housenum, rstandard, "l")
textxy(housenum,rstandard, housenum)

rstandard = rstandard(m67)
rstandard = rstandard(m6)
