module Main exposing (..)

import Html exposing (..)
import Html.Attributes
import Svg
import Svg.Attributes
import Curve exposing (Curve)
import Ease


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


easings =
    [ ( Ease.inSine, "inSine" )
    , ( Ease.outSine, "outSine" )
    , ( Ease.inOutSine, "inOutSine" )
    , ( Ease.inQuad, "inQuad" )
    , ( Ease.outQuad, "outQuad" )
    , ( Ease.inOutQuad, "inOutQuad" )
    , ( Ease.inCubic, "inCubic" )
    , ( Ease.outCubic, "outCubic" )
    , ( Ease.inOutCubic, "inOutCubic" )
    , ( Ease.inQuart, "inQuart" )
    , ( Ease.outQuart, "outQuart" )
    , ( Ease.inOutQuart, "inOutQuart" )
    , ( Ease.inQuint, "inQuint" )
    , ( Ease.outQuint, "outQuint" )
    , ( Ease.inOutQuint, "inOutQuint" )
    , ( Ease.inExpo, "inExpo" )
    , ( Ease.outExpo, "outExpo" )
    , ( Ease.inOutExpo, "inOutExpo" )
    , ( Ease.inCirc, "inCirc" )
    , ( Ease.outCirc, "outCirc" )
    , ( Ease.inOutCirc, "inOutCirc" )
    , ( Ease.inBack, "inBack" )
    , ( Ease.outBack, "outBack" )
    , ( Ease.inOutBack, "inOutBack" )
    , ( Ease.inElastic, "inElastic" )
    , ( Ease.outElastic, "outElastic" )
    , ( Ease.inOutElastic, "inOutElastic" )
    , ( Ease.inBounce, "inBounce" )
    , ( Ease.outBounce, "outBounce" )
    , ( Ease.inOutBounce, "inOutBounce" )
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
                    Curve.catmullRom
                        ( 50, 500 )
                        [ 200 => 350
                        , 300 => 550
                        , 500 => 600
                        ]
                        ( 600, 570 )
                ]
            ]
        , div []
            (List.map viewEasing easings)
        ]


easingStyle : List ( String, String )
easingStyle =
    [ "position" => "relative"
    , "background-color" => "#eee"
    , "margin" => "20px"
    ]


viewEasing : ( Float -> Float, String ) -> Html msg
viewEasing ( fn, name ) =
    let
        pointToCoords ( x, y ) =
            ( (x * 900) + 20, (y * 150) + 20 )

        points =
            Curve.fromEasing fn
                |> Curve.points 100
                |> List.map pointToCoords

        easeResolution =
            1000

        easedPoints =
            List.range 0 easeResolution
                |> List.map (pointToCoords << (\x -> ( x, fn x )) << (\x -> toFloat x / toFloat easeResolution))
    in
        div [ Html.Attributes.style easingStyle ]
            [ h3 [] [ text name ]
            , Svg.svg [ Svg.Attributes.width "960", Svg.Attributes.height "200" ]
                [ Svg.g []
                    (List.map (viewPoint 2 "#ccc" "white") easedPoints)
                , Svg.g []
                    (List.map (viewPoint 5 "blue" "white") points)
                ]
            ]


viewPoint : Int -> String -> String -> ( Float, Float ) -> Html msg
viewPoint radius fill stroke ( x, y ) =
    Svg.circle
        [ Svg.Attributes.cx (toString x)
        , Svg.Attributes.cy (toString y)
        , Svg.Attributes.r (toString radius)
        , Svg.Attributes.stroke stroke
        , Svg.Attributes.fill fill
        , Svg.Attributes.fillOpacity "1"
        ]
        []


viewCurve : Curve -> Html msg
viewCurve curve =
    let
        controls =
            Curve.controlPoints curve

        points =
            Curve.points 20 curve

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
