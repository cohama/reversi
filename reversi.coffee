Stones = new Meteor.Collection("stones")

BlankStone =
  text: "*"

WhiteStone =
  text: "○"

BlackStone =
  text: "●"

if Meteor.is_client
  Template.board.stones = ->
    _(Stones.find().fetch())
      .chain()
      .groupBy("j")
      .toArray()
      .value()

if Meteor.is_server
  Meteor.startup ->
    if Stones.find().count() == 0
      for j in [1..8]
        for i in [1..8]
          stone = null
          if (i == 4 && j==4 || i==5 && j==5)
            stone = WhiteStone
          else if (i == 4 && j==5 || i==5 && j==4)
            stone = BlackStone
          else
            stone = BlankStone
          initStone = _.extend({i: i, j: j}, stone)
          Stones.insert initStone


