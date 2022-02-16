module Page.Index exposing (AboutPageContent, Data, Model, Msg, Project, aboutPageView, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
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


data : DataSource Data
data =
    DataSource.succeed ()


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
        , title = "Jack Murphy"
        }
        |> Seo.website


type alias Data =
    ()


type alias AboutPageContent =
    { tagLine : String
    , description : String
    , projects :
        List Project
    , talks :
        List Project
    }


type alias Project =
    { title : String, link : String }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    let
        content =
            static.data
    in
    { title = "Jack Murphy"
    , body =
        aboutPageView content
    }


aboutPageView : Data -> List (Html Msg)
aboutPageView _ =
    globalPageLayout
        [ Html.div [ Attr.class "about" ]
            [ Html.p []
                [ Html.text
                    ("""Welcome. My name is Jack Murphy and this is my blog, """
                        ++ """where I document what I'm learning and write about technical topics including, """
                        ++ """but not limited to JavaScript, TypeScript and Frontend technologies."""
                    )
                ]
            ]
        ]
