module Curve exposing (Curve, Point, Path, line, arc, fromEasing, bezier, catmullRom, loose, tight, arc, pointAt)

{-|
@docs Curve, Point, line, tight, loose, arc, fromEasing, bezier, catmullRom, pointAt

-}


{-|
-}
type alias Point =
    ( Float, Float )


{-|
-}
type Curve
    = Bezier Point (List Point)
    | CatmullRom Point (List Point)
    | Line Point Point
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
bezier : Point -> List Point -> Curve
bezier =
    Bezier


{-| An alias for a bezier curve.
-}
loose : Point -> List Point -> Curve
loose =
    bezier


{-| -}
catmullRom : Point -> List Point -> Point -> Curve
catmullRom =
    CatmullRom


{-| An alias for a catmullRom curve.
-}
tight : Point -> List Point -> Curve
tight =
    catmullRom


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
    Debug.crash


{-| Get the point at a certain percentage along the curve.  Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

-}
pointAt : Float -> Curve -> Point
pointAt t curve =
    case curve of
        Line ( s1, s2 ) ( e1, e2 ) ->
            ( s1 + (t * (e1 - s1))
            , s2 + (t * (e2 - s2))
            )

        Arc _ ->
            Debug.crash

        CatmullRom start points ->
            case points of
                [] ->
                    start

                nonEmptyPoints ->
                    ( 0, 0 )

        Bezier start points ->
            case points of
                [] ->
                    start

                head :: remaining ->
                    if t == 0 then
                        start
                    else
                        let
                            asBezier newPoints =
                                case newPoints of
                                    [] ->
                                        -- This should never happen because
                                        -- we have a guarantee that this list is non-empty
                                        Bezier ( 0, 0 ) []

                                    newHead :: newRemaining ->
                                        Bezier newHead newRemaining
                        in
                            List.map2 (interpolatePoint t) (start :: head :: remaining) (head :: remaining)
                                |> asBezier
                                |> pointAt t


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
