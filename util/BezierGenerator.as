import flash.geom.Point;

class util.BezierGenerator {
	public var maxIterations:Number;
	public var tolerance:Number;
	
	private var bezier, data, params, length;
    private var startTangent, endTangent, splitPoint;

    function BezierGenerator(option) {
        option = option || {};
        maxIterations = option.maxIterations || 3,
        tolerance = option.tolerance || 1;
    }

    public function fromPoints(points, start, end) {
        setup(points, start, end);
        var result = _fromPoints();
        free();
        return result;
    }

    private function setup(points, start, end) {
        bezier = [];
        data = points;
        params = [];
        length = data.length;
        startTangent = start || $P(0, 0);
        endTangent = end || $P(0, 0);
        splitPoint = 0;
    }

    private function free() {
        bezier = data = params = startTangent = endTangent = null;
    }

    private function _fromPoints() {
		if(length < 2) return;
        if(length == 2) return fromTwoPoints();
        return generateBezier();
    }

    private function fromTwoPoints() {
        bezier[0] = data[0];
        bezier[3] = data[1];
        var distance = ptDistance(bezier[0], bezier[3]) / 3;
        bezier[1] = ptIsZero(startTangent)
            ? ptOperate(bezier[0], bezier[3], function(a, b) { return (a * 2 + b) / 3 })
            : ptOperate(bezier[0], startTangent, function(a, b) { return a + b * distance });
        bezier[2] = ptIsZero(endTangent)
            ? ptOperate(bezier[3], bezier[0], function(a, b) { return (a * 2 + b) / 3 })
            : ptOperate(bezier[3], endTangent, function(a, b) { return a + b * distance });
        return bezier;
    }

    private function generateBezier() {
        setParamsByLength();
        setAssumptBezier();
        var error = maxError();

        if(Math.abs(error) <= 1) return bezier;

        if(error >= 0 && error <= 3) {
            for(var i = 0; i < maxIterations; i++) {
                setAssumptBezier();
                error = maxError();
                if(Math.abs(error) <= 1) return bezier;
            }
        }

        if(error < 0) {
            if(splitPoint == 0 && !ptIsZero(startTangent))
                return fromPoints(data, $P(0, 0), endTangent);
            if(splitPoint == length - 1 && !ptIsZero(endTangent))
                return fromPoints(data, startTangent, $P(0, 0));
        }
    }

    private function setParamsByLength() {
        params = [0];
        for(var i = 1; i < length; i++)
            params[i] = params[i - 1] + ptDistance(data[i], data[i - 1]);
        var total = params[length - 1];
        for(i = 0; i < length; i++)
            params[i] /= total;
    }

    private function setAssumptBezier() {
        var start = ptIsZero(startTangent) ? estimateStartTangent() : startTangent;
        var end = ptIsZero(endTangent) ? estimateEndTangent() : endTangent;
        setAssumptBezierWithTangent(start, end);
        if(ptIsZero(startTangent)) {
            setControllPoint(1);
            if(!ptEqual(bezier[0], bezier[1]))
                start = ptUnit(ptMinus(bezier[1], bezier[0]));
            setAssumptBezierWithTangent(start, end);
        }
        reparameterize();
    }

