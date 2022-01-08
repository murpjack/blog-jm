module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
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


data : DataSource Data
data =
    DataSource.succeed ()


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
    ()



-- TODO: Abstract content copy to a separate file - maybe JSON or .po file?


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    let
        content =
            { tagLine = "Hello simple website."
            , description = "My name is Jack. I make things"
            , projects =
                [ { title = "proj1"
                  , link = "abc.co.uk"
                  }
                ]
            , talks =
                [ { title = "talk1"
                  , link = "abc.co.uk"
                  }
                ]
            }
    in
    { title = "Blog"
    , body =
        [ header
        , Html.div []
            [ Html.div [] [ Html.text content.tagLine ]
            , Html.div [] [ Html.text content.description ]
            , Html.div []
                (List.map
                    (\val ->
                        Html.div []
                            [ Html.a [ Attr.href val.link, Attr.target "_blank" ] [ Html.text val.title ] ]
                    )
                    content.projects
                )
            , Html.div []
                (List.map
                    (\val ->
                        Html.div []
                            [ Html.a [ Attr.href val.link, Attr.target "_blank" ] [ Html.text val.title ] ]
                    )
                    content.talks
                )
            ]
        ]
    }
