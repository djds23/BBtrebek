Swipe for Jeopardy Questions!

<img width="432" alt="screen shot 2015-12-01 at 9 12 09 pm" src="https://cloud.githubusercontent.com/assets/5833968/11520328/7aafd2b8-9870-11e5-9cfd-df6c3b2345bc.png">

TODO:
  * either fix the randomizer in the rails app, or shuffle questions in app, you should only get 1 q per category every 50 questions
  * have the concept of players & a game, maybe swipe to different parts of the screen to add to different players scores
    - [x] players model has been implemented
    - [ ] save players, or common players and their scores
    - [ ] allow players to skip questions, (once a question is answered it should remain skipped, blue and red questions should be separate)
    - [x] actually use players to create a game, make buttons with player names
      * swipe top of the screen for new question, award the points when you tap a players name
  * format text nicely in Answers/categories. Questions look generally okay.
  - [x] move views to scroll view
  - [x] ADD TESTS!
