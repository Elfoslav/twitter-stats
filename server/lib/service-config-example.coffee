#uncomment and add your twitter consumerKey and secret
#if /localhost/.test(Meteor.absoluteUrl())
# App.twitter.consumerKey = "yourLocalhostKey"
# App.twitter.secret = "yourLocalhostSecret"
#else
# App.twitter.consumerKey = "yourKey"
# App.twitter.secret = "yourSecret"
#
#ServiceConfiguration.configurations.remove({
#  service: "twitter"
#});
#ServiceConfiguration.configurations.insert({
#  service: "twitter",
#  consumerKey: App.twitter.consumerKey,
#  loginStyle: "popup",
#  secret: App.twitter.secret
#});