    private function setAssumptBezierWithTangent(start, end) {
        var C = [[0, 0], [0, 0]];
        var X = [0, 0];

        bezier[0] = data[0];
        bezier[3] = data[length - 1];

        for(var i = 0; i < length; i++) {
            var b = B(params[i]);
            var a = [ptTime(start, b[1]), ptTime(end, b[2])];

            C[0][0] += ptDot(a[0], a[0]);
            C[0][1] += ptDot(a[0], a[1]);
            C[1][0] = C[0][1];
            C[1][1] += ptDot(a[1], a[1]);
            var offset = ptOperate(data[i], bezier[0], bezier[3], function(p, bezier0, bezier3) {
                return p - (b[0] + b[1]) * bezier0 - (b[2] + b[3]) * bezier3;
            });
            X[0] += ptDot(a[0], offset);
            X[1] += ptDot(a[1], offset);
        }

        var alphaL, alphaR;
        var detC = C[0][0] * C[1][1] - C[1][0] * C[0][1];
        if(detC) {
            var detC0X = C[0][0] * X[1] - C[0][1] * X[0];
            var detXC1 = X[0] * C[1][1] - X[1] * C[0][1];
            alphaL = detXC1 / detC;
            alphaR = detC0X / detC;
        } else {
            var c0 = C[0][0] + C[0][1];
            if(c0) {
                alphaL = X[0] / c0;
            } else {
                var c1 = C[1][0] + C[1][1];
                alphaL = c1 ? X[1] / c1 : 0;
            }
            alphaR = alphaL;
        }

        if(alphaL < 1e-6 || alphaR < 1e-6)
            alphaL = alphaR = ptDistance(data[0], data[length - 1]) / 3;

        bezier[1] = ptPlus(ptTime(start, alphaL), bezier[0]);
        bezier[2] = ptPlus(ptTime(end, alphaR), bezier[3]);
    }

    private function setControllPoint(ei) {
        var oi = 3 - ei;
        var result = $P(0, 0);
        var den = 0;
        for(var i = 0; i < length; i++) {
            var b = B(params[i]);
            result = ptOperate(result, bezier[0], bezier[3], bezier[oi], data[i], function(r, b0, b3, bo, p) {
                return r + b[ei] * (b[0] * b0 + b[3] * b3 + b[oi] * bo - p);
            });
            den -= b[ei] * b[ei];
        }
        if(den) {
            result = ptTime(result, 1 / den);
        } else {
            result = ptOperate(bezier[0], bezier[3], function(p0, p3) {
                return (oi * p0 + ei * p3) / 3;
            });
        }
        bezier[ei] = result;
    }

    private function estimateStartTangent() {
        var tangent;
        for(var i = 1; i < length; i++) {
            tangent = ptMinus(data[i], data[0]);
            if(ptSquare(tangent) > tolerance * tolerance)
                return ptUnit(tangent);
        }
        return ptIsZero(tangent) ? ptUnit(ptMinus(data[1], data[0])) : ptUnit(tangent);
    }

    private function estimateEndTangent() {
        var tangent;
        for(var i = length - 2; i >= 0; i--) {
            tangent = ptMinus(data[i], data[length - 1]);
            if(ptSquare(tangent) > tolerance * tolerance)
                return ptUnit(tangent);
        }
        return ptIsZero(tangent) ? ptUnit(ptMinus(data[length - 2], data[length - 1])) : ptUnit(tangent);
    }

    private function reparameterize() {
        for(var i = 0; i < length - 1; i++) {
            params[i] = newtonRaphsonRootFind(bezier, data[i], params[i]);
        }
    }

    private function newtonRaphsonRootFind(bezier, point, param) {
        var dbezier = pointDifference(bezier);
        var ddbezier = pointDifference(dbezier);

        var p = bezierPt(bezier, param);
        var dp = bezierPt(dbezier, param);
        var ddp = bezierPt(ddbezier, param);

        var diff = ptMinus(p, point);
        var numerator = ptDot(diff, dp);
        var denominator = ptSquare(dp) + ptDot(diff, ddp);

        var improvedParam;
        if(denominator > 0) {
            improvedParam = param - (numerator / denominator);
        } else {
            if(numerator > 0) {
                improvedParam = param * 0.98 - 0.01;
            } else if(numerator < 0) {
                improvedParam = param * 0.98 + 0.031;
            } else {
                improvedParam = param;
            }
        }
        if(improvedParam < 0) {
            improvedParam = 0;
        } else if(improvedParam > 1) {
            improvedParam = 1;
        }

        var diffSquare = ptSquare(diff);
        for(var proportion = 0.125;; proportion += 0.125) {
            if(ptSquare(ptMinus(bezierPt(bezier, improvedParam), point)) > diffSquare) {
                if(proportion > 1) {
                    improvedParam = param;
                    break;
                }
                improvedParam = (1 - proportion) * improvedParam + proportion * param;
            } else {
                break;
            }
        }

        return improvedParam;
    }

