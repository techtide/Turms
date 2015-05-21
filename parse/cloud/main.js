//arman
Parse.Cloud.afterSave("CustomMessage", function(request, response) {
  // Notify
  var query = new Parse.Query(Parse.Installation);
      query.equalTo('user', request.object.get('toUser'));

      Parse.Push.send({
          'where': query,
          'data': {
              'alert': "You've got a new message from " + toUser
          }
}, {
success: function() {
// Push was successful
response.success();
},
error: function(error) {
throw "Got an error " + error.code + " : " + error.message;
response.error();
}
});
});
