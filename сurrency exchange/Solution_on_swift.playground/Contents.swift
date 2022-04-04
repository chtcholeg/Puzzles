// Approach
//  We will build chains - a chain for each currency (except the main). Step by step:
//  1. Each chain (for currency #i) looks like: X_1 -> X_i
//  2. For each X_i, among the built chains, we find the one that is the best when added X_i at the end of the chain.
//  3. Checking if there are any improvements. + Maybe, there is a chain that satisfies the condition if we add X_1 to the end of this chain
//  4. Go to 2.
//
// Algorithm complexity
//  O(N^2 * K), where N = currency count, K = chain length
//  It's not a good complexity but I haven't found better
//
// To simplify, in this implementation, X_1 is the last one in the list of currencies
//
                                    

let currencyCount = 10
let intermediateCurrencyCount = currencyCount - 1
let targetCurrencyIndex = currencyCount - 1


struct Chain {
    var indices: [Int] = []
    var convertResult: Double = 0.0
    var loopResult: Double = 0.0
    
    func Copy() -> Chain {
        var copy = Chain()
        for index in indices {
            copy.indices.append(index)
        }
        copy.convertResult = convertResult
        return copy
    }
    
    func Dump(_ addMainCurrency : Bool) -> String {
        var result = chainToString(addMainCurrency)
        result.append(", result: ")
        result.append(String(loopResult))
        return result
    }
    
    mutating func Add(_ newIndex: Int) {
        if indices.isEmpty {
            indices.append(newIndex)
            convertResult = 1.0
            loopResult = 1.0
        } else {
            let prevIndex = indices.last!
            indices.append(newIndex)
            convertResult = convertCurrency(convertResult, prevIndex, newIndex)
            loopResult = convertCurrency(convertResult, newIndex, targetCurrencyIndex)
        }
    }
    
    private func convertCurrency(_ currencyValueFrom: Double, _ currencyIndexFrom: Int, _ currencyIndexTo: Int) -> Double
    {
        if currencyIndexFrom == currencyIndexTo {
            return currencyValueFrom
        }
        var koef = 0.6
        if (currencyIndexTo == targetCurrencyIndex) || (currencyIndexFrom == targetCurrencyIndex) {
            koef = 0.6
        } else if (currencyIndexFrom - currencyIndexTo) == 1 {
            koef = 1.1
        }
        return koef * currencyValueFrom
    }
    
    private func chainToString(_ addMainCurrency : Bool) -> String
    {
        var result = ""
        for index in indices {
            result.append(result.isEmpty ? "" : " -> ")
            result.append(String(index))
        }
        if addMainCurrency {
            result.append(result.isEmpty ? "" : " -> ")
            result.append(String(targetCurrencyIndex))
        }
        return result
    }
}

func findChain() -> Chain? {
    var chains: [Chain] = Array<Chain>(repeating: Chain(), count: currencyCount - 1)
    for i in 0..<(currencyCount-1) {
        chains[i].Add(targetCurrencyIndex)
    }

    var step = 0
    while true {
        step += 1
        
        var newChains: [Chain] = chains
        for currencyIndex in 0..<targetCurrencyIndex {
            var newChain: Chain?
            for chain in chains {
                var potentialNewChain = chain.Copy()
                potentialNewChain.Add(currencyIndex)
                if (newChain == nil) || (newChain!.convertResult < potentialNewChain.convertResult) {
                    newChain = potentialNewChain
                }
            }
            if newChain != nil {
                if newChain!.loopResult > 1.0 {
                    return newChain
                }
                newChains[currencyIndex] = newChain!
            }
        }
        
        if (step > 1) {
            var thereIsImprovement = false
            for currencyIndex in 0..<targetCurrencyIndex {
                if chains[currencyIndex].convertResult < newChains[currencyIndex].convertResult {
                    thereIsImprovement = true
                    break
                }
            }
            if !thereIsImprovement {
                break
            }
        }
        
        chains = newChains
    }
    return nil
}


var chain = findChain()
if chain == nil {
    print("NO")
} else {
    print("Target currency: " + String(targetCurrencyIndex))
    print(chain!.Dump(true))
}
