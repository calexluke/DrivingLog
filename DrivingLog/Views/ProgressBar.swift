//
//  ProgressBar.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/26/22.
//

import SwiftUI

struct ProgressBar: View {
    
    //Initializing variables that will assist in the creation of a progress bar, such as width and height
    var width: CGFloat = 200
    var height: CGFloat = 20
    var cornerRadius: CGFloat {
        return height / 2
    }
    var percent: CGFloat = 0.59
    let minimumPercentToDisplay = 0.1
    
    //Initializing colors that will represent both the day and the night progress bars
    var color1 = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    var color2 = Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    
    var progressWidth: CGFloat {
        // progress bar looks weird when only filled in a tiny bit
        // ensure that it is either empty, or filled to a minumum level
        var percentToDisplay = percent
        if percent > 0 && percent <= minimumPercentToDisplay {
            percentToDisplay = minimumPercentToDisplay
        }
        return percentToDisplay * width
    }
    
    //This is the progress bar that the user will see in the Progress View screen
    var body: some View {
        ZStack(alignment: .leading){
            
            //The progress bar is consisting of two rounded rectangles. This one is without the gradient
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(width: width, height: height)
                .foregroundColor(Theme.secondaryBackgroundColor)
            
            //The progress bar is consistent of two rounded rectangles. This one is with the gradient
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(width: progressWidth, height: height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                )
                .foregroundColor(Color.clear)
        }
    }
}

//This works to produce a view preview of a progress bar in the Xcode IDE
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
    }
}
