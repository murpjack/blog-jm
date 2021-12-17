module View exposing (View, map, placeholder)

import Html exposing (Html)
import Types exposing (BlogPostMetadata)


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }


placeholder : BlogPostMetadata -> View msg
placeholder blogPost =
    { title = blogPost.title
    , body =
        [ Html.div []
            [ Html.h2 [] [ Html.text blogPost.title ]
            , Html.text (" Tags: " ++ String.join " " blogPost.tags)
            ]
        , Html.div []
            [ Html.text blogPost.body
            ]
        ]
    }
