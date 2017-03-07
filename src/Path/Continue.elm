module Path.Continue exposing (..)

{-| Draw from the end of the previous path.

In general it might also be useful to have functions that not only
implicitly start at the end of the path, but have a start tangent equal to the
end tangent of the path - for example, you could have a Catmull-Rom spline that
used the current end derivative as its clamped starting condition, or have an
arc construction variant where you'd only need to supply a radius and swept
angle. -Ian
-}


{-| Add line from endpoint of path to an absolute point.
-}
line : Point -> Path -> Path
line point path =
    Debug.crash "TODO"


{-| Add horizontal line from endpoint of a path to an absolute horizontal value.

-}
horizontalTo : Float -> Path -> Path
horizontalTo x path =
    Debug.crash "TODO"


{-| Add horizontal line from endpoint of a path _by_ an absolute horizontal value.

-}
horizontalBy : Float -> Path -> Path
horizontalBy x path =
    Debug.crash "TODO"


{-| Add vertical line from the endpoint of a path to an absolute vertical value.

Same concern as for `horizontal`... -Ian
-}
verticalTo : Float -> Path -> Path
verticalTo y path =
    Debug.crash "TODO"


{-| Add vertical line from the endpoint of a path to an absolute vertical value.

Same concern as for `horizontal`... -Ian
-}
verticalBy : Float -> Path -> Path
verticalBy y path =
    Debug.crash "TODO"


{-|
-}
polyline : List Point -> Path -> Path
polyline points path =
    Debug.crash "TODO"


{-|
-}
arcAround : Point -> Float -> Path -> Path
arcAround centerPoint sweptAngle path =
    -- Add arc from endpoint of path, swept around given center by given angle
    Debug.crash "TODO"


{-|
-}
arc : { radius : Float, sweptAngle : Float } -> Path -> Path
arc radius sweptAngle path =
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


{-| Catmull-Rom interpolated curve (with free end condition), using endpoint of path as first point
-}
curve : List Point -> Path -> Path
curve points path =
    -- Add
    Debug.crash "TODO"


{-| Catmull-Rom interpolated Curve that starts on the endpoint of the path, and is tangent continuous with the previous path.
-}
smooth : List Point -> Path -> Path
smooth points path =
    Debug.crash "TODO"
