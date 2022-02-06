module Page.Index exposing (AboutPageContent, Data, Language(..), Model, Msg, Project, aboutPageDecoder, aboutPageView, page)

import DataSource exposing (DataSource)
import DataSource.File as File
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Utils
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
    aboutPageDecoder EN



-- TODO: Implement translations using generated translations (.po)file with keys


aboutPageDecoder : Language -> DataSource Data
aboutPageDecoder l =
    File.jsonFile
        (Decode.field (getLanguageAbr l)
            (Decode.map4
                AboutPageContent
                (Decode.field "tagLine" Decode.string)
                (Decode.field "description" Decode.string)
                (Decode.field "projects" (Decode.list projectDecoder))
                (Decode.field "talks" (Decode.list projectDecoder))
            )
        )
        "/public/about.json"


type Language
    = EN
    | CN


getLanguageAbr : Language -> String
getLanguageAbr l =
    case l of
        EN ->
            "en"

        CN ->
            "cn"


projectDecoder : Decoder Project
projectDecoder =
    Decode.map2
        Project
        (Decode.field "title" Decode.string)
        (Decode.field "link" Decode.string)


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
    AboutPageContent


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
view maybeUrl sharedModel static =
    let
        content =
            static.data
    in
    { title = "Blog"
    , body =
        aboutPageView content
    }


aboutPageView : Data -> List (Html Msg)
aboutPageView content =
    globalPageLayout
        [ Html.div [ Attr.class "about-page" ]
            [ Html.div
                [ Attr.class "head"
                ]
                [ Html.div [ Attr.class "head__inner" ]
                    [ Html.h1 []
                        [ Html.text "WEL"
                        , Html.br [] []
                        , Html.text "COME"
                        , Html.span [] []
                        ]
                    ]
                ]
            , Html.div [ Attr.class "description" ]
                [ Html.div []
                    [ Html.img [ Attr.class "zigzag", Attr.src "./zigzag.png" ] []
                    , Html.p []
                        [ Html.text "Welcome to my corner of the web. "
                        , Html.text "My name is Jack Murphy and this site contains my projects, "
                        , Html.text "and blog posts on all manner of topics, how-tos and software best-practices."
                        , Html.br [] []
                        , Html.br [] []
                        ]
                    , Html.p []
                        [ Html.text "I'm a web developer with "
                        , Html.strong [] [ Html.text "experience building reliable, " ]
                        , Html.i [] [ Html.text "attractive" ]
                        , Html.strong [] [ Html.text " web solutions" ]
                        , Html.span [] []
                        ]
                    ]
                ]
            , Html.div
                [ Attr.class "subheader" ]
                [ Html.img [ Attr.class "zigzag", Attr.src "./zigzag.png" ] []
                , Html.h2 []
                    [ Html.text "Development"
                    ]
                , Html.p []
                    [ Html.text "Here are a few varied projects, on which I have worked"
                    , Html.span [] []
                    ]
                ]
            , Html.div []
                [ Html.div [ Attr.class "project__link" ]
                    [ projectLink { title = "Project1", link = "https://elm-pages.com/" }, Html.p [] [ Html.text "This is a description" ] ]
                , Html.div [ Attr.class "project__link" ]
                    [ projectLink { title = "Project2", link = "https://elm-pages.com/" }, Html.p [] [ Html.text "This is a description" ] ]
                , Html.div [ Attr.class "project__link" ]
                    [ projectLink { title = "The start of the Silk Roads", link = "https://elm-pages.com/" }, Html.p [] [ Html.text "This is a description" ] ]
                ]
            ]
        ]


projectLink : Project -> Html msg
projectLink p =
    let
        newPageOnClick =
            if Utils.isValidUrl p.link then
                [ Attr.target "_blank" ]

            else
                []
    in
    Html.a
        (Attr.href p.link
            :: newPageOnClick
        )
        [ Html.text p.title ]
