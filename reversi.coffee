cells = (([i, j] for i in [1..8]) for j in [1..8])

if Meteor.is_client
  Template.board.cells = cells

  Template.board.events =
    'click td' : (e) ->
      text = $(e.target).text()
      alert("You pressed the cell of #{text}")

if Meteor.is_server
  Meteor.startup( -> )

