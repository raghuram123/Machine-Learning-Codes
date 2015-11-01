#---------------------------------question 1)a-----------------------------------------------------
set.seed(1)
y=cbind(c(1,1,0,5,6,4),c(4,3,4,1,2,0))
plot(y[,1],y[,2])

#-----------------------------------------------question 1)b---------------------------------------
print("Answer 2")
random_labels = sample(2, nrow(y), replace=TRUE)
print(random_labels)

#-------------------------------------------------question1)c---------------------------------------
print("Answer 3")
c1 = c(mean(y[random_labels==1, 1]), mean(y[random_labels==1, 2]))
c2 = c(mean(y[random_labels==2, 1]), mean(y[random_labels==2, 2]))

print(c1)
print(c2)

#-------------------------------------------------question 1)d---------------------------------------
print("Answer 4")
distance = function(p, q) {
  dist=sqrt((p[1] - q[1])^2 + (p[2]-q[2])^2)
  return(dist)
}
find_labels = function(y, c1, c2) {
  labels = rep(NA, nrow(y))
  for (i in 1:nrow(y)) {
    if (distance(y[i,], c1) > distance(y[i,], c2)) {
      labels[i] = 2
    } else {
      labels[i] = 1
    }
  }
  return(labels)
}
labels = find_labels(y, c1, c2)
print(labels)

#---------------------------------------------------question 1)e-----------------------------------------
print("Answer 5")
finallabels = rep(0, 6)
while (!all(finallabels == labels)) {
  finallabels = labels
  c1 = c(mean(y[labels==1, 1]), mean(y[labels==1, 2]))
  c2 = c(mean(y[labels==2, 1]), mean(y[labels==2, 2]))
  print(c1)
  print(c2)
  labels = find_labels(y, c1, c2)
  print(labels)
}
#----------------------------------------------------question 1)f------------------------------------------
print("Answer 6")
plot.new()
frame()
plot(y[,1], y[,2], col=labels, pch=20)
points(c1[1], c1[2], col=1, pch=17)
points(c2[1], c2[2], col=2, pch=17)