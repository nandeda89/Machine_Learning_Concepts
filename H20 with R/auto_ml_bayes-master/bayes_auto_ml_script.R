### loading data ####
#install.packages("mlbench")
library(mlbench)

data(BreastCancer)
str(BreastCancer)
summary(BreastCancer)


### data pre-processing ####

#install.packages('janitor')
library(janitor)

bc_edited =
  BreastCancer %>% clean_names() %>% # changes dots in colnames() to underscores
  select(-id) %>%
  mutate_if(is.factor, factor, ordered = FALSE) %>% 
  select(class, everything())

str(bc_edited)
summary(bc_edited)
head(bc_edited )



### h20 installation ####

#install.packages("h2o")
library(h2o)
        
h2o.init() # initializes Java Virtual Machine (JVM)
# h2o.no_progress() # Turn off output of progress bars

bc_h2o <- as.h2o(bc_edited)
split_h2o <- h2o.splitFrame(bc_h2o, c(0.7, 0.15), seed = 13 )

train_h2o <- h2o.assign(split_h2o[[1]], "train" ) # 70%
valid_h2o <- h2o.assign(split_h2o[[2]], "valid" ) # 15%
test_h2o  <- h2o.assign(split_h2o[[3]], "test" )  # 15%

# Set names for h2o
y <- "class"
x <- setdiff(names(train_h2o), y)        


#install.packages("lime")
library(lime)


# Run the automated machine learning 
models_h2o <- h2o.automl(
  x = x, 
  y = y,
  training_frame    = train_h2o,
  leaderboard_frame = valid_h2o,
  max_runtime_secs  = 30
)

### leaderboard

lb <- models_h2o@leaderboard
models_h2o@leader

h20_pred <- h2o.predict(models_h2o@leader, test_h2o[-1])


### performance 
??add_column

library(tibble)

test_performance <- test_h2o %>%
  tibble::as_tibble() %>%
  select(class) %>%
  tibble::add_column(prediction = as.vector(h20_pred$predict)) %>%
  mutate(correct = ifelse(class == prediction, "correct", "wrong")) %>% 
  mutate_if(is.character, as.factor)
test_performance

confusion_matrix <- test_performance %>% select(-correct) %>% table() 
confusion_matrix


#### Performance analysis ####
tn <- confusion_matrix[1]
tp <- confusion_matrix[4]
fp <- confusion_matrix[3]
fn <- confusion_matrix[2]

accuracy <- (tp + tn) / (tp + tn + fp + fn)
misclassification_rate <- 1 - accuracy
recall <- tp / (tp + fn)
precision <- tp / (tp + fp)
null_error_rate <- tn / (tp + tn + fp + fn)

library(purrr)

tibble(
  accuracy,
  misclassification_rate,
  recall,
  precision,
  null_error_rate
) %>% 
  purrr::transpose() 


#### LIME ####

class(models_h2o@leader)

# Setup lime::model_type() function for h2o
model_type.H2OBinomialModel <- function(x, ...) {
  return("classification")
}

# Setup lime::predict_model() function for h2o
predict_model.H2OBinomialModel <- function(x, newdata, type, ...) {
  pred <- h2o.predict(x, as.h2o(newdata))
  # return probs
  return(as.data.frame(pred[,-1]))
}

predict_model(x = models_h2o@leader, newdata = as.data.frame(test_h2o[,-1]), type = 'raw') %>%
  tibble::as_tibble()

### split correct and wrong prediction cases ####
head(test_performance)

head(test_h2o)

test_h2o_2 = test_h2o_df %>%
  mutate(sample_id = rownames(test_h2o_df ))

test_correct <- test_performance %>% 
  mutate(sample_id = rownames(test_performance)) %>% 
  filter(correct == 'correct') %>%
  left_join(test_h2o_2) %>% 
  select(-c(prediction, correct, sample_id))

test_wrong <- test_performance %>% 
  mutate(sample_id = rownames(test_performance)) %>% 
  filter(correct == 'wrong') %>%
  left_join(test_h2o_2) %>% 
  select(-c(prediction, correct, sample_id))
  
  



#### prediction ####
head(train_h2o)
str(train_h2o)

explainer <- lime::lime(
  as.data.frame(train_h2o[,-1]), 
  model          = models_h2o@leader, 
  bin_continuous = FALSE)

head(test_h2o)


explanation <- lime::explain(
  as.data.frame(test_h2o[1:10,-1]), 
  explainer    = explainer, 
  n_labels     = 1, 
  n_features   = 5,
  kernel_width = 0.5)

explanation_corr <- explain(
  test_correct[1:9, -1],
  explainer = explainer,
  n_labels = 1,
  n_features = 5,
  kernel_width = 0.5)


explanation_wrong <- explain(
  test_wrong[1:3, -1],
  explainer = explainer,
  n_labels = 1,
  n_features = 5,
  kernel_width = 0.5)


plot_features(explanation)
plot_features(explanation_corr)
plot_features(explanation_wrong)

