# CustomCoxcombLibrary

![Alt text](https://github.com/jatinverma007/CoxCombGraph/blob/master/Example/CustomCoxcombLibrary/AnimatedGraph.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CustomCoxcombLibrary is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CustomCoxcombLibrary', :git => 'https://github.com/jatinverma007/CoxCombGraph'
```
## Usage

    var customGraph:CXCustomGraph!

    override func viewDidLoad() {
        super.viewDidLoad()
        customGraph = CXCustomGraph(name: ["Health & Lifestyle", "Food & Grocery", "Added Money", "Shopping", "Recharge"], value: [20, 1, 17, 11, 22], 
        color: [UIColor.hexStringToUIColor(hex: "852929"), UIColor.hexStringToUIColor(hex: "53b7ff"), UIColor.hexStringToUIColor(hex: "3be05c"), 
        UIColor.hexStringToUIColor(hex: "da7804"), UIColor.hexStringToUIColor(hex: "e4cf29")], icons: [returnIconAccordingToCategory(category: "Health & 
        Lifestyle"), returnIconAccordingToCategory(category: "Food & Grocery"), returnIconAccordingToCategory(category: "Added Money"), 
        returnIconAccordingToCategory(category: "Shopping"), returnIconAccordingToCategory(category: "Recharge")])
        self.view.addSubview(customGraph!)
        customGraph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            customGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            customGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            customGraph.heightAnchor.constraint(equalToConstant: 270)
         ])
        }
    
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            customGraph.drawChart()
        }


## Author

jatinverma007, jatin.v1997@gmail.com
