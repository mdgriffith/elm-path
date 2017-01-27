module Main exposing (..)

import Html exposing (..)
import Html.Attributes
import Svg
import Svg.Attributes
import Curve exposing (Curve)


main =
    Html.beginnerProgram
        { view = view
        , model = 0
        , update = (\x -> x)
        }


(=>) =
    (,)


centered =
    [ "position" => "relative"
    , "margin" => "0 auto"
    , "width" => "1000px"
    ]


view : Int -> Html msg
view model =
    div
        [ Html.Attributes.style centered
        ]
        [ h1 [] [ text "test" ]
        , Svg.svg [ Svg.Attributes.width "1000", Svg.Attributes.height "1000" ]
            [ Svg.g []
                [ viewCurve <| Curve.line ( 50, 50 ) ( 200, 70 )
                , viewCurve <|
                    Curve.bezier
                        [ 50 => 250
                        , 200 => 100
                        , 300 => 300
                        , 400 => 250
                        , 500 => 150
                        ]
                , viewCurve <|
                    Curve.catmullRom ( 50, 500 )
                        ( 600, 570 )
                        [ 200 => 350
                        , 300 => 550
                        , 500 => 600
                        ]
                ]
            ]
        ]


viewCurve : Curve -> Html msg
viewCurve curve =
    let
        controls =
            Curve.controlPoints curve

        points =
            Curve.points curve 20

        controlLines =
            List.map2 (,) controls (List.drop 1 controls)
    in
        Svg.g []
            [ Svg.g []
                (List.map
                    (\( ( x1, y1 ), ( x2, y2 ) ) ->
                        Svg.line
                            [ Svg.Attributes.x1 (toString x1)
                            , Svg.Attributes.y1 (toString y1)
                            , Svg.Attributes.x2 (toString x2)
                            , Svg.Attributes.y2 (toString y2)
                            , Svg.Attributes.stroke "#ddd"
                            , Svg.Attributes.strokeDasharray "5,5"
                            , Svg.Attributes.fill "white"
                            , Svg.Attributes.fillOpacity "0"
                            ]
                            []
                    )
                    controlLines
                )
            , Svg.g []
                (List.map
                    (\( x, y ) ->
                        Svg.circle
                            [ Svg.Attributes.cx (toString x)
                            , Svg.Attributes.cy (toString y)
                            , Svg.Attributes.r (toString 2)
                            , Svg.Attributes.stroke "white"
                            , Svg.Attributes.fill "blue"
                            , Svg.Attributes.fillOpacity "1"
                            ]
                            []
                    )
                    points
                )
            , Svg.g []
                (List.concatMap
                    (\( x, y ) ->
                        [ Svg.circle
                            [ Svg.Attributes.cx (toString x)
                            , Svg.Attributes.cy (toString y)
                            , Svg.Attributes.r (toString 8)
                            , Svg.Attributes.strokeWidth "0"
                            , Svg.Attributes.fill "white"
                            , Svg.Attributes.fillOpacity "1"
                            ]
                            []
                        , Svg.circle
                            [ Svg.Attributes.cx (toString x)
                            , Svg.Attributes.cy (toString y)
                            , Svg.Attributes.r (toString 5)
                            , Svg.Attributes.stroke "black"
                            , Svg.Attributes.fill "white"
                            , Svg.Attributes.fillOpacity "1"
                            ]
                            []
                        ]
                    )
                    controls
                )
            ]
