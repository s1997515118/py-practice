getwd()
setwd("C:/Users/月月/Desktop/R_report")
library(mice)
library(car)
library(ggplot2)
library(olsrr)
library(caret)
#原始資料
happiness_original<-read.csv("WorldHappiness_Corruption_2015_2020.csv",header=TRUE) 
#將資料內作為無效數據的0替換為NA
happiness_original[happiness_original == 0] <- NA

#敘述性統計
mean(happiness_original$happiness_score)
median(happiness_original$happiness_score)
sd(happiness_original$happiness_score)
qqnorm(happiness_original$happiness_score, 
       main = "Normal Probability Plot", 
       xlab = "Theoreical Standard Normal Quantiles", 
       ylab = "happiness score")
qqline(happiness_original$happiness_score, col = "red")
boxplot(happiness_original$happiness_score,
        main="BoxPlot",
        horizontal=TRUE)
hist(happiness_original$happiness_score, breaks = 30, prob = TRUE, col = "lightblue", 
     main = "Normal Distribution", xlab = "Values", ylab = "Density")
curve(dnorm(x, 5.47331, 1.124726), add = TRUE, col = "darkblue", lwd = 2)
library(moments)
kurtosis(happiness_original$happiness_score)

#刪減有遺漏資料的欄位（刪family,dystopia_residual,social_support）
happiness_deleted<-happiness_original[,!(names(happiness_original))%in%
                                        c("family","dystopia_residual","social_support")]

#第一次多元迴歸(刪family,dystopia_residual,social_support)
happiness_deleted_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+cpi_score+Year+continent,data=happiness_deleted)
summary(happiness_deleted_lm)
#調整判定係數0.8026，模型解釋能力相當高

#加入新自變數family
happiness_family <- data.frame(happiness_deleted,happiness_original$family)
#更改欄位名稱
colnames(happiness_family)[colnames(happiness_family)=="happiness_original.family"] <- "family"

#第二次多元迴歸(加入family)，確認Family是否為重要解釋變數
happiness_family_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+cpi_score+Year+continent+family,
                        data=happiness_family)
summary(happiness_family_lm)
#family對快樂程度有顯著影響
#有趣的結果: Year原先不顯著，加入新的自變數後變顯著了

#透過多重填補預測並估計family的遺漏值
happiness_family_temporary <- mice(happiness_family)
happiness_family_completed <- complete(happiness_family_temporary)

#加入新自變數dystopia_residual
happiness_dystopia <- data.frame(happiness_family_completed,happiness_original$dystopia_residual)
#更改欄位名稱
colnames(happiness_dystopia)[colnames(happiness_dystopia)=="happiness_original.dystopia_residual"] <- "dystopia_residual"

#第三次多元迴歸(加入dystopia_residual)，確認dystopia_residual是否為重要解釋變數
happiness_dystopia_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+cpi_score+Year+continent+family+dystopia_residual,
                          data=happiness_dystopia)
summary(happiness_dystopia_lm)
#dystopia_residual對快樂程度有顯著影響
#有趣的結果: Year再次變為不顯著

#透過多重填補預測並估計dystopia_residual的遺漏值
happiness_dystopia_temporary <- mice(happiness_dystopia)
happiness_dystopia_completed <- complete(happiness_dystopia_temporary)

#加入最後一個新自變數social_support
happiness_social <- data.frame(happiness_dystopia_completed,happiness_original$social_support)
#更改欄位名稱
colnames(happiness_social)[colnames(happiness_social)=="happiness_original.social_support"] <- "social_support"

#第四次多元迴歸(加入social_support)，確認social_support是否為重要解釋變數
happiness_social_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+cpi_score+Year+continent+family+dystopia_residual+social_support,
                        data=happiness_social)
summary(happiness_social_lm)
#social_support對快樂程度有顯著影響
#有趣的結果: 加入social_support後，Year再次變為顯著

#透過多重填補預測並估計dystopia_residual的遺漏值
happiness_social_temporary <- mice(happiness_social)
happiness_social_completed <- complete(happiness_social_temporary)

#第五次多元迴歸，處理完所有遺漏值後加入所有自變數
happiness_social_completed_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+cpi_score+Year+continent+family+dystopia_residual+social_support,
                        data=happiness_social_completed)
summary(happiness_social_completed_lm)

#移除對快樂程度影響不顯著的自變數cpi
happiness_completed <- happiness_social_completed[,-which(colnames(happiness_social_completed)=="cpi_score")]

#第六次多元迴歸，再次進行多元回歸
happiness_completed_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+Year+continent+family+dystopia_residual+social_support,
                                  data=happiness_completed)
summary(happiness_completed_lm)

#多重共線性檢測
vif(happiness_completed_lm)
#無多重共線性問題

#殘差圖
happiness_residual = fortify(happiness_completed_lm) 
ggplot(data = happiness_residual , 
       aes(x = .fitted, y = .stdresid))+
       geom_point() 
# plot standardized residuals
which(abs(happiness_residual$.stdresid)>2)

# studentized deleted residual
rstudent(happiness_completed_lm)

# plot studentized deleted residual 
ols_plot_resid_stud_fit(happiness_completed_lm) 

which(abs(happiness_residual$.hat)>3*(5+1)/64)# check hi
round(happiness_residual$.cooksd , 4 )
which(abs(happiness_residual$.cooksd)>1)  #check cooksd

#殘差時間序列圖，檢測是否存在自我相關
plot(.resid~Year , data=happiness_residual,
     xlab = "Year", 
     ylab = "Residuals",
     main = "Residual Plot by Year")

#將資料分成訓練集與測試集
set.seed(1894)
train <- sample(1:nrow(happiness_completed),round(0.8*nrow(happiness_completed)))
traindata <- happiness_completed[train,] #訓練集
testdata <- happiness_completed[-train,] #測試集

#以訓練集進行多元回歸
traindata_lm<-lm(happiness_score~gdp_per_capita+health+freedom+generosity+government_trust+Year+continent+family+dystopia_residual+social_support,
                           data=traindata)
#以測試集的資料進行預測
prediction <- predict(traindata_lm,newdata=testdata)

#計算R
r_coefficient <- cor(testdata$happiness_score,prediction)
print(r_coefficient)

