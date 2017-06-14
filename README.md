# Elm Path

## Use-Cases!

This library was made to fulfill with the following in mind:

  * Provide a nice interface for drawing/composing curves/paths in raw code
  * Convert to and from svg paths
  * __(elm-style-animation)__ - Be able to animate something along a curve.  This involves being able to readout points along a curve.
  * __(elm-style-animation)__ - Be able to convert an easing function into a curve so that any animation can be %100 serialized into JSON
  * Catmull rom curves are _really_ valuable to animation because you can just specify the checkpoints you want the curve to go through and it will smoothely interpolate between them.  They also convert to bezier curves so can have complete compatibility with svg.
  



## Reference Documentation

[B-Splines](https://en.wikipedia.org/wiki/B-spline)

[Bezier Curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

[Irwin-Hall splines](https://en.wikipedia.org/wiki/Spline_(mathematics)) Or cubic splines in general

[Cubic Spline Interpolation](https://en.wikipedia.org/wiki/Spline_interpolation#Algorithm_to_find_the_interpolating_cubic_spline) - Though this library wants generallized n-splines instead of just cubic.


[Centripetal Catmull Rom Spline](https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline)

[Hermite Splines](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Interpolating a data set)



[Explanation of Catmull Rom Spline](http://www.dxstudio.com/guide_content.aspx?id=70a2b2cf-193e-4019-859c-28210b1da81f)

[d3 example](https://bl.ocks.org/mbostock/1705868)

[Stroke Dash Interpolation](https://bl.ocks.org/mbostock/5649592)

[Circle Wave](https://bl.ocks.org/mbostock/2d466ec3417722e3568cd83fc35338e3)

