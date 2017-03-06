module Path.Continue exposing (..)

{-| Draw from the end of the previous path.

In general it might also be useful to have functions that not only
implicitly start at the end of the path, but have a start tangent equal to the
end tangent of the path - for example, you could have a Catmull-Rom spline that
used the current end derivative as its clamped starting condition, or have an
arc construction variant where you'd only need to supply a radius and swept
angle. -Ian
-}


{-| Add line from endpoint of path to an absolute horizontal value.
-}
line : Point -> Path -> Path
line point path =
    -- Add line from endpoint of path to given point
    Debug.crash "TODO"


{-| Add horizontal line from endpoint of a path to an absolute horizontal value.

I'm a bit worried this could be confusing, as it's not clear whether the value
is absolute or relative - I rather like separate `horizontalTo` and
`horizontalBy` functions. -Ian
-}
horizontal : Float -> Path -> Path
horizontal x path =
    Debug.crash "TODO"


{-| Add vertical line from the endpoint of a path to an absolute vertical value.

Same concern as for `horizontal`... -Ian
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
