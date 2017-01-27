module Curve exposing (Curve, Point, line, manyLines, arc, fromEasing, bezier, catmullRom, loose, tight, pointAt, points, length, controlPoints)

{-|
@docs Curve, Point, line, manyLines, tight, loose, arc, fromEasing, bezier, catmullRom, pointAt, points, length, controlPoints

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
manyLines : List Point -> Curve
manyLines =
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
catmullRom : Point -> List Point -> Point -> Curve
catmullRom ctrl1 points ctrl2 =
    CatmullRom ctrl1 ctrl2 points


{-| An alias for a catmullRom curve.
-}
tight : List Point -> Curve
tight points =
    let
        ( ctrl1, ctrl2 ) =
            extrapolateControlPoints points
    in
        catmullRom ctrl1 points ctrl2


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
    fromFunction ease 100 0 1


{-| From p1 to p2, extrapolate point
-}
extrapolatePoint : Point -> Point -> Point
extrapolatePoint ( x1, y1 ) ( x2, y2 ) =
    let
        dx =
            x1 - x2

        dy =
            y1 - y2
    in
        ( x2 + dx
        , y2 + dy
        )


extrapolateControlPoints : List Point -> ( Point, Point )
extrapolateControlPoints points =
    let
        horizontal ( x, y ) dx =
            ( x + dx, y )

        extrapolateEndPoints s1 s2 remaining =
            case remaining of
                [] ->
                    extrapolatePoint s1 s2

                head :: [] ->
                    extrapolatePoint s2 head

                all ->
                    all
                        |> List.drop (List.length all - 2)
                        |> toSegments
                        |> List.head
                        |> Maybe.withDefault ( s1, s2 )
                        |> uncurry extrapolatePoint
    in
        case points of
            [] ->
                ( defaultPoint, defaultPoint )

            start :: [] ->
                ( horizontal start 5
                , horizontal start -5
                )

            s1 :: s2 :: remaining ->
                ( extrapolatePoint s2 s1
                , extrapolateEndPoints s1 s2 remaining
                )


{-|
-}
fromFunction : (Float -> Float) -> Int -> Float -> Float -> Curve
fromFunction fn numPoints start end =
    let
        pointsOnFn =
            abs numPoints
                |> List.range 0
                |> List.map ((\x -> ( x, fn x )) << (\x -> start + ((x / (toFloat <| abs numPoints)) * (end - start))) << toFloat)

        ( ctrl1, ctrl2 ) =
            extrapolateControlPoints pointsOnFn
    in
        catmullRom ctrl1 pointsOnFn ctrl2


{-| -}
defaultPoint : Point
defaultPoint =
    ( 0, 0 )


{-| -}
length : Curve -> Float
length curve =
    case curve of
        Line p1 p2 ->
            lineSegmentLength p1 p2

        ManyLines pnts ->
            List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts)

        otherwise ->
            points 20 curve
                |> (\pnts -> List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts))


lineSegmentLength : Point -> Point -> Float
lineSegmentLength ( x1, y1 ) ( x2, y2 ) =
    sqrt <| (x2 - x1) ^ 2 + (y2 - y1) ^ 2


{-| -}
points : Int -> Curve -> List Point
points numPoints curve =
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

            CatmullRom ctrl1 ctrl2 pnts ->
                case pnts of
                    [] ->
                        defaultPoint

                    start :: [] ->
                        start

                    start :: second :: remaining ->
                        let
                            controls =
                                controlPoints curve

                            segmentLengths =
                                List.map4
                                    (\a b c d ->
                                        ( catmullRomSegmentLength 10 a b c d, a, b, c, d )
                                    )
                                    controls
                                    (List.drop 1 controls)
                                    (List.drop 2 controls)
                                    (List.drop 3 controls)

                            totalLength =
                                List.map (\( segLen, _, _, _, _ ) -> segLen) segmentLengths
                                    |> List.sum

                            ( maybePoint, _ ) =
                                List.foldl
                                    (\( segLen, a, b, c, d ) ( found, runningTotal ) ->
                                        case found of
                                            Just _ ->
                                                ( found, runningTotal )

                                            Nothing ->
                                                if (runningTotal + segLen) / totalLength > t then
                                                    let
                                                        localT =
                                                            ((t * totalLength) - runningTotal) / segLen

                                                        _ =
                                                            Debug.log "local-t, t" ( localT, t )
                                                    in
                                                        ( Just (catmullRomPointOnSegment a b c d localT)
                                                        , runningTotal
                                                        )
                                                else
                                                    ( Nothing, runningTotal + segLen )
                                    )
                                    ( Nothing, 0 )
                                    segmentLengths
                        in
                            case maybePoint of
                                Just x ->
                                    x

                                _ ->
                                    defaultPoint

            Bezier points ->
                case points of
                    [] ->
                        defaultPoint

                    head :: [] ->
                        head

                    head :: remaining ->
                        if t == 0 then
                            head
                        else
                            List.map2 (interpolatePoint t) points remaining
                                |> Bezier
                                |> (\curve -> pointAt curve t)


toSegments : List Point -> List ( Point, Point )
toSegments points =
    List.map2 (,) points (List.drop 1 points)


catmullRomSegmentLength : Int -> Point -> Point -> Point -> Point -> Float
catmullRomSegmentLength resolution p0 p1 p2 p3 =
    let
        res =
            abs resolution

        pollPoints =
            List.range 0 res
                |> List.map (\x -> toFloat x / toFloat res)
    in
        pollPoints
            |> List.map (catmullRomPointOnSegment p0 p1 p2 p3)
            |> toSegments
            |> List.map (uncurry lineSegmentLength)
            |> List.sum


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
