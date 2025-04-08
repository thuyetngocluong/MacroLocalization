import MacroLocalization
import Foundation

let a = #localized("""
    
    Hello word 
    adf
    adf
    adf
    a
    
    """)
let b = #localized("Hello word")

print(a, b)
