if Meteor.is_client
  Template.hello.greeting = -> "Welcome to reversi."

  Template.hello.events =
    'click input' : ->
      # template data, if any, is available in 'this'
      console?.log("You pressed the button")

if Meteor.is_server
  Meteor.startup( -> )

