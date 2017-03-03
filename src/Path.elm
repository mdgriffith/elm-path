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
        , join
        , concat
        , composite
        , toString
        , fromString
        , tangent
        , derivative
        , point
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
