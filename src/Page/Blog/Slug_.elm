module Page.Blog.Slug_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File as File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/technical-blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


data : RouteParams -> DataSource Data
data routeParams =
    blogPost routeParams.slug


blogPost : String -> DataSource BlogPostMetadata
blogPost slug =
    File.bodyWithFrontmatter blogPostDecoder
        ("content/technical-blog/" ++ slug ++ ".md")


type alias BlogPostMetadata =
    { body : String
    , title : String
    , tags : List String
    }


blogPostDecoder : String -> Decoder BlogPostMetadata
blogPostDecoder body =
    Decode.map2 (BlogPostMetadata body)
        (Decode.field "title" Decode.string)
        (Decode.field "tags" tagsDecoder)


tagsDecoder : Decoder (List String)
tagsDecoder =
    Decode.list Decode.string


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


type alias Data =
    BlogPostMetadata


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    View.placeholder ("Title: " ++ static.data.title ++ " Tags: " ++ String.join " " static.data.tags ++ " content: " ++ static.data.body)
