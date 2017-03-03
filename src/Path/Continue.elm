module Path.Continue exposing (..)

{-| Draw from the end of the previous path.

-}


{-| Add line from endpoint of path to an absolute horizontal value.
-}
line : Point -> Path -> Path
line point path =
    -- Add line from endpoint of path to given point
    Debug.crash "TODO"


{-| Add horizontal line from endpoint of a path to an absolute horizontal value.
-}
horizontal : Float -> Path -> Path
horizontal x path =
    Debug.crash "TODO"


{-| Add vertical line from the endpoint of a path to an absolute vertical value.
-}
vertical : Float -> Path -> Path
vertical y path =
    Debug.crash "TODO"


{-|
-}
polyline : List Point -> Path -> Path
polyline points path =
    -- Add polyline starting at endpoint of path, going to each of the given points
    Debug.crash "TODO"


{-|
-}
arcAround : Point -> Float -> Path -> Path
arcAround centerPoint sweptAngle path =
    -- Add arc from endpoint of path, swept around given center by given angle
    Debug.crash "TODO"


{-|
-}
quadratic : Point -> Point -> Path -> Path
quadratic p2 p3 path =
    -- Add quadratic spline using endpoint of path as first control point
    Debug.crash "TODO"


{-|
-}
cubic : Point -> Point -> Point -> Path -> Path
cubic p2 p3 p4 path =
    -- Add cubic spline using endpoint of path as first control point
    Debug.crash "TODO"


{-|
-}
curve : List Point -> Path -> Path
curve points path =
    -- Add Catmull-Rom interpolated curve (with free end condition), using endpoint of path as first point
    Debug.crash "TODO"
