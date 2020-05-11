//
//  Created by Zsombor Szabo on 10/05/2020.
//  
//

import SwiftUI

struct Reporting: View {
    
    @EnvironmentObject var localStore: LocalStore
    
    @State var isShowingCallCode = false
    
    @State var selectedTestResultIndex = 0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0) {
                    
                    Text("Notify Others")
                        .font(.custom("Montserrat-SemiBold", size: 31))
                        .foregroundColor(Color("Title Text Color"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, .headerHeight)
                        .padding(.horizontal, 2 * .standardSpacing)
                    
                    Spacer(minLength: 2 * .standardSpacing)
                    
                    Text("If you tested positive for the virus that causes COVID-19, you can choose to share your diagnosis. This will help others in your community contain the spread of the virus.")
                        .font(.custom("Montserrat-Regular", size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Title Text Color"))
                        .padding(.horizontal, 2 * .standardSpacing)
                    
                    Button(action: {
                        
                        func afterGetAndPostDiagnosisKeys(result: String) {
                            let testResult = TestResult(id: UUID(), isAdded: false, dateAdministered: Date(), isShared: true, verificationCode: result, isVerified: false)
                            self.localStore.testResults.insert(testResult, at: 0)
                            self.selectedTestResultIndex = 0
                            self.isShowingCallCode = true
                        }
                        
                        afterGetAndPostDiagnosisKeys(result: String(Int.random(in: 10000..<99999)))
                        
//                        ExposureManager.shared.getAndPostDiagnosisKeys { (result) in
//
//                            switch result {
//                                case let .success(verificationCode):
//
//                                    afterGetAndPostDiagnosisKeys(result: verificationCode ?? "123456789")
//
//                                case let .failure(error):
//                                    UIApplication.shared.topViewController?.present(
//                                        error as NSError,
//                                        animated: true,
//                                        completion: nil
//                                    )
//                                    return
//                            }
//
//                        }
                        
                    }) {
                        
                        Text("Share a Positive Diagnosis").modifier(SmallCallToAction())
                        
                    }.frame(minHeight: .callToActionSmallButtonHeight)
                        .padding(.top, 2 * .standardSpacing)
                        .padding(.horizontal, 2 * .standardSpacing)
                        .sheet(isPresented: self.$isShowingCallCode) {
                            ReportingCallCode(selectedTestResultIndex: self.selectedTestResultIndex)
                                .environmentObject(self.localStore)
                    }
                    
                    Image("Doctors Security")
                    
                    VStack(spacing: 0) {
                        Text("Past Positive Diagnoses")
                            .font(.custom("Montserrat-SemiBold", size: 18))
                            .foregroundColor(Color("Title Text Color"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 2 * .standardSpacing)
                            .padding(.bottom, .standardSpacing)
                        
                        ForEach(self.localStore.testResults, id:\.id) { testResult in
                            
                            Button(action: {
                                
                                self.selectedTestResultIndex = self.localStore.testResults.firstIndex { testResult.id == $0.id } ?? 0
                                self.isShowingCallCode.toggle()
                                
                            }) {
                                HStack(spacing: .standardSpacing) {
                                    
                                    if !testResult.isVerified {
                                        Image("Past Diagnosis Row Alert")
                                    } else {
                                        Image("Past Diagnosis Row Checkmark")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                        if !testResult.isVerified {
                                            
                                            Text("Needs Verification")
                                                .font(.custom("Montserrat-Bold", size: 14))
                                                .foregroundColor(Color("Alert Background Critical Color"))
                                            
                                        } else {
                                            
                                            Text("Verified")
                                                .font(.custom("Montserrat-Bold", size: 14))
                                                .foregroundColor(Color.init(red: 75.0/255.0, green: 10.0/255.0, blue: 112.0/255.0))
                                            
                                        }
                                        
                                        Text("COVID-19 Positive")
                                            .font(.custom("Montserrat-Bold", size: 14))
                                            .foregroundColor(Color("Title Text Color"))
                                        
                                        Text(verbatim: String.localizedStringWithFormat(NSLocalizedString("Test Date: %@", comment: ""), DateFormatter.localizedString(from: testResult.dateAdministered, dateStyle: .short, timeStyle: .none)))
                                            .font(.custom("Montserrat-Regular", size: 14))
                                            .foregroundColor(Color("Title Text Color"))
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    if !testResult.isVerified {
                                        Image("Exposure Row Right Arrow")
                                    }
                                    
                                }
                                .padding(.horizontal, 2 * .standardSpacing)
                                    .frame(minHeight: 84, alignment: .leading)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .border(Color("Settings Button Border Color"), width: 1)
                            }
                            .disabled(testResult.isVerified)
                            .sheet(isPresented: self.$isShowingCallCode) {
                                ReportingCallCode(selectedTestResultIndex: self.selectedTestResultIndex).environmentObject(self.localStore)
                            }
                        }
                        
                        Image("Powered By CW Grey")
                            .padding(.top, 2 * .standardSpacing)
                            .padding(.bottom, .standardSpacing)
                        
                    }.padding(.horizontal, 2 * .standardSpacing)
                    //.background(Color.init(white: 0.949))
                }
            }
            
            HeaderBar(showMenu: false, showDismissButton: true)
        }
    }
}

struct Reporting_Previews: PreviewProvider {
    static var previews: some View {
        Reporting()
    }
}