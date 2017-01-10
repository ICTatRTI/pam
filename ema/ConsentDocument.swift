//
//  ConsentDocument.swift
//  workaday
//
//  Created by Adam Preston on 4/12/16.
//  Copyright © 2016 RTI. All rights reserved.
//


import ResearchKit

class ConsentDocument: ORKConsentDocument {
    
    
    
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        title = NSLocalizedString("Research Health Study Consent Form", comment: "")
        
        let sectionTypes: [ORKConsentSectionType] = [
            .overview,
            .dataGathering,
            .privacy,
            .dataUse,
            .withdrawing
        ]
        
        
        let consentSections: [ORKConsentSection] = sectionTypes.map {
            contentSectionType in
            
            let consentSection = ORKConsentSection(type: contentSectionType)
            
            if contentSectionType == .overview {
                consentSection.htmlContent = loadHTMLContent(fileName: "Consent_Welcome")
            }else if contentSectionType == .dataGathering {
                consentSection.htmlContent = loadHTMLContent(fileName: "Consent_DataGathering")
            }else if contentSectionType == .privacy {
                consentSection.htmlContent = loadHTMLContent(fileName: "Consent_Privacy")
            }else if contentSectionType == .dataUse {
                consentSection.htmlContent = loadHTMLContent(fileName: "Consent_DataUse")
            }else if contentSectionType == .withdrawing {
                consentSection.htmlContent = loadHTMLContent(fileName: "Consent_Withdrawing")
            }
            
            return consentSection
            
        }
        
        sections = consentSections
        
        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


