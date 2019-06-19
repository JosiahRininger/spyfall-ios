//
//  Constraints.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import UIKit

class Constraints {
    
    func constraintWithTopAndLeadingAnchor(field: AnyObject, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, leadingConstant: CGFloat) {
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
    }
    
    func constraintWithTopLeadingAndTrailingAnchor(field: AnyObject, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, leadingConstant: CGFloat, trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, trailingConstant: CGFloat) {
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
        field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant).isActive = true
    }
    
    func constraintWithTopAndTrailingAnchor(field: AnyObject, width: CGFloat, height: CGFloat, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, trailingConstant: CGFloat) {
        
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant).isActive = true
    }
    
    func constraintWithCenterYAndLeading(field: AnyObject, CenterYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, CenterYConstant: CGFloat, leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, leadingConstant: CGFloat) {
        field.centerYAnchor.constraint(equalTo: CenterYAnchor, constant: CenterYConstant).isActive = true
        field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
    }
    
    func constraintWithHeightWidthTopAndCenterXAnchor(field: AnyObject, width: CGFloat, height: CGFloat, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, centerXConstant: CGFloat) {
        
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant).isActive = true
    }
    
    func constraintWithWidthHeightCenterYAndLeading(field: AnyObject, width: CGFloat, height: CGFloat, centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, centerYConstant: CGFloat, leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, leadingConstant: CGFloat) {
        
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant).isActive = true
        field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
    }
    
    func constraintWithCenterYAndTrailing(field: AnyObject, width: CGFloat, height: CGFloat, centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, centerYConstant: CGFloat, trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, trailingConstant: CGFloat) {
        
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant).isActive = true
        field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant).isActive = true
    }
    
    func constraintWithCenterYAndCenterXAnchor(field: AnyObject, width: CGFloat, height: CGFloat, centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, centerYConstant: CGFloat, centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, centerXConstant: CGFloat) {
        
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.heightAnchor.constraint(equalToConstant: height).isActive = true
        field.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant).isActive = true
        field.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant).isActive = true
    }
    
    func constraintWithTopAnchor(field: AnyObject, bottomLeadingAndTrailingAnchorField: AnyObject, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat) {
        
        field.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        field.bottomAnchor.constraint(equalTo: bottomLeadingAndTrailingAnchorField.bottomAnchor, constant: 0).isActive = true
        field.leadingAnchor.constraint(equalTo: bottomLeadingAndTrailingAnchorField.leadingAnchor, constant: 0).isActive = true
        field.trailingAnchor.constraint(equalTo: bottomLeadingAndTrailingAnchorField.trailingAnchor, constant: 0).isActive = true
    }
    
    func constraintWithBottomAnchor(field: AnyObject, topLeadingAndTrailingAnchorField: AnyObject, bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, bottomConstant: CGFloat) {
        
        field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        field.topAnchor.constraint(equalTo: topLeadingAndTrailingAnchorField.topAnchor, constant: 0).isActive = true
        field.leadingAnchor.constraint(equalTo: topLeadingAndTrailingAnchorField.leadingAnchor, constant: 0).isActive = true
        field.trailingAnchor.constraint(equalTo: topLeadingAndTrailingAnchorField.trailingAnchor, constant: 0).isActive = true
    }
    
    func constraintWithTopBottomLeadingAndTrailingAnchor(field: AnyObject, topBottomLeadingAndTrailingAnchorField: AnyObject) {
        
        field.topAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.topAnchor, constant: 0).isActive = true
        field.bottomAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.bottomAnchor, constant: 0).isActive = true
        field.leadingAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.leadingAnchor, constant: 0).isActive = true
        field.trailingAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.trailingAnchor, constant: 0).isActive = true
    }
    
    func constraintForCellAnchor(field: AnyObject, topBottomLeadingAndTrailingAnchorField: AnyObject, constant: CGFloat = 0) {
        
        field.topAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.topAnchor, constant: constant / 7).isActive = true
        field.bottomAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.bottomAnchor, constant: -constant / 7).isActive = true
        field.leadingAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.leadingAnchor, constant: constant).isActive = true
        field.trailingAnchor.constraint(equalTo: topBottomLeadingAndTrailingAnchorField.trailingAnchor, constant: -constant).isActive = true
    }
    
    func constraintToNavigationBar(field: AnyObject, navBar: AnyObject, width: CGFloat) {
        
        field.heightAnchor.constraint(equalToConstant: navBar.frame.height + UIElementSizes.statusBarHeight).isActive = true
        field.widthAnchor.constraint(equalToConstant: width).isActive = true
        field.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive = true
        
    }
}
