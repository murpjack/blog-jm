module Page.Blog exposing (Data, Model, Msg, page, view)

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
import View exposing (View, globalPageLayout)


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
    Decode.map5 (BlogPostMetadata renderedMarkdown)
        (Decode.field "slug" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "publishDate" Decode.string)
        (Decode.field "description" Decode.string)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Jack Murphy"
        , image =
            { url = Pages.Url.external ""
            , alt = "Jack Murphy blog site logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome. My name is Jack Murphy and this is my blog, where I document what I'm learning and write about technical topics."
        , locale = Nothing
        , title = "Blog | Jack Murphy"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Blog | Jack Murphy"
    , body =
        globalPageLayout
            [ Html.div [ Attr.class "blog__list" ] (List.map articleMeta static.data) ]
    }


articleMeta : BlogPostMetadata -> Html msg
articleMeta blogPost =
    Html.div []
        [ Html.p [] [ Html.text ("Posted on " ++ U.formatIsoString blogPost.publishDate) ]
        , Html.a [ Attr.href ("/blog/" ++ blogPost.slug) ]
            [ Html.h2 [] [ Html.text blogPost.title ]
            ]
        , Html.p [] [ Html.text blogPost.description ]
        ]
