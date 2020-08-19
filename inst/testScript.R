testEnv2 <- simmer()

testTraj <- trajectory("testTraj") %>% 
  set_global("testKey", 1, mod = "+", init = -4) %>% 
  log_(function() as.character(get_global(testEnv2, keys = "testKey"))) %>% 
  branch(option = function() ifelse(get_global(testEnv2, keys = "testKey") > 0, 1, 2),
         continue = c(TRUE, FALSE),
         trajectory("path 1") %>% log_("path1"),
         trajectory("path 2") %>% log_("path2")) %>% 
  log_("I'm here")

testEnv2 %>%
  add_generator("testEntity", testTraj, function() 1)

testEnv2 %>% run(10)

testEnv2 %>% get_mon_arrivals()
