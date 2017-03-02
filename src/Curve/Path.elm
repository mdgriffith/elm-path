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


open : List Curve -> Path
open =
    Debug.crash


closed : List Curve -> Path
closed =
    Debug.crash


{-| Append path1 to path2.

-}
append : Path -> Path -> Path
append path1 path2 =
    path2


{-| Each curve starts at the end of each previous curve.
Point-wise continuous.  Can have hard angles.
-}
connect : List Curve -> Path
connect =
    Debug.crash


connectPaths : List Path -> Path
connectPaths =
    Debug.crash


{-| Each curve starts at the end of each previous curve and tangents are matched so it is always smooth.
-}
continue : List Curve -> Path
continue =
    Debug.crash


continuePaths : List Path -> Path
continuePaths =
    Debug.crash
