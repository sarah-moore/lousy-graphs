anes2020 <- read_csv('https://raw.githubusercontent.com/sarah-moore/lousy-graphs/main/data/2020_ANES.csv')

anes2020 %>%
  select(resp_id = V200001,
         resp_pres_vote = V201028,
         resp_pol_arg = V202024,
         resp_protest = V202025,
         resp_state_reg = V201014e,
         resp_hopeful = V201115,
         resp_sex = V201600) -> anes_sub

bad_values <- c(-1, -2, -5, -6, -7, -8, -9)

anes_sub %>%
  mutate(across(everything(), na_if_in, bad_values)) -> anes_clean_sub

any(anes_clean_sub[anes_clean_sub<0])

anes_clean_sub$resp_pres_vote <- if_else(anes_clean_sub$resp_pres_vote == 2, 0, anes_clean_sub$resp_pres_vote)

anes_clean_sub %>%
  filter(!is.na(resp_sex), !is.na(resp_state_reg)) %>%
  ggplot(aes(y = resp_pres_vote, x = as_factor(resp_sex))) +
  geom_point(stat = "summary", fun = "mean") +
  ylim(0, 1) +
  facet_wrap(~resp_pol_arg) -> pol_arg_gg

pol_arg_gg
?facet_wrap
