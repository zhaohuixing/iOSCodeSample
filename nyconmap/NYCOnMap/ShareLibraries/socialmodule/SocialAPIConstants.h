//
//  SocialAPIConstants.h
//  nyconmap
//
//  Created by ZXing on 2014-09-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __NOM_SOCIALAPICONSTANTS_H__
#define __NOM_SOCIALAPICONSTANTS_H__

#define TWITTER_TEXT_UPDATE_URL   @"https://api.twitter.com/1/statuses/update.json"
#define TWITTER_MEDIA_UPDATE_URL   @"https://api.twitter.com/1.1/statuses/update_with_media.json"
//@"https://api.twitter.com/1/statuses/update.json" //@"https://upload.twitter.com/1.1/media/upload.json" //@"https://api.twitter.com/1.1/statuses/update_with_media.json"

#define TWITTER_USER_SHOW_URL       @"https://api.twitter.com/1.1/users/show.json"

#define TWITTER_TWEET_SEARCH_URL    @"https://api.twitter.com/1.1/search/tweets.json"

#define TWITTER_TWEETBYUSER_SEARCH_URL    @"https://api.twitter.com/1.1/statuses/user_timeline.json"

#define TTPOST_KEY_STATUS                       @"status"
#define TTPOST_KEY_LATITUDE                     @"lat"
#define TTPOST_KEY_LONGITUDE                    @"long"
#define TTPOST_KEY_DISPLAYCOORDINATES           @"display_coordinates"

#define TTPOST_KEY_MEDIA_NAME_PARAMS            @"media[]"
#define TTPOST_KEY_MEDIA_TYPE_PARAMS            @"image/jpeg"
#define TTPOST_KEY_MEDIA_FILE_PARAMS            @"image.jpg"

#define TTUSERACCOUNT_KEY_USER_SHOWNAME          @"screen_name"

#define TTUSERACCOUNT_KEY_USER_GEOENABLE         @"geo_enabled"

#define TTPOST_TWEET_LENGTH                         140


#define TTSEARCH_KEY_STATUSES                       @"statuses"
#define TTSEARCH_KEY_GEO                            @"geo"
#define TTSEARCH_KEY_TYPE                           @"type"
#define TTSEARCH_KEY_POINT                          @"Point"
#define TTSEARCH_KEY_COORDINATES                    @"coordinates"
#define TTSEARCH_KEY_IDSTRING                       @"id_str"
#define TTSEARCH_KEY_ID                             @"id"

#define TTSEARCH_KEY_USER                           @"user"
#define TTSEARCH_KEY_NAME                           @"name"
#define TTSEARCH_KEY_SCREENNAME                     @"screen_name"
#define TTSEARCH_KEY_PROFILEIMAGEURLHTTPS           @"profile_image_url_https"
#define TTSEARCH_KEY_PROFILEIMAGEURL                @"profile_image_url"
#define TTSEARCH_KEY_CREATEDAT                      @"created_at"
#define TTSEARCH_KEY_ENTITIES                       @"entities"
#define TTSEARCH_KEY_MEDIA                          @"media"
#define TTSEARCH_KEY_MEDIAURLHTTPS                  @"media_url_https"
#define TTSEARCH_KEY_MEDIAURL                       @"media_url"

#endif
