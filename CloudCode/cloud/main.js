
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("changeChore", function(request, response) {
  Parse.Cloud.useMasterKey();
  var user = new Parse.User();
  var query = new Parse.Query(Parse.User);
  query.equalTo("objectId", request.params.objectIDOfUser);
  query.first({
     success: function(object) {
        object.set("currentChores", request.params.newUserChoresList);
        object.save();
        response.success("currentChores successfully updated!");
     },
     error: function(error) {
        alert("Error: " + error.code + " " + error.message);
        response.error("Error Message");
     }
  });
});

Parse.Cloud.define("housePush", function(request, response) {
  var message = request.params.message;
  
  Parse.Push.send({
    channels: [ request.params.houseID ],
    data: {
      alert: message,
      badge: "Increment"
    }
  }).then(function() {
    response.success("Event push sent successfully.")
  }, function(error) {
    response.error("Event push failed to send with error: " + error.message);
  });
});

Parse.Cloud.define("todoPush", function(request, response) {
  var message = request.params.message;

  Parse.Push.send({
    channels: [ request.params.objectIDOfUser ],
    data: {
      alert: message,
      badge: "Increment"
    }
  }).then(function() {
    response.success("Event push sent successfully.")
  }, function(error) {
    response.error("Event push failed to send with error: " + error.message);
  });
});