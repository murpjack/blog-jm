module Types exposing (..)


type alias BlogPostMetadata =
    { body : String
    , slug : String
    , title : String
    , tags : List String
    , publishDate : IsoString
    , description : String
    }


type alias IsoString =
    String
