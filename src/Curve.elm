module Curve exposing (Curve, Point, Path, line, bezier, cubic, pointAt, asPath, readPath)

{-|
@docs Curve, Point, Path, line, bezier, cubic, pointAt, asPath, readPath


-}


{-| A Path is a list of curves, much as it's defined in SVG.  In fact, this is generally only used for SVG!
-}
type alias Path =
    List Curve


{-| Represented as (x,y).  This seems natural compared to `Point x y`
-}
type alias Point =
    ( Float, Float )


{-|
-}
type Curve
    = Bezier (List Point)
    | Cubic (List Point)
    | Line (List Point)


{-| -}
line : Point -> Point -> Curve
line =
    Debug.crash


{-| -}
bezier : Point -> List Point -> Point -> Curve
bezier =
    Debug.crash


{-| -}
cubic : Point -> List Point -> Point -> Curve
cubic =
    Debug.crash


{-| Get the point at a certain percentage along the curve.  Percentage is represented as a value from 0 to 1.

The percentage will wrap around to the beginning if it exceeds 1.0.  Same with values below 0.
-}
pointAt : Curve -> Float -> Point
pointAt curve x =
    Debug.crash


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
