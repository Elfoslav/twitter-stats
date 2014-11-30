numOfTweets = 200

if Meteor.isClient
  Session.set('tweets', null)

  #client collection
  # {
  # text: String
  # count: Number
  #}
  @Hashtags = new Mongo.Collection(null) #it creates local/client collection with null parameter
  #remove data on refresh
  Hashtags.remove({})

  insertHashtags = (tweets) ->
    hashtags = []
    tweets.forEach((item) ->
      item.entities.hashtags.forEach((hashtag) ->
        if Hashtags.findOne({ text: hashtag.text })
          Hashtags.update({ text: hashtag.text }, { $inc: { count: 1 }})
        else
          Hashtags.insert(
            text: hashtag.text
            count: 1
          )
      )
    )
    hashtags

  Template.hello.helpers({
    tweets: ->
      unless Session.get('tweets')?
        Meteor.call('getTweets', (err, res) ->
          if err
            console.log 'Err: ', err
          else
            Session.set 'tweets', res.data
            insertHashtags(res.data)
        )
      Session.get 'tweets'
    loadingTweets: ->
      !Session.get 'tweets'
    hashtags: ->
      Hashtags.find({}, { sort: { count: -1 }}).fetch()
    tweetText: ->
      tags = Hashtags.find({}, { sort: { count: -1 }, limit: 3 }).fetch()
      tagsText = ''
      i = 0
      while i < tags.length
        tagsText += "##{tags[i].text} "
        i++
      console.log 'tags: ', tags
      console.log 'tagsText: ', tagsText
      "My most used tags are #{tagsText}Find out what are yours."
    numOfTweets: ->
      numOfTweets
  });

  Template.hello.events({
    'click .sign-in': ->
      Meteor.loginWithTwitter({}, (err) ->
        if err
          console.log('err: ', err);
      );
    'click .sign-out': ->
      Meteor.logout()
  });

if Meteor.isServer
  twitter = new TwitterApi()

  Meteor.methods(
    getTweets: (query) ->
      return twitter.get('statuses/user_timeline.json', {
        count: numOfTweets
      });
    getUserTimeline: ->
      return twitter.userTimeline()
  )