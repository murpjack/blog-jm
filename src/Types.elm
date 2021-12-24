module Types exposing (..)

import Date exposing (Date)


type alias BlogPostMetadata =
    { body : String
    , title : String
    , tags : List String
    }


type alias BlogPostFront =
    { slug : String
    , title : String
    , tags : List String
    , publishDate : IsoString

    -- , publishDate : Date
    }


type alias IsoString =
    String