    private function maxError() {
        var toleranceMore = tolerance;
        var maxDistanceSquare = 0;
		var maxHook = 0;
        var snapEnd = 0;
        var prevPoint = bezier[0];
        for(var i = 1; i < length; i++) {
            var currentPoint = bezierPt(bezier, params[i]);
            var distanceSquare = ptSquare(ptMinus(currentPoint, data[i]));
            if(distanceSquare > maxDistanceSquare) {
                maxDistanceSquare = distanceSquare;
                splitPoint = i;
            }
            var hook = computeHook(prevPoint, currentPoint, (params[i] + params[i - 1]) / 2);
            if(hook > maxHook) {
                maxHook = hook;
                snapEnd = i;
            }
            prevPoint = currentPoint;
        }

        var maxDistanceRatio = Math.sqrt(maxDistanceSquare) / toleranceMore;

        if(maxHook <= maxDistanceRatio) {
            return maxDistanceRatio;
        } else {
            splitPoint = snapEnd - 1;
            return - maxHook;
        }
    }

    private function computeHook(point1, point2, param) {
        var toleranceMore = tolerance;
        var distance = ptAbs(ptOperate(point1, point2, bezierPt(bezier, param), function(p1, p2, t) {
            return (p1 + p2) / 2 - t;
        }));
        return (distance < toleranceMore) ? 0 : distance / (ptDistance(point1, point2) + toleranceMore);
    }

    private function pointDifference(points) {
        var diff = [];
        for(var i = 0, len = points.length; i < len - 1; i++)
            diff[i] = ptTime(ptMinus(points[i + 1], points[i]), len - 1);
        return diff;
    }

    private function B(u) {
        return [
            (1 - u) * (1 - u) * (1 - u),
            3 * u * (1 - u) * (1 - u),
            3 * u * u * (1 - u),
            u * u * u
        ];
    }

    private function bezierPt(b, t) {
        var pascal = [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1]];
        var s = 1 - t;
        var degree = b.length - 1;

        var spow = [1];
        var tpow = [1];
        for(var d = 0; d < degree; d++) {
            spow[d + 1] = spow[d] * s;
            tpow[d + 1] = tpow[d] * t;
        }

        var result = ptTime(b[0], spow[degree]);

        for(d = 1; d <= degree; d++)
            result = ptPlus(result,ptTime(b[d], pascal[degree][d] * spow[degree - d] * tpow[d]));
        return result;
    }

    // point 関数
    private function $P(x, y) {
        return new Point(x, y);
    }
    private function ptEqual(p1, p2) {
        return p1.x == p2.x && p1.y == p2.y;
    }
    private function ptIsZero(p) {
        return p.x == 0 && p.y == 0;
    }
    private function ptDistance(p1, p2) {
        return ptAbs($P(p1.x - p2.x, p1.y - p2.y));
    }
    private function ptAbs(p) {
        return Math.sqrt(p.x * p.x + p.y * p.y);
    }
    private function ptDot(p1, p2) {
        return p1.x * p2.x + p1.y * p2.y;
    }
    private function ptUnit(p) {
        var abs = ptAbs(p);
        return $P(p.x / abs, p.y / abs);
    }
    private function ptSquare(p) {
        return p.x * p.x + p.y * p.y;
    }
    private function ptPlus(p1, p2) {
        return $P(p1.x + p2.x, p1.y + p2.y);
    }
    private function ptMinus(p1, p2) {
        return $P(p1.x - p2.x, p1.y - p2.y);
    }
    private function ptTime(p, value) {
        return $P(p.x * value, p.y * value);
    }
    private function ptOperate() {
        var x = [], y = [];
        for(var i = 0, len = arguments.length - 1; i < len; i++) {
            x[i] = arguments[i].x;
            y[i] = arguments[i].y;
        }
        var op = arguments[arguments.length - 1];
        return $P(op.apply(null, x), op.apply(null, y));
    }

}
