// Approach:
// 1. We mark every number as beginning of consecutive sequence (it's not true but we start from this)
// 2. We remove mark of beginning from number if there is a number on the left of it
// 3. We run through the array and check sequences only from beginning of consecutive sequence 

class Solution {
public:
    int longestConsecutive(vector<int>& nums) {
        if (nums.empty())
            return 0;
        
        std::unordered_map<int /*value*/, bool /*is beginnig of consequance*/> isBeginning;
        
        // 1. Default initialization
        for (int num : nums)
            isBeginning[num] = true;
        
        // 2. Remove wrong begginings
        for (int num : nums) {
            if (isBeginning.count(num - 1) != 0)
                isBeginning[num] = false;
        }
        
        // 3. Run through begginings
        int maxLength = 1;
        for (int num : nums) {
            if (!isBeginning[num])
                continue;
            int currentLength = 1;
            for (int i = num + 1; isBeginning.count(i) != 0; ++i)
                ++currentLength;
            maxLength = std::max(currentLength, maxLength);
        }
        
        return maxLength;
    }
};