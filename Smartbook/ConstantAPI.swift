//
//  ConstantAPI.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import Foundation
import UIKit

public class ConstantAPI {
    
    static let BASEURL: String = "http://Jmact.jasamarga.co.id:8000/smartbook"
    
    static func getImageBaseURL() -> String {
        
        return BASEURL + "/public"
    }
    
    static func getMainMenuURL() -> String {
        
        return BASEURL + "/api/menuaplikasi"
    }
    
    static func getSubMenuURL() -> String {
        
        return BASEURL + "/api/submenuaplikasi"
    }
    
    static func getCabangURL() -> String {
        
        return BASEURL + "/api/cabangmenu"
    }
    
    static func getListPerusahaanURL() -> String {
        
        return BASEURL + "/api/listperusahaan"
    }
    
    static func getPusatURL() -> String {
        
        return BASEURL + "/api/pusatmenu"
    }
    
    static func getPenghargaanURL() -> String {
    
        return BASEURL + "/api/penghargaan"
    }
    
    static func getPersonalInfoURL() -> String {
        
        return BASEURL + "/api/personalinfo"
    }
    
    static func getAtasanInfoURL() -> String {
        
        return BASEURL + "/api/getatasan"
    }
    
    static func getPeerInfoURL() -> String {
        
        return BASEURL + "/api/getpeer"
    }
    
    static func getBawahanInfoURL() -> String {
        
        return BASEURL + "/api/getbawahan"
    }
    
    static func getArtikelURL() -> String {
        
        return BASEURL + "/api/article"
    }
    
    static func getLoginURL() -> String {
        
        return BASEURL + "/api/login"
    }
    
    static func getUbahPasswordURL() -> String {
        return BASEURL + "/updatepass.php"
    }
    
}
