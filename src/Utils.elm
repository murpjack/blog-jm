module Utils exposing (..)

import Date
import Types exposing (IsoString)


formatIsoString : IsoString -> String
formatIsoString str =
    case Date.fromIsoString str of
        Ok date ->
            Date.format "EEEE, d MMMM y" date

        Err _ ->
            "-"
