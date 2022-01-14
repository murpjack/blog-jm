module Page.Cn exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Page.Index exposing (Language(..), Project, aboutPageDecoder, aboutPageView)
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


data : DataSource Data
data =
    aboutPageDecoder CN


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
    { tagLine : String
    , description : String
    , projects :
        List Project
    , talks :
        List Project
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
    , body = aboutPageView content
    }
