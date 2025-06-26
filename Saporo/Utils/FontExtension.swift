//
//  FontExtension.swift
//  ipadOS
//
//  Created by Marcelle Ribeiro Queiroz on 25/06/25.
//

import Foundation
import SwiftUI

extension Font {
    
    // MARK: Fonte Regular
    static func poppinsRegular(size: CGFloat) -> Font {
        let cfURL = Bundle.main.url(
            forResource: "Poppins-Regular", // Nome do ARQUIVO
            withExtension: "ttf"
        )! as CFURL
        
        if let uiFont = UIFont(name: "Poppins Regular", size:  size) {
            return Font(uiFont)
        }
        
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        let uiFont = UIFont(name: "Poppins Regular", size:  size) // Nome da FONTE
        
        return Font(uiFont ?? UIFont())
    }
    
    // MARK: Fonte Média
    static func poppinsMedium(size: CGFloat) -> Font {
        let cfURL = Bundle.main.url(
            forResource: "Poppins-Medium", // Nome do ARQUIVO
            withExtension: "ttf"
        )! as CFURL
        
        if let uiFont = UIFont(name: "Poppins Medium", size:  size) {
            return Font(uiFont)
        }
        
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        let uiFont = UIFont(name: "Poppins Medium", size:  size) // Nome da FONTE
        
        return Font(uiFont ?? UIFont())
    }
    
    // MARK: Fonte Bold
    static func poppinsBold(size: CGFloat) -> Font {
        let cfURL = Bundle.main.url(
            forResource: "Poppins-Bold", // Nome do ARQUIVO
            withExtension: "ttf"
        )! as CFURL
        
        if let uiFont = UIFont(name: "Poppins Bold", size:  size) {
            return Font(uiFont)
        }
        
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        let uiFont = UIFont(name: "Poppins Bold", size:  size) // Nome da FONTE
        
        return Font(uiFont ?? UIFont())
    }
}
