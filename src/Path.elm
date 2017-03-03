module Path
    exposing
        ( Path
        , Point
        , BoundaryCondition(..)
        , Angle
        , line
        , horizontal
        , vertical
        , polyline
        , hermite
        , arc
        , quadratic
        , cubic
        , curve
        , curveWith
        , close
        , startAt
        , lineTo
        , horizontalTo
        , verticalTo
        , polylineTo
        , arcAround
        , quadraticTo
        , cubicTo
        , curveTo
        , join
        , concat
        , composite
        , toString
        , fromString
        , tangent
        , derivative
        , point
        , startPoint
        , endPoint
        )


type Path
    = Path (List Segment)


type Segment
    = Segment Curve
    | MoveTo Point
    | Close


type Curve
    = Polyline (List Point)
    | Quadratic Point Point Point
    | Cubic Point Point Point Point
    | Arc { center : Point, start : Point, sweptAngle : Angle }


type alias Point =
    ( Float, Float )


type BoundaryCondition
    = Clamped Vector
    | Free


type alias Angle =
    Float


segment : Curve -> Path
segment curve =
    Path [ Segment curve ]


line : Point -> Point -> Path
line start end =
    segment (Polyline [ start, end ])


horizontal : Int -> Path
horizontal x =
    line ( 0, 0 ) ( x, 0 )


vertical : Int -> Path
vertical y =
    line ( 0, 0 ) ( 0, y )


polyline : List Point -> Path
polyline =
    Polyline >> segment


hermite : List ( Point, Vector ) -> Path
hermite =
    Debug.crash "TODO"


arc : { center : Point, start : Point, sweptAngle : Angle } -> Path
arc =
    Arc >> segment


quadratic : Point -> Point -> Point -> Path
quadratic p1 p2 p3 =
    segment (Quadratic p1 p2 p3)


cubic : Point -> Point -> Point -> Point -> Path
cubic p1 p2 p3 p4 =
    segment (Cubic p1 p2 p3 p4)


curve : List Point -> Path
curve =
    curveWith { start = Free, end = Free }


curveWith : { start : BoundaryCondition, end : BoundaryCondition } -> List Point -> Path
curveWith =
    Debug.crash "TODO"


close : Path -> Path
close (Path segments) =
    Path (segments ++ [ Close ])


startAt : Point -> Path
startAt point =
    Path [ MoveTo point ]


lineTo : Point -> Path -> Path
lineTo point path =
    -- Add line from endpoint of path to given point
    Debug.crash "TODO"


horizontalTo : Float -> Path -> Path
horizontalTo x path =
    -- Add horizontal line from endpoint of path to given X value
    Debug.crash "TODO"


verticalTo : Float -> Path -> Path
verticalTo y path =
    -- Add vertical line from endpoint of path to given Y value
    Debug.crash "TODO"


polylineTo : List Point -> Path -> Path
polylineTo points path =
    -- Add polyline starting at endpoint of path, going to each of the given points
    Debug.crash "TODO"


arcAround : Point -> Float -> Path -> Path
arcAround centerPoint sweptAngle path =
    -- Add arc from endpoint of path, swept around given center by given angle
    Debug.crash "TODO"


quadraticTo : Point -> Point -> Path -> Path
quadraticTo p2 p3 path =
    -- Add quadratic spline using endpoint of path as first control point
    Debug.crash "TODO"


cubicTo : Point -> Point -> Point -> Path -> Path
cubicTo p2 p3 p4 path =
    -- Add cubic spline using endpoint of path as first control point
    Debug.crash "TODO"


curveTo : List Point -> Path -> Path
curveTo points path =
    -- Add Catmull-Rom interpolated curve (with free end condition), using endpoint of path as first point
    Debug.crash "TODO"


join : List Path -> Path
join =
    -- add line if necessary between each pair of paths
    Debug.crash "TODO"


concat : List Path -> Path
concat =
    -- adjust position of each path to start at the endpoint of the previous path
    Debug.crash "TODO"


composite : List Path -> Path
composite =
    -- add a 'MoveTo' if necessary between each pair of paths
    Debug.crash "TODO"


{-| Render a `Path` as [an svg path](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
-}
toString : Path -> String
toString path =
    Debug.crash "TODO"


{-| Parse an SVG path string as a `Path`.
-}
fromString : String -> Maybe Path
fromString path =
    Debug.crash "TODO"


{-| Get the tangent at a certain percentage along the path.

Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

Angle returned is in the standard Elm rotational units (radians).
-}
tangent : Path -> Float -> Angle
tangent path x =
    Debug.crash "TODO"


{-|
-}
derivative : Path -> Float -> Vector
derivative path x =
    Debug.crash "TODO"


{-| Get the point at a certain percentage along the path.  Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.

-}
point : Path -> Float -> Point
point =
    Debug.crash "TODO"


startPoint : Path -> Point
startPoint =
    Debug.crash "TODO"


endPoint : Path -> Point
endPoint =
    Debug.crash "TODO"
