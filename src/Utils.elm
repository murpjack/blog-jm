module Utils exposing (formatIsoString, isValidUrl, timeToRead)

import Date
import Regex
import Types exposing (IsoString)


formatIsoString : IsoString -> String
formatIsoString str =
    case Date.fromIsoString str of
        Ok date ->
            Date.format "EEEE, d MMMM y" date

        Err _ ->
            "-"


timeToRead : String -> String
timeToRead postBody =
    let
        avgPace =
            245

        numWordsInBody =
            List.length (String.words postBody)

        timeInSeconds =
            round ((toFloat numWordsInBody / avgPace) * 60)

        minutesFromSeconds =
            timeInSeconds // 60

        minuteOrMinutes =
            if (timeInSeconds // 60 == 1) && (modBy 60 timeInSeconds == 0) then
                " minute"

            else
                " minutes"
    in
    if (timeInSeconds // 60 == 0) && (modBy 60 timeInSeconds < 60) then
        "less than a minute"

    else if modBy 60 timeInSeconds < 30 then
        String.fromInt minutesFromSeconds ++ "½" ++ minuteOrMinutes

    else
        String.fromInt minutesFromSeconds ++ minuteOrMinutes



-- Taken from package iodevs/elm-validate - https://github.com/iodevs/elm-validate/blob/3.0.3/src/Validators.elm


isValidUrl : String -> Bool
isValidUrl value =
    Regex.contains validUrlPattern value


validUrlPattern : Regex.Regex
validUrlPattern =
    --"^(?:(?:https?|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3})(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:/[^\\s]*)?$"
    "^(?:(?:https?|ftp)://)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:\\/\\S*)?$"
        |> Regex.fromString
        |> Maybe.withDefault Regex.never
