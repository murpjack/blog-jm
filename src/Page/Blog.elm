module Page.Blog exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


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
    List PostMeta


type alias PostMeta =
    { filePath : String
    , slug : String
    }


data : DataSource Data
data =
    blogPostsGlob



-- DataSource.succeed ()


blogPostsGlob : DataSource Data
blogPostsGlob =
    Glob.succeed
        (\capture1 capture2 capture3 ->
            { filePath = capture1 ++ capture2 ++ capture3
            , slug = capture2
            }
        )
        |> Glob.capture (Glob.literal "content/technical/")
        |> Glob.capture Glob.wildcard
        |> Glob.capture (Glob.literal ".md")
        |> Glob.toDataSource


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
    , body = List.map articleMeta static.data
    }


articleMeta : PostMeta -> Html msg
articleMeta post =
    Html.div []
        [ Html.div []
            [ Html.text post.filePath
            ]
        , Html.div []
            [ Html.text post.slug
            ]
        ]
