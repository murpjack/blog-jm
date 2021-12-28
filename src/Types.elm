module Types exposing (..)


type alias BlogPostMetadata =
    { body : String
    , slug : String
    , title : String
    , tags : List String
    , publishDate : IsoString
    }


type alias BlogPostFront =
    { slug : String
    , title : String
    , tags : List String
    , publishDate : IsoString
    }


type alias IsoString =
    String
