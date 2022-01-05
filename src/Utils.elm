module Utils exposing (formatIsoString, timeToRead)

import Date
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
    if (timeInSeconds // 60 == 0) && (modBy 60 timeInSeconds < 30) then
        "less than a ½ minute"

    else if modBy 60 timeInSeconds < 30 then
        String.fromInt minutesFromSeconds ++ "½" ++ minuteOrMinutes

    else
        String.fromInt minutesFromSeconds ++ minuteOrMinutes
