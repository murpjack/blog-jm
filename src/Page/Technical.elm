module Page.Technical exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File as File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Page.Blog exposing (view)
import Pages.Url
import Types exposing (BlogPostMetadata)


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
    allMetadata


blogPostsFiles : DataSource (List String)
blogPostsFiles =
    Glob.succeed identity
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/technical/")
        |> Glob.match Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


allMetadata : DataSource (List BlogPostMetadata)
allMetadata =
    blogPostsFiles
        |> DataSource.map
            (List.map
                (File.bodyWithFrontmatter blogPostDecoder)
            )
        |> DataSource.resolve


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
