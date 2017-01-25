module Curve.Path exposing (Path)

{-|
@docs Path, read,

-}


{-| A Path is a list of curves, much as it's defined in SVG.  In fact, this is generally only used for SVG!
-}
type Path
    = Path (List Curve)
    | Closed (List Curve)


{-| Render a `Curve.Path` as [an svg path](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
-}
pathString : Path -> String
pathString path =
    Debug.crash


{-| Parse an SVG path string as a Curve.Path
-}
readPath : String -> Maybe Path
readPath path =
    Debug.crash


{-|
-}
path : List Curve -> Path
path =
    Path


closedPath : List Curve -> Path
closedPath =
    Closed
