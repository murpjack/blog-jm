module Page.Technical exposing (Data, Model, Msg, page, view)

import DataSource exposing (DataSource)
import DataSource.File as File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Types exposing (BlogPostMetadata)
import Utils as U
import View exposing (View, header)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List BlogPostMetadata


data : DataSource (List BlogPostMetadata)
data =
    blogPostsFiles
        |> DataSource.map
            (List.map
                (File.bodyWithFrontmatter blogPostDecoder)
            )
        |> DataSource.resolve


blogPostsFiles : DataSource (List String)
blogPostsFiles =
    Glob.succeed identity
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/technical/")
        |> Glob.match Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


blogPostDecoder : String -> Decoder BlogPostMetadata
blogPostDecoder renderedMarkdown =
    Decode.map4 (BlogPostMetadata renderedMarkdown)
        (Decode.field "slug" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "publishDate" Decode.string)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Blog"
    , body =
        [ Html.div []
            [ header
            , Html.div [] (List.map articleMeta static.data)
            ]
        ]
    }


articleMeta : BlogPostMetadata -> Html msg
articleMeta blogPost =
    Html.div []
        [ Html.div []
            [ Html.a [ Attr.href ("/technical/" ++ blogPost.slug) ]
                [ Html.text blogPost.title
                ]
            , Html.div [] [ Html.text (" Tags: " ++ String.join " " blogPost.tags) ]
            , Html.div [] [ Html.text ("Date published: " ++ U.formatIsoString blogPost.publishDate) ]
            , Html.div [] [ Html.text ("Read time: " ++ U.timeToRead blogPost.body) ]
            ]
        ]
