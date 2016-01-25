#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__)

# require_relative './config/enviroment'
# require_relative './clients4'
require 'koala'
# require 'aws-sdk'
require 'dotenv'
Dotenv.load

@graph = Koala::Facebook::API.new("CAACEdEose0cBAIFOLE3mb0qh9wFLVlZC4W43gbRXSORHERlRsdKrIAnyZBGF4IDCezIkorLdjBctOwPN4Nt32UtALOlTuSTcBqrD33LZCBNcmyCBdJrJS9w2GA6kO5rVbVOrTjYX5BTXfOBDacjZCI7cscKe8ZAu7fuI77kTupVVZAuOSiRDN725mGQEubf0rfJzpWgkSBgbMcQFtNmQO9")

profile = @graph.get_object("me")
profile
friends = @graph.get_connections("me", "photos")
puts friends
@graph.put_connections("me", "feed", message: "I am writing on my wall!")

# Three-part queries are easy too!
# @graph.get_connections("me", "mutualfriends/#{friend_id}")

# You can use the Timeline API:
# (see https://developers.facebook.com/docs/beta/opengraph/tutorial/)
# @graph.put_connections("me", "namespace:action", object: object_url)

# For extra security (recommended), you can provide an appsecret parameter,
# tying your access tokens to your app secret.
# (See https://developers.facebook.com/docs/reference/api/securing-graph-api/
# You'll need to turn on 'Require proof on all calls' in the advanced section
# of your app's settings when doing this.
# @graph = Koala::Facebook::API.new(943285442420441, a78b92d6e3e4066c5eb72aba55ab70c1)

# Facebook is now versioning their API. # If you don't specify a version, Facebook
# will default to the oldest version your app is allowed to use. Note that apps
# created after f8 2014 *cannot* use the v1.0 API. See
# https://developers.facebook.com/docs/apps/versions for more information.
#
# You can specify version either globally:
Koala.config.api_version = "v2.0"
# or on a per-request basis
@graph.get_object("me", {}, api_version: "v2.0")