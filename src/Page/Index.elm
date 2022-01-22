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
    Decode.map3
        Project
        (Decode.field "title" Decode.string)
        (Decode.field "link" Decode.string)
        (Decode.field "sameSite" Decode.bool)


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
    { title : String, link : String, sameSite : Bool }


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
            [ Html.div [ Attr.class "about-page__inner" ]
                [ Html.h1 []
                    [ Html.text content.tagLine
                    ]
                , Html.span [] []
                ]
            ]
        , Html.div [] [ Html.text content.description ]
        , Html.div []
            (List.map
                projectLink
                content.projects
            )
        , Html.div []
            (List.map
                projectLink
                content.talks
            )
        ]


projectLink : Project -> Html msg
projectLink p =
    if p.sameSite then
        Html.a [ Attr.href p.link ] [ Html.text p.title ]

    else
        Html.a [ Attr.href p.link, Attr.target "_blank" ] [ Html.text p.title ]
