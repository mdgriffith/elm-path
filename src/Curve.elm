module Curve exposing (Curve, Point, line, lines, arc, fromEasing, bezier, catmullRom, loose, tight, pointAt, points, length, controlPoints)

{-|
@docs Curve, Point, line, lines, tight, loose, arc, fromEasing, bezier, catmullRom, pointAt, points, length, controlPoints

-}


{-|
-}
type alias Point =
    ( Float, Float )


{-|
-}
type Curve
    = Bezier (List Point)
    | CatmullRom Point Point (List Point)
    | Line Point Point
    | ManyLines (List Point)
    | Arc
        { clockwise : Bool
        , origin : Point
        , startAngle : Angle
        , endAngle : Angle
        }


type alias Angle =
    Float


{-| -}
line : Point -> Point -> Curve
line =
    Line


{-| -}
lines : List Point -> Curve
lines =
    ManyLines


{-| -}
bezier : List Point -> Curve
bezier =
    Bezier


{-| An alias for a bezier curve.
-}
loose : List Point -> Curve
loose =
    bezier


{-| -}
catmullRom : Point -> Point -> List Point -> Curve
catmullRom =
    CatmullRom


{-| An alias for a catmullRom curve.
-}
tight : List Point -> Curve
tight =
    catmullRom defaultPoint defaultPoint


{-| -}
arc :
    { clockwise : Bool
    , origin : Point
    , startAngle : Angle
    , endAngle : Angle
    }
    -> Curve
arc =
    Arc


{-|
-}
fromEasing : (Float -> Float) -> Curve
fromEasing ease =
    fromFunction ease 10 0 1


{-|
-}
fromFunction : (Float -> Float) -> Int -> Float -> Float -> Curve
fromFunction fn numPoints start end =
    line ( 0, 0 ) ( 1, 1 )


{-| -}
defaultPoint : Point
defaultPoint =
    ( 0, 0 )


{-| -}
length : Curve -> Float
length curve =
    let
        lineSegmentLength ( x1, y1 ) ( x2, y2 ) =
            sqrt <| (x2 - x1) ^ 2 + (y2 - y1) ^ 2
    in
        case curve of
            Line p1 p2 ->
                lineSegmentLength p1 p2

            ManyLines pnts ->
                List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts)

            otherwise ->
                points curve 20
                    |> (\pnts -> List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts))


{-| -}
points : Curve -> Int -> List Point
points curve numPoints =
    let
        absNumPoints =
            abs numPoints
    in
        List.range 0 absNumPoints
            |> List.map ((pointAt curve) << (\x -> toFloat x / toFloat absNumPoints))


{-| Get the point at a certain percentage along the curve.  Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

-}
pointAt : Curve -> Float -> Point
pointAt curve x =
    let
        t =
            if x > 1.0 then
                x - toFloat (round x)
            else if x < 0 then
                1.0 - toFloat (floor x)
            else
                x
    in
        case curve of
            Line ( s1, s2 ) ( e1, e2 ) ->
                ( s1 + (t * (e1 - s1))
                , s2 + (t * (e2 - s2))
                )

            ManyLines points ->
                case points of
                    [] ->
                        defaultPoint

                    nonEmpty ->
                        let
                            totalLength =
                                length curve
                        in
                            defaultPoint

            Arc _ ->
                defaultPoint

            CatmullRom ctrl1 ctrl2 points ->
                case points of
                    [] ->
                        defaultPoint

                    start :: [] ->
                        start

                    start :: second :: _ ->
                        -- Can do real catmullRom
                        catmullRomPointOnSegment ctrl1 start second ctrl2 t

            Bezier points ->
                case points of
                    [] ->
                        defaultPoint

                    head :: remaining ->
                        if t == 0 then
                            head
                        else
                            List.map2 (interpolatePoint t) points remaining
                                |> Bezier
                                |> (\curve -> pointAt curve t)


catmullRomPointOnSegment : Point -> Point -> Point -> Point -> Float -> Point
catmullRomPointOnSegment p0 p1 p2 p3 t =
    let
        t3 =
            t ^ 3

        t2 =
            t ^ 2

        f1 =
            -0.5 * t3 + t2 - 0.5 * t

        f2 =
            1.5 * t3 - 2.5 * t2 + 1.0

        f3 =
            -1.5 * t3 + 2.0 * t2 + 0.5 * t

        f4 =
            0.5 * t3 - 0.5 * t2

        x =
            (Tuple.first p0) * f1 + (Tuple.first p1) * f2 + (Tuple.first p2) * f3 + (Tuple.first p3) * f4

        y =
            (Tuple.second p0) * f1 + (Tuple.second p1) * f2 + (Tuple.second p2) * f3 + (Tuple.second p3) * f4
    in
        ( x, y )


{-| -}
controlPoints : Curve -> List Point
controlPoints curve =
    case curve of
        Line p1 p2 ->
            [ p1, p2 ]

        ManyLines points ->
            points

        Arc _ ->
            []

        CatmullRom ctrl1 ctrl2 remaining ->
            ctrl1 :: remaining ++ [ ctrl2 ]

        Bezier points ->
            points


{-| -}
interpolatePoint : Float -> Point -> Point -> Point
interpolatePoint t ( x1, y1 ) ( x2, y2 ) =
    ( interpolateLinearly ( x1, x2 ) ( 0, 1 ) t
    , interpolateLinearly ( y1, y2 ) ( 0, 1 ) t
    )


type alias Interval =
    ( Float, Float )


{-|
Map x from interval `i` to interval `j`

-}
interpolateLinearly : Interval -> Interval -> Float -> Float
interpolateLinearly ( istart, iend ) ( jstart, jend ) x =
    istart + (iend - istart) * (x - jstart) / (jend - jstart)
