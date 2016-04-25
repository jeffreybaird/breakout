# Breakout

[Details on the Game](https://en.wikipedia.org/wiki/Breakout_(video_game))

# [Demo](http://jeffreyleebaird.com/breakout)

## To Develop

1. Install elm 0.16
2. Fork this repo
3. Clone it locally
4. cd into the directory
5. Run `$elm make breakout.elm`
6. Agree to the prompts

## To Do List:

Must have:

0. ~~A canvas that compiles~~
1. ~~Add a paddle that responds to key inputs~~
2. ~~Add a ball that bounces off the walls and paddles~~
3. ~~Add bricks that the ball bounces off of.~~
4. ~~Remove bricks when the ball hits the Bricks~~
5. ~~Multiple rows of bricks~~
6. ~~Game restarts once the ball goes out of play~~
7. ~~Game is started with the press of the space bar~~
8. A method for scoring and displaying the score
9. "Game Over" is displayed along with the score. Player restarts the game.

Should have:

1. Every time a row of bricks goes away, the ball goes faster
2. Every time a row of bricks goes away, the paddle gets smaller
3. When a row of bricks disappears, a new one appears behind it.
4. Ball starts from the paddle
5. User picks direction for initial shot

Nice to have:

1. Each row of bricks is a different Color
2. Animation when the brick is hit
3. the paddle bounces slightly off each wall
4. Sounds play when the ball hits the paddle and the bricks
5. Motion of the paddle affects angle of ball

Known Bugs:

1. The ball sometimes goes through the paddle
2. The ball sometimes goes through the back side of a brick.
3. The ball sometimes appears to change direction without hitting anything
