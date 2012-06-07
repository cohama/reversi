blankStone =
  color: "blank"
  text: "□"

blackStone =
  color: "black"
  flip: flipBlackToWhite
  text: "●"

whiteStone =
  color: "white"
  flip: flipWhiteToBlack
  text: "○"

flipWhiteToBlack = ->
  _.clone blackStone

flipBlackToWhite = ->
  _.clone whiteStone

currentStone = (stone) ->
  if stone.color == "white"
    color: "black"
  else
    color: "white"



if Meteor.is_client
  Template.board.stones = stones =
    for j in [1..8]
      for i in [1..8]
        stone = _.clone blankStone
        stone.x = i
        stone.y = j
        stone

  Template.board.events =
    'click td' : (e) ->
      text = $(e.target).text()
      alert("You pressed the cell of #{text}")

if Meteor.is_server
  Meteor.startup( -> )

