module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Ease exposing (Easing)
import Curve


easings : List ( Easing, String )
easings =
    [ ( Ease.inSine, "inSine" )
      --, ( Ease.outSine, "outSine" )
      --, ( Ease.inOutSine, "inOutSine" )
      --, ( Ease.inQuad, "inQuad" )
      --, ( Ease.outQuad, "outQuad" )
      --, ( Ease.inOutQuad, "inOutQuad" )
      --, ( Ease.inCubic, "inCubic" )
      --, ( Ease.outCubic, "outCubic" )
      --, ( Ease.inOutCubic, "inOutCubic" )
      --, ( Ease.inQuart, "inQuart" )
      --, ( Ease.outQuart, "outQuart" )
      --, ( Ease.inOutQuart, "inOutQuart" )
      --, ( Ease.inQuint, "inQuint" )
      --, ( Ease.outQuint, "outQuint" )
      --, ( Ease.inOutQuint, "inOutQuint" )
      --, ( Ease.inExpo, "inExpo" )
      --, ( Ease.outExpo, "outExpo" )
      --, ( Ease.inOutExpo, "inOutExpo" )
      --, ( Ease.inCirc, "inCirc" )
      --, ( Ease.outCirc, "outCirc" )
      --, ( Ease.inOutCirc, "inOutCirc" )
      --, ( Ease.inBack, "inBack" )
      --, ( Ease.outBack, "outBack" )
      --, ( Ease.inOutBack, "inOutBack" )
      --, ( Ease.inElastic, "inElastic" )
      --, ( Ease.outElastic, "outElastic" )
      --, ( Ease.inOutElastic, "inOutElastic" )
      --, ( Ease.inBounce, "inBounce" )
      --, ( Ease.outBounce, "outBounce" )
      --, ( Ease.inOutBounce, "inOutBounce" )
    ]


all : Test
all =
    describe "Sample Test Suite"
        [ describe "Unit test examples"
            [ test "Addition" <|
                \() ->
                    Expect.equal (3 + 7) 10
            , test "String.left" <|
                \() ->
                    Expect.equal "a" (String.left 1 "abcdefg")
            , test "This test should fail - you should remove it" <|
                \() ->
                    Expect.fail "Failed as expected!"
            ]
        , describe "Fuzz test examples, using randomly generated input"
            [ fuzz (list int) "Lists always have positive length" <|
                \aList ->
                    List.length aList |> Expect.atLeast 0
            , fuzz (list int) "Sorting a list does not change its length" <|
                \aList ->
                    List.sort aList |> List.length |> Expect.equal (List.length aList)
            , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
                \i ->
                    List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
            , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
                \s1 s2 ->
                    s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
            ]
        , describe "Easing Fns == Easing Functions converted to a curve "
            (List.map testEasingCurveEquality easings)
        ]


testEasingCurveEquality : ( Easing, String ) -> Test
testEasingCurveEquality ( easeFn, name ) =
    let
        curve =
            Curve.fromEasing easeFn

        samples =
            List.range 0 1000
                |> (List.map (\x -> toFloat x / 1000))

        equalPoints x =
            test ("point " ++ toString x) <|
                \() ->
                    let
                        delta =
                            abs <|
                                (Tuple.second <| Curve.pointAt curve x)
                                    - (easeFn x)
                    in
                        Expect.atMost 0.001 delta
    in
        describe (name ++ " curve conversion test")
            (List.map equalPoints samples)
