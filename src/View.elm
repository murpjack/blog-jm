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
    , Html.div [ Attr.class "wrapper", Attr.class "content" ]
        inside
    , footer
    ]


header : Html msg
header =
    Html.div
        [ Attr.class "header"
        ]
        [ Html.div [ Attr.class "wrapper" ]
            [ Html.a [ Attr.href "/" ] [ Html.text "JACK MURPHY" ]
            , Html.div []
                [ Html.a [ Attr.href "/" ]
                    [ Html.text "ABOUT"
                    ]
                , Html.a [ Attr.href "/technical" ]
                    [ Html.text "BLOG"
                    ]
                ]
            ]
        ]


footer : Html msg
footer =
    Html.div [ Attr.class "footer" ]
        [ Html.div [ Attr.class "wrapper" ]
            [ Html.div []
                [ Html.a [ Attr.href "/technical" ]
                    [ Html.em [] [ Html.text "Browse my" ]
                    , Html.strong [] [ Html.text "BLOG" ]
                    ]
                , Html.a [ Attr.href "/" ]
                    [ Html.em [] [ Html.text "Keep in" ]
                    , Html.strong [] [ Html.text "CONTACT" ]
                    ]
                , Html.label [ Attr.class "language__switch" ]
                    [ Html.input [ Attr.type_ "checkbox" ] []
                    , Html.p [ Attr.class "languages" ]
                        [ Html.span [ Attr.class "en" ] [ Html.text "EN" ]
                        , Html.span [ Attr.class "cn" ] [ Html.text "CN" ]
                        ]
                    ]
                ]
            , Html.p [] [ Html.text "Elegantly written using Elm." ]
            ]
        ]
