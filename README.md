# Resume Driven Development (RDD)

Created in response to https://gist.github.com/mkk-fullscreen/3409c24af7c2ac26fb824d0bd799e216

Clone and bundle:
```
git clone git@github.com:earoberson/rdd.git && cd rdd && bundle
```

To run tests:
```
rake test
```

To run:
```
./rdd.rb
```

``` sh
rdd [--after DATETIME] [--before DATETIME] [--top COUNT]

rdd --after 2015-03-18T13:00:00Z
rdd --after 2015-08-05T15:10:02-00:00
rdd --after 2015-03-16
rdd --top 500
rdd --after 2015-01-01 --before 2015-01-08
```

```
  Options:
    [--after=AFTER]    # Date to start search at, ISO8601 or YYYY-MM-DD format
                       # Default: 28 days ago
    [--before=BEFORE]  # ISO8601 Date to end search at, ISO8601 or YYYY-MM-DD format
                       # Default: Now
    [--top=N]          # The number of repos to show
                       # Default: 20
```

#### Output Example:
```
./rdd.rb --after 2015-08-05T20:10:02-00:00 --top 20
Getting Github statistics for 2015-08-05 20:10:02 UTC - 2015-08-05 21:56:30 UTC
Results (~15 seconds):
#1. jtleek/datasharing - 70 points
#2. docker/libcompose - 59 points
#3. daveliepmann/tufte-css - 52 points
#4. rdpeng/ExData_Plotting1 - 50 points
#5. DataScienceSpecialization/DataScienceSpecialization.github.io - 49 points
#6. servant-app/JAWS - 43 points
#7. octocat/Spoon-Knife - 40 points
#8. skirmer/R_Coursera_Cleaning - 30 points
#9. JuanitoFatas/fast-ruby - 25 points
#10. WasatchInstitute/wit-website - 25 points
#11. sux13/DataScienceSpCourseNotes - 25 points
#12. familiar-protein/familiar-protein - 25 points
#13. reactoroverflow/reactoroverflow.com - 22 points
#14. trilkk/faemiyah-demoscene_2015-08_4k-intro_ghosts_of_mars - 22 points
#15. FreeCodeCamp/freecodecamp - 21 points
#16. mkolh/nodeschool-module-solutions - 20 points
#17. normanjaeckel/Lotophage - 20 points
#18. jbsturgeon/tourOfGo - 20 points
#19. lopezjorge1/ColorGenius - 20 points
#20. travishaby/sales_engine - 20 points
```


#### Scoring:
* 10 points if its a [new repo](https://developer.github.com/v3/activity/events/types/#createevent)
* 5 points if a repo is [forked](https://developer.github.com/v3/activity/events/types/#forkevent)
* 3 points when a repo has a [member added](https://developer.github.com/v3/activity/events/types/#memberevent)
* 2 point when a pull request is [closed & merged](https://developer.github.com/v3/activity/events/types/#pullrequestevent)
* 1 point for the repo when the repo is [watched](https://developer.github.com/v3/activity/events/types/#watchevent)
* 1 points when the repo has an [issue created](https://developer.github.com/v3/activity/events/types/#issuesevent)
