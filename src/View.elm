module View exposing (View, globalPageLayout, header, map, placeholder)

import Html exposing (Html)
import Html.Attributes as Attr
import Markdown.Parser
import Markdown.Renderer
import Types exposing (BlogPostMetadata)
import Utils as U


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
    let
        -- TODO: Refactor and abstract 'postBody -> renderedMarkdown' out of 'placeholder'.
        postBody =
            case
                blogPost.body
                    |> markdownToView
            of
                Ok renderedMarkdown ->
                    Html.div [] renderedMarkdown

                Err error ->
                    Html.div [] [ Html.text error ]

        -- |> Decode.fromResult
    in
    { title = blogPost.title
    , body =
        globalPageLayout
            -- TODO: Remove this link to '/blog' once the header includes one.
            [ Html.h2 [] [ Html.text blogPost.title ]
            , Html.div [] [ Html.text (" Tags: " ++ String.join " " blogPost.tags) ]
            , Html.div [] [ Html.text ("Date published: " ++ U.formatIsoString blogPost.publishDate) ]
            , Html.div []
                [ Html.div [] [ Html.text ("Read time: " ++ U.timeToRead blogPost.body) ]
                , postBody
                ]
            ]
    }


markdownToView :
    String
    -> Result String (List (Html msg))
markdownToView markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    Markdown.Renderer.defaultHtmlRenderer
                    blocks
            )


globalPageLayout : List (Html msg) -> List (Html msg)
globalPageLayout inside =
    [ header
    , Html.div [ Attr.class "wrapper" ]
        inside
    , footer
    ]


header : Html msg
header =
    Html.div
        [ Attr.class "header"
        , Attr.class "wrapper"
        ]
        [ Html.a [ Attr.href "/" ] [ Html.text "Jack Murphy" ]
        , Html.div []
            [ Html.a [ Attr.href "/cv" ] [ Html.text "CV" ]
            , Html.a [ Attr.href "/technical" ]
                [ Html.p [] [ Html.text "Blog" ]
                , Html.p [] [ Html.text "(Technical)" ]
                ]
            ]
        ]


footer : Html msg
footer =
    Html.div [ Attr.class "footer" ]
        [ Html.div [ Attr.class "wrapper" ]
            [ Html.div []
                [ Html.a [ Attr.href "/cv" ] [ Html.text "CV" ]
                , Html.a [ Attr.href "/technical" ]
                    [ Html.p [] [ Html.text "Blog" ]
                    , Html.p [] [ Html.text "(Technical)" ]
                    ]
                ]
            ]
        ]
