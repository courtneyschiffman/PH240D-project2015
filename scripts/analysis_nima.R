### ================== ###
### Nima Hejazi        ###
### SID 22669337       ###
### Public Health 240D ###
### Final Project      ###
### Dec. 02, 2015      ###
### ================== ###

# analysis for genes on Rheumatoid Arthritis and Stress
rm(list=ls())
set.seed(2423)
data_dir = '/Users/nimahejazi/Desktop/240D_FinalProj/data/'
if (getwd() != data_dir) { setwd(data_dir) }

stress_data = read.table("stress_genes.txt", sep="", fill=FALSE, 
                         strip.white=TRUE)

stress_pairs1 = as.data.frame(t(rbind(stress_data["ACSL1", ], 
                                      stress_data["AQP9", ])))
stress_pairs2 = as.data.frame(t(rbind(stress_data["NFKB1", ], 
                                      stress_data["IFNB1", ])))
stress_pairs3 = as.data.frame(t(rbind(stress_data["PRG2", ], 
                                      stress_data["ACSL1", ])))
stress_pairs4 = as.data.frame(t(rbind(stress_data["PRG2", ], 
                                      stress_data["CLEC5A", ])))
stress_pairs5 = as.data.frame(t(rbind(stress_data["NFKB1", ], 
                                      stress_data["CLEC5A", ])))
stress_pairs6 = as.data.frame(t(rbind(stress_data["ACSL1", ], 
                                      stress_data["CLEC5A", ])))

stress_outcome <- replace(as.vector(rep(1,length(colnames(stress_data)))), 
                          grep('Non',colnames(stress_data)), 0)
if (length(stress_outcome) != length(colnames(stress_data))) { 
  print('FUCK, PROBLEM WITH OUTCOMES - STOP')}


rheumatoid_data = read.table("rheumatoid_genes.txt", sep="", fill=FALSE, 
                             strip.white=TRUE)

rheumatoid_pairs1 = as.data.frame(t(rbind(rheumatoid_data["ACSL1", ], 
                                          rheumatoid_data["AQP9", ])))
rheumatoid_pairs2 = as.data.frame(t(rbind(rheumatoid_data["NFKB1", ], 
                                          rheumatoid_data["IFNB1", ])))
rheumatoid_pairs3 = as.data.frame(t(rbind(rheumatoid_data["PRG2", ], 
                                           rheumatoid_data["ACSL1", ])))
rheumatoid_pairs4 = as.data.frame(t(rbind(rheumatoid_data["PRG2", ], 
                                          rheumatoid_data["CLEC5A", ])))
rheumatoid_pairs5 = as.data.frame(t(rbind(rheumatoid_data["NFKB1", ], 
                                          rheumatoid_data["CLEC5A", ])))
rheumatoid_pairs6 = as.data.frame(t(rbind(rheumatoid_data["ACSL1", ], 
                                          rheumatoid_data["CLEC5A", ])))

rheumatoid_outcome <- replace(as.vector(rep(1,length(colnames(rheumatoid_data)))), 
                              grep('.Control',colnames(rheumatoid_data)), 0)
if (length(rheumatoid_outcome) != length(colnames(rheumatoid_data))) { 
  print('FUCK, PROBLEM WITH OUTCOMES - STOP')}

rm(data_dir, stress_data, rheumatoid_data)



# Setting up Super Learner
library(ROCR)
library(cvAUC)
library(SuperLearner)
SL.lib <- c("SL.glm","SL.stepAIC","SL.bayesglm","SL.randomForest", "SL.gam","SL.mean")
CV_folds = 10


# Applying Super Learner to "Stress" data
Y = stress_outcome
levels(Y) = list("0"="CON", "1"="DIS")
Y = as.vector(Y)
Y = as.numeric(Y) # numeric vector of our zero-one outcomes


# Xfinal=data.frame(X=normal[,c(18,23)]) # this should be an nx2 data frame where the two columns
# # are the expressions/counts of the 2 genes
# 
# fit.test.final=CV.SuperLearner(Y,Xfinal,family=binomial(),SL.library=SL.library,V=V)
# fld=fit.test.final$fold
# predsY.final=fit.test.final$SL.predict
# fold=rep(NA,length(predsY.final))
# for(k in 1:V) {
#   ii=unlist(fld[k])
#   fold[ii]=k
# }
# 
# ciout.final=ci.cvAUC(predsY.final, Y, folds = fold)
# ciout.final
# 
# # graph the ROC curve
# txt=paste("AUC = ",round(ciout$cvAUC,2),",  95% CI = ",round(ciout$ci[1],2),"-",round(ciout$ci[2],2),sep="")
# pred <- prediction(predsY.final,Y)
# perf1 <- performance(pred, "sens", "spec")
# plot(1-slot(perf1,"x.values")[[1]],slot(perf1,"y.values")[[1]],type="s",xlab="1-Specificity",ylab="Sensitivity",
#      main="ROC Curve, Normalized Counts")
# text(0.6,0.4,txt)
# abline(0,1)


# TWO GENES IN THE SL: ACSL1, AQP9 
X = stress_pairs1
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs1.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs1.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: NFKB1, IFNB1 
X = stress_pairs2
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs2.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs2.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: PRG2,ACSL1 
X = stress_pairs3
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs3.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs3.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: PRG2, CLEC5A 
X = stress_pairs4
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs4.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs4.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: NFKB1, CLEC5A 
X = stress_pairs5
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs5.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs5.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: ACSL1, CLEC5A
X = stress_pairs6
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
stress.pairs6.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
stress.pairs6.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)



# Applying Super Learner to "Rheumatoid Arthritis" data
Y = rheumatoid_outcome
levels(Y) = list("0"="CON", "1"="DIS")
Y = as.vector(Y)
Y = as.numeric(Y) # numeric vector of our zero-one outcomes


# TWO GENES IN THE SL: ACSL1, AQP9 
X = rheumatoid_pairs1
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs1.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs1.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: NFKB1, IFNB1 
X = rheumatoid_pairs2
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs2.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs2.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: PRG2,ACSL1 
X = rheumatoid_pairs3
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs3.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs3.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: PRG2, CLEC5A 
X = rheumatoid_pairs4
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs4.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs4.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: NFKB1, CLEC5A 
X = rheumatoid_pairs5
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs5.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs5.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)


# TWO GENES IN THE SL: ACSL1, CLEC5A
X = rheumatoid_pairs6
fit.pairs.SL <- CV.SuperLearner(Y, X, family = binomial(), 
                                SL.library = SL.lib, V = CV_folds)
fld = fit.pairs.SL$fold
predsY.final = fit.pairs.SL$SL.predict

fold = rep(NA, nrow(X))
for(k in 1:CV_folds) {
  ii = unlist(fld[k])
  fold[ii] = k
}
rheum.pairs6.ciout.final = ci.cvAUC(predsY.final, Y, folds = fold)
rheum.pairs6.ciout.final.alt = cvAUC(predsY.final, Y, folds = fold)



#EndScript