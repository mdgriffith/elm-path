module Curve.Path exposing (Path)

{-|
@docs Path, read,

-}


{-| A Path is a list of curves, much as it's defined in SVG.  In fact, this is generally only used for SVG!
-}
type Path
    = Path (List Curve.Model.Curve)
    | Closed (List Curve.Model.Curve)


{-| Render a `Curve.Path` as [an svg path](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d).
-}
toString : Path -> String
toString path =
    Debug.crash


{-| Parse an SVG path string as a Curve.Path
-}
fromString : String -> Maybe Path
fromString path =
    Debug.crash


{-| Each curve starts at the end of each previous curve.
-}
continuous : List Curve -> Path
continuous =
    Path


{-| Append path1 to path2
-}
append : Path -> Path -> Path
append path1 path2 =
    path2


{-| Append path1 to path2,
but path2's coordinates are relative to the last point given in path1
-}
continue : Path -> Path -> Path
continue path1 path2 =
    path1


{-|
-}
open : List Curve -> Path
open =
    Path


{-|
-}
closed : List Curve -> Path
closed =
    Closed
