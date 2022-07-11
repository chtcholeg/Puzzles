class Solution {
public:
    int getLongestInterval(const std::vector<int>& arr) {
        int intervalLength = 0;
        int intervalWith0Length = 0;
        int maxLength = 0;
        bool onlyOnes = true;
        
        for (int val : arr) {
            if (val == 1) {
                ++intervalLength;
                ++intervalWith0Length;
                maxLength = std::max(intervalWith0Length, maxLength);
            } else {
                if (intervalLength > 0) {
                    intervalWith0Length = intervalLength;
                    intervalLength = 0;
                } else {
                    intervalWith0Length = 0;
                }
                onlyOnes = false;
            }
        }
        
        return maxLength + (onlyOnes ? -1 : 0);
    }
};