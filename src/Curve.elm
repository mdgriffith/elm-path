module Curve exposing (Curve, Point, Path, line, bezier, spline, pointAt, asPath, readPath)

{-|
@docs Curve, Point, Path, line, bezier, cubic, pointAt, asPath, readPath

-}


{-| A Path is a list of curves, much as it's defined in SVG.  In fact, this is generally only used for SVG!
-}
type alias Path =
    List Curve


{-|
-}
type alias Point =
    ( Float, Float )


{-|
-}
type Curve
    = Bezier Point (List Point)
    | Spline Point (List Point)
    | Line Point Point


{-| -}
line : Point -> Point -> Curve
line =
    Line


{-| -}
bezier : Point -> List Point -> Curve
bezier =
    Bezier


{-| -}
spline : Point -> List Point -> Point -> Curve
spline =
    Spline


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

        Spline start points ->
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


{-| Render a `Curve.Path` as [an svg path](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
-}
asPath : Path -> String
asPath path =
    Debug.crash


{-| Parse an SVG path string as a Curve.Path
-}
readPath : String -> Maybe Path
readPath path =
    Debug.crash
