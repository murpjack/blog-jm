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
        postBody =
            case
                blogPost.body
                    |> markdownToView
            of
                Ok renderedMarkdown ->
                    Html.div [] renderedMarkdown

                Err error ->
                    Html.div [] [ Html.text error ]
    in
    { title = blogPost.title ++ " | Jack Murphy"
    , body =
        globalPageLayout
            [ Html.div [ Attr.class "post" ]
                [ Html.p [] [ Html.text ("Posted on " ++ U.formatIsoString blogPost.publishDate) ]
                , Html.h2 [] [ Html.text blogPost.title ]
                , Html.p [] [ Html.text ("You will read this in " ++ U.timeToRead blogPost.body ++ ".") ]
                , Html.div [] [ postBody ]
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
    ]


header : Html msg
header =
    Html.div
        [ Attr.class "header" ]
        [ Html.a [ Attr.href "/" ] [ Html.text "Jack Murphy" ]
        , Html.a [ Attr.href "/blog" ] [ Html.text "Blog" ]
        ]
