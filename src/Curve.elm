module Curve exposing (Curve, Point, line, polyline, arc, fromEasing, bezier, catmullRom, loose, tight, tangentAt, pointAt, vectorAt, points, length)

{-|
@docs Curve, Point, line, polyline, tight, loose, arc, fromEasing, bezier, catmullRom,  pointAt, points, tangentAt, vectorAt,  length

-}


{-|
-}
type alias Point =
    ( Float, Float )


type BoundaryCondition
    = Clamped Vector
    | Free


type alias Angle =
    Float


line : Point -> Point -> Curve
line =
    Line


polyline : List Point -> Curve
polyline =
    Polyline


type Segment
    = Cubic Point Point Point
    | Quadratic Point Point Point


bezier : Point -> List Segment -> Curve
bezier =
    Bezier


cubic : Point -> Point -> Segment
cubic =
    Debug.crash


quadratic : Point -> Point -> Point -> Segment
quadratic =
    Debug.crash


hermite : List ( Point, Vector ) -> Curve
hermite =
    Debug.crash


arc :
    { origin : Point
    , startAngle : Angle
    , endAngle : Angle
    , radius : Float
    }
    -> Curve
arc =
    Arc


{-| Catmull-Rom interpolation.

I kinda just want to call this "curve".

-}
curve : List Point -> Curve
curve =
    curveWith { start = Free, end = Free }


curveWith : { start : BoundaryCondition, end : BoundaryCondition } -> List Point -> Curve
curveWith =
    Debug.crash


{-|
-}
fromEasing : (Float -> Float) -> Curve
fromEasing ease =
    fromFunction (\x -> ( x, ease x )) 100 0 1


{-|
-}
fromFunction : (Float -> Point) -> Int -> Float -> Float -> Curve
fromFunction fn numPoints start end =
    Debug.crash


{-| -}
length : Curve -> Float
length curve =
    case curve of
        Line p1 p2 ->
            lineSegmentLength p1 p2

        Polyline pnts ->
            List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts)

        otherwise ->
            points 20 curve
                |> (\pnts -> List.sum <| List.map2 lineSegmentLength pnts (List.drop 1 pnts))


lineSegmentLength : Point -> Point -> Float
lineSegmentLength ( x1, y1 ) ( x2, y2 ) =
    sqrt <| (x2 - x1) ^ 2 + (y2 - y1) ^ 2


{-|
-}
samplePoints : Int -> Curve -> List Point
samplePoints numPoints curve =
    let
        absNumPoints =
            abs numPoints
    in
        List.range 0 absNumPoints
            |> List.map ((pointOn curve) << (\x -> toFloat x / toFloat absNumPoints))


{-| Get the tangent at a certain percentage along the curve.

Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

Angle returned is in the standard Elm rotational units (radians).
-}
tangent : Curve -> Float -> Angle
tangent curve x =
    pi


{-|
-}
derivative : Curve -> Float -> Vector
derivative curve x =
    ( defaultPoint, pi )


{-| Get the point at a certain percentage along the curve.  Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

-}
point : Curve -> Float -> Point
point =
    Debug.crash
