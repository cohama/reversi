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
    Session.set("room_id", undefined)
    Session.set("player_name", undefined)
    Session.set("game_ready", undefined)

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

    'keyup, change #player-name': () ->
      player_name = $(":text#player-name").val()
      $entry_button = $("button#entry")
      if player_name == ""
        $("#player button").attr("disabled", "disabled")
      else
        $("#player button").removeAttr("disabled")

    'click #create-room': ->
      room_name = $(":text#room-name").val()
      room_id = Rooms.insert(name: room_name)
      for j in [1..8]
        for i in [1..8]
          stone = null
          if (i == 4 && j==4 || i==5 && j==5)
            stone = WhiteStone
          else if (i == 4 && j==5 || i==5 && j==4)
            stone = BlackStone
          else
            stone = BlankStone
          initStone = _.extend({room_id: room_id, i: i, j: j}, stone)
          Stones.insert initStone
      Session.set("room_id", room_id)

    'click #enter-room': () ->
      room_name = $(":text#room-name").val()
      Session.set("room_id", Rooms.findOne(name: room_name)._id)

    'click #entry': () ->
      room_id = Session.get("room_id")
      player_name = $(":text#player-name").val()
      Rooms.update({_id: room_id}, $push: {player: player_name})
      Session.set("player_name", player_name)


  Template.lobby.information = ->
    room = Rooms.findOne(_id: Session.get("room_id"))
    ret = ""
    ret += "<h3>Room: #{room.name}</h3>" if room
    if room?.player
      if room.player.length == 1
        if Session.get("player_name")
          ret += "<h3>Waiting for the adversary</h3>"
        else
          ret += "<h3>The adversary's name is #{room.player[0]}</h3>"
      else
        ret += "<h3>#{room.player[0]} vs #{room.player[1]}</h3>"
        Session.set("game_ready", true)
    ret

  Template.lobby.instruction = ->
    room = Rooms.findOne(_id: Session.get("room_id"))
    if room
      if Session.get("player_name")
        ""
      else
        "Input your name!"
    else
      "Input the room name!"

  Template.lobby.new_game = ->
    Session.get("room_id") == undefined

  Template.lobby.new_player = ->
    Session.get("room_id") && Session.get("player_name") == undefined

  Template.board.stones = ->
    return unless Session.equals("game_ready", true)
    room_id = Session.get("room_id")
    stones = Stones.find(room_id: room_id).fetch()
    _(stones)
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
    Rooms.remove({})

