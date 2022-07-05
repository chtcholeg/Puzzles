class Solution {
    // LineDef - the parameters uniquely define the line 
    using LineDef = std::array<int, 4>;
    struct LineDefComparator {
        bool operator()(const LineDef& a, const LineDef& b) const {
            if (a[0] != b[0])
                return a[0] < b[0];
            if (a[1] != b[1])
                return a[1] < b[1];
            if (a[2] != b[2])
                return a[2] < b[2];
            return a[3] < b[3];
        }
    };
public:
    int maxPoints(vector<vector<int>>& points) {
        // Line equiation: lx + my + 1 = 0
        
        // Line that goes through two points:
        // l * x_1 + m * y_1 + 1 = 0
        // l * x_2 + m * y_2 + 1 = 0
        // =>
        // m * (y_1 * x_2 - y_2 * x_1) = (x_1 - x_2)
        // l * (x_1 * y_2 - x_2 * y_1) = (y_1 - y_2)
        
        // So, line that goes through two points is described by 4 numbers:
        // a_1: (y_1 * x_2 - y_2 * x_1)
        // a_2: (x_1 - x_2)
        // a_3: (x_1 * y_2 - x_2 * y_1)
        // a_4: (y_1 - y_2)
        // (a_1 and a_2) + (a_3 and a_4) have to be simplified
        // Actually line is described by 2 real number, but we need good accuracy (so we use 2 integer instead of a real)
        
        // ! This method is not optimized !
        
        int maxSize = points.empty() ? 0 : 1;
        std::map<LineDef, int, LineDefComparator> lineDefs;
        for (size_t i = 0; i < points.size(); ++i) {
            std::set<LineDef> linesGoThroughThisPoint;
            for (size_t j = 0; j < points.size(); ++j) {
                if (i == j)
                    continue;
                LineDef lineDef = getLineDef(points[i], points[j]);
                if (linesGoThroughThisPoint.count(lineDef))
                    continue;
                const int currentVal = ++lineDefs[lineDef];
                //if (currentVal > maxSize) {
                //    print(points[i], points[j], lineDef);
                //}
                maxSize = std::max(maxSize, currentVal);
                linesGoThroughThisPoint.insert(lineDef);
            }
        }
        return maxSize;
    }
    
private:
    static LineDef getLineDef(const vector<int>& pt1, const vector<int>& pt2) {
        const int x1 = pt1[0];
        const int y1 = pt1[1];
        const int x2 = pt2[0];
        const int y2 = pt2[1];
        LineDef res;
        res[0] = x1 - x2;
        res[1] = y1 - y2;
        simplify(res[0], res[1]);
        if (y1 != y2) {
            res[2] = x1 * y2 - x2 * y1;
            res[3] = y1 - y2;
            simplify(res[2], res[3]);
        } else {
            res[2] = y1;
            res[3] = 0;
        }
        return res;
    }
        
    static void simplify(int& first, int& second) {
        if (first == 0) {
            second = 1;
            return;
        }
        if (second == 0) {
            first = 1;
            return;
        }
        if (second < 0) {
            first = -first;
            second = -second;
        }
        int gcd = calcGCD(first, second);
        if (gcd > 1) {
            first /= gcd;
            second /= gcd;
        }
    }
    
    static int calcGCD(int first, int second) {
        int a = std::abs(first);
        int b = std::abs(second);
        if (a == 0 || b == 0)
            return 0;
        int r = a % b;
        while (r != 0) {
            a = b;
            b = r;
            r = a % b;
        }
        return b;
    }
    
    static void print(const vector<int>& pt1, const vector<int>& pt2, const LineDef& lineDef) {
       std::cout
           << "[" << pt1[0] << "," << pt1[1] << "] - "
           << "[" << pt2[0] << "," << pt2[1] << "] -> "
           << "(" << lineDef[0] << "," << lineDef[1] << "," << lineDef[2] << "," << lineDef[3] << ")" << std::endl;
    }
};