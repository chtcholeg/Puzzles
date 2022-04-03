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
    
    func Dump() -> String {
        var result = indices.description
        result.append(", conv: ")
        result.append(String(convertResult))
        result.append(", target: ")
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
            convertResult = ConvertCurrency(convertResult, prevIndex, newIndex)
            loopResult = ConvertCurrency(convertResult, newIndex, targetCurrencyIndex)
        }
    }
    
    func ConvertCurrency(_ currencyValueFrom: Double, _ currencyIndexFrom: Int, _ currencyIndexTo: Int) -> Double
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
    print(chain!.Dump())
}
