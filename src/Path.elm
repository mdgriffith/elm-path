module Path exposing (..)

{-| 
Just a sketch at the moment

-}

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



--------------------
-- Building Curves
--------------------


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


arc : { center : Point, start : Point, sweptAngle : Angle } -> Path
arc =
    Arc >> segment


hermite : List ( Point, Vector ) -> Path
hermite =
    Debug.crash "TODO"


curve : List Point -> Path
curve =
    curveWith { start = Free, end = Free }


curveWith : { start : BoundaryCondition, end : BoundaryCondition } -> List Point -> Path
curveWith =
    Debug.crash "TODO"


{-| I think it should be possible to add this - a Catmull-Rom interpolating
spline that passes through all points and loops around on itself. -Ian
-}
loop : List Point -> Path
loop =
    Debug.crash "TODO"


{-| -}
close : Path -> Path
close (Path segments) =
    Path (segments ++ [ Close ])



--------------------
-- Combining Paths
--------------------


{-| Combine paths without modification.

-}
group : List Path -> Path
group =
    Debug.crash "TODO"


{-| Connect paths via lines.

-}
connect : List Path -> Path
connect =
    Debug.crash "TODO"


{-| Adjust each path so that it starts where the previous path finishes

-}
attach : List Path -> Path
attach =
    Debug.crash "TODO"


{-| Each curve starts at the end of each previous curve.

Curves are rotated so that their tangents are always smooth.

-}
attachSmoothly : List Path -> Path
attachSmoothly =
    Debug.crash



--------------------
-- Parsing/Encoding
--------------------


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



--------------------
-- Reading out data
--------------------


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


{-| Get the start point of a path
-}
startPoint : Path -> Point
startPoint =
    Debug.crash "TODO"


{-| Get the end point of a path
-}
endPoint : Path -> Point
endPoint =
    Debug.crash "TODO"


{-| Gives best estimate of the length of the path.

For reference: https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/pathLength

-}
length : Path -> Float
length =
    Debug.crash "TODO"
