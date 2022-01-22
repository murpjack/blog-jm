module Page.Cv exposing (Data, Model, Msg, page)

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
    cvDecoder


cvDecoder : DataSource Data
cvDecoder =
    File.jsonFile
        (Decode.field "data"
            (Decode.map8
                CvContent
                (Decode.field "firstNames" Decode.string)
                (Decode.field "givenNames" Decode.string)
                (Decode.field "familyName" Decode.string)
                (Decode.field "contactLinks" (Decode.list labelValueDecoder))
                (Decode.field "statement" Decode.string)
                (Decode.field "employment" (Decode.list employmentDecoder))
                (Decode.field "education" (Decode.list educationDecoder))
                (Decode.field "projects" (Decode.list projectDecoder))
            )
        )
        "/public/cv.json"


labelValueDecoder : Decoder LabelValue
labelValueDecoder =
    Decode.map2
        LabelValue
        (Decode.field "label" Decode.string)
        (Decode.field "value" Decode.string)


employmentDecoder : Decoder Employment
employmentDecoder =
    Decode.map3
        Employment
        (Decode.field "name" Decode.string)
        (Decode.field "position" Decode.string)
        (Decode.field "dates" (Decode.list Decode.string))


educationDecoder : Decoder Education
educationDecoder =
    Decode.map3
        Education
        (Decode.field "name" Decode.string)
        (Decode.field "certifications" Decode.string)
        (Decode.field "dates" (Decode.list Decode.string))


projectDecoder : Decoder Project
projectDecoder =
    Decode.map4
        Project
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
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
    CvContent


type alias CvContent =
    { firstNames : String
    , givenNames : String
    , familyName : String
    , contactLinks : List LabelValue
    , statement : String
    , employment : List Employment
    , education : List Education
    , projects : List Project
    }


type alias LabelValue =
    { value : String, label : String }


type alias Employment =
    { name : String
    , position : String
    , dates : List String
    }


type alias Education =
    { name : String
    , certifications : String
    , dates : List String
    }


type alias Project =
    { name : String
    , description : String
    , link : String
    , sameSite : Bool
    }


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
        cvPageView content
    }


cvPageView : Data -> List (Html Msg)
cvPageView content =
    globalPageLayout
        [ Html.div [ Attr.class "wrapper" ]
            [ Html.div [] [ Html.text content.firstNames ]
            , Html.div []
                (List.map
                    (\c -> Html.a [ Attr.href c.value, Attr.target "_blank" ] [ Html.text c.label ])
                    content.contactLinks
                )
            , Html.div [] [ Html.text content.statement ]
            , Html.div []
                (List.map
                    (\emp -> Html.div [] [ Html.text emp.name ])
                    content.employment
                )
            , Html.div []
                (List.map
                    (\emp -> Html.div [] [ Html.text emp.name ])
                    content.education
                )
            , Html.div []
                (List.map
                    projectLink
                    content.projects
                )
            ]
        ]


projectLink : Project -> Html msg
projectLink p =
    if p.sameSite then
        Html.a [ Attr.href p.link ] [ Html.text p.name ]

    else
        Html.a [ Attr.href p.link, Attr.target "_blank" ] [ Html.text p.name ]
