Stones = new Meteor.Collection("stones")
Rooms = new Meteor.Collection("rooms")

BlankStone =
  text: "*"

WhiteStone =
  text: "○"

BlackStone =
  text: "●"

if Meteor.is_client
  Meteor.startup ->
    console.log "startup"
    Session.set("room_id", undefined)

  Template.lobby.events =
    'keyup, change #room-name': (e) ->
      room_name = $(":text#room-name").val()
      $create_button = $("button#create-room")
      $enter_button = $("button#enter-room")
      if room_name == ""
        $("#room button").attr("disabled", "disabled")
      else
        $("#room button").removeAttr("disabled")
        if Rooms.find(name: room_name).count() == 0
          $create_button.show()
          $enter_button.hide()
        else
          $create_button.hide()
          $enter_button.show()

    'click #create-room': ->
      room_name = $(":text#room-name").val()
      room_id = Rooms.insert(name: room_name)
      Session.set("room_id", room_id)

    'click #enter-room': () ->
      room_name = $(":text#room-name").val()
      Session.set("room_id", Rooms.findOne(name: room_name)._id)

  Template.lobby.information = ->
    room = Rooms.findOne(_id: Session.get("room_id"))
    "Room: #{room.name}" if room

  Template.lobby.instruction = ->
    room = Rooms.findOne(_id: Session.get("room_id"))
    if room
      "Input your name!"
    else
      "Input the room name!"

  Template.lobby.new_game = ->
    Session.get("room_id") == undefined

  Template.board.stones = ->
    _(Stones.find().fetch())
      .chain()
      .groupBy("j")
      .toArray()
      .value()

  Template.board.events =
    'click td': (e) ->
      i = $(e.target).attr('i') - 0
      j = $(e.target).attr('j') - 0
      Stones.update({i: i, j: j}, _.extend({i: i, j: j}, WhiteStone))

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


