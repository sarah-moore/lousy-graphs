# Week 3/Week 4: polisci 390 visualizing political data 

# This code will walk you through making iterations of visualizations appropriate for working with the following data: 
anes2020 <- read_csv('https://raw.githubusercontent.com/sarah-moore/lousy-graphs/main/data/2020_ANES.csv')

anes2020 %>% 
  select(resp_pres_vote = V201028, 
         resp_pol_argument = V202024, 
         resp_part_protest = V202025, 
         resp_state_reg = V201014e, 
         resp_hopeful = V201115, 
         resp_sex = V201600) -> anes_sub

bad_values <- c(-1, -2, -5, -6, -7, -8, -9)

# use some fancy tricks and a new function to get the bad values out 
# i also want to make this code so that the 2s are 0s for the voting, argument, 
# protest, and sex variables!

anes_sub %>%
  mutate(across(everything(), na_if_in, bad_values), 
         across(c(1:3,6), ~ifelse(.x == 2, 0, .x)))-> anes_clean_sub

# first let's make a histogram for each of the variables we can do this by faceting!
# we will also have to use a new package called reshape 
library(reshape2)

ggplot(melt(anes_clean_sub), aes(x = as_factor(value))) + 
  facet_wrap(~ variable, scales = "free", ncol = 2) + 
  geom_bar(binwidth = .5)


# that's a cool trick! 

# ok, now let's see what we have to say about people that live in a state with 
# voter registration and their propensity to engage in a political argument 
# we will also add a facet across genders 

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex)

# now we will change the labels for the axes

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex) + 
  
  # add labels! 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument")

# let's change value lables now 

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  # Only makes sense to change x-axis as it is
  scale_x_discrete(labels = c("No", "Yes"))

# now change facet labels 

# create a vector of the labels 
resp_sex_lab <- list("Male", "Female")
names(resp_sex_lab) <- c(0, 1)
anes_clean_sub$resp_sex <-as_factor(anes_clean_sub$resp_sex)

# create a function that specifies the function to name the labels
sex_labeller <- function(variable,value){
  return(resp_sex_lab[value])
}

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex, labeller=sex_labeller) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  scale_x_discrete(labels = c("No", "Yes")) 

# we can also change the theme 
library(ggthemes)

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex, labeller=sex_labeller) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  scale_x_discrete(labels = c("No", "Yes")) + 
  theme_bw()


anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex, labeller=sex_labeller) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  scale_x_discrete(labels = c("No", "Yes")) + 
  theme_linedraw()

anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex, labeller=sex_labeller) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  scale_x_discrete(labels = c("No", "Yes")) + 
  theme_wsj()


anes_clean_sub %>% 
  filter(!is.na(resp_state_reg), !is.na(resp_sex)) %>%
  ggplot(aes(x = as_factor(resp_state_reg), y = resp_pol_argument)) + 
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) + 
  facet_wrap(~ resp_sex, labeller=sex_labeller) + 
  labs(x = "Party Registration in Respondent State", 
       y = "Proportion of Respondents that Engaged in a Political Argument") +
  scale_x_discrete(labels = c("No", "Yes")) + 
  theme_fivethirtyeight()
