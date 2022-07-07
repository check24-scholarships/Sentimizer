//
//  PrivacyPolicy.swift
//  Sentimizer
//
//  Created by Samuel Ginsberg on 07.07.22.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.bgColor.ignoresSafeArea()
            
            ScrollView {
                Text("""
**Privacy Policy**

Justin Hohenstein built the Sentimizer app as a Free app. This SERVICE is provided by Justin Hohenstein at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

**Sentimizer does not collect any data. Everything is only saved on your device.** We regularly send parts of the data you provided to a server. The server immediately deletes the data after analyzing it. We don't share any of your data with other people or companies.

*Security*
I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

*Changes to This Privacy Policy*
I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2022-07-07

*Contact Us*
If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at samuel.ginsberg@t-online.de.

*Consent*
By using our app, you hereby consent to our Privacy Policy and agree to its Terms and Conditions.

""")
                .padding()
                .padding(.top, 50)
                .font(.body)
            }
            
            DismissButton()
        }
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
