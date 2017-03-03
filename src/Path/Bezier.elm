module Path.Bezier exposing (..)

{-|
-}


{-|
-}
quadratic : Point -> Point -> Point -> Path
quadratic =
    Debug.crash


{-| Continues a quadratic bezier curve from where the previous one ended, and calculates a control point by mirroring.
-}
extendedQuadratic : Point -> Point -> Point -> List Point -> Curve
extendedQuadratic =
    Debug.crash


{-|
-}
cubic : Point -> Point -> Point -> Point -> Path
cubic =
    Debug.crash


{-| Continues a cubic bezier curve from where the previous one ended, and calculates a control point by mirroring.
-}
extendedCubic : Point -> Point -> Point -> Point -> List ( Point, Point ) -> Curve
extendedCubic =
    Debug.crash
