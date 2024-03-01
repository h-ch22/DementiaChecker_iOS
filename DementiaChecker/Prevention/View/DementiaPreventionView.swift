//
//  DementiaPreventionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/14/24.
//

import SwiftUI

struct DementiaPreventionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
                    VStack{
                        Group{
                            VStack{
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("Medical Check-ups")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("Get regular medical check-ups.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("High blood pressure, diabetes, hyperlipidemia, obesity, etc. are major risk factors for cerebrovascular disease. These diseases increase the risk of vascular dementia and Alzheimer's dementia by thickening the walls of blood vessels and narrowing the inside of blood vessels, thereby reducing the amount of blood flow to the brain.\nRisk factors for cerebrovascular disease can be effectively managed by administering platelet aggregation inhibitors such as aspirin, anticoagulants, and blood circulation improvement agents. Therefore, through regular medical checkups, we detect risk factors for cerebrovascular disease early and provide appropriate medical treatment to prevent them from worsening.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                            
                            Spacer().frame(height: 20)

                            VStack{
                                HStack{
                                    Image(systemName: "carrot.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("Eating habits")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("Avoid excessive drinking and smoking, and eat balanced nutrition.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Excessive or habitual drinking can destroy brain cells, causing alcoholic dementia. Smoking can damage brain cells by causing nicotine, which is an ingredient in cigarettes, to constrict blood vessels in the brain.\nAlso, it maintains a diet that avoids obesity. Some studies have reported that vitamin C, E, antioxidants, and unsaturated fatty acids lower the risk of dementia, but these are not yet established due to inconsistent results.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                            
                            Spacer().frame(height: 20)

                            VStack{
                                HStack{
                                    Image(systemName: "figure.run")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("Activity")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("Maintain proper exercise, interpersonal relationships, and social activities.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Several studies have shown that regular exercise in adults after middle age can lower the risk of Alzheimer's dementia. Only low-intensity exercise such as walking can lower the risk of cognitive decline and dementia. It can also protect against risk factors for cerebrovascular diseases such as high blood pressure, diabetes, hyperlipidemia, and obesity.\n Furthermore, maintaining proper interpersonal relationships and social activities can help maintain cognitive function and prevent dementia, rather than being isolated alone. It is recommended to have conversations with your family, go to meetings, and continue social activities.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                            
                            Spacer().frame(height: 20)

                            VStack{
                                HStack{
                                    Image(systemName: "brain.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("The use of brain")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("Use your brain actively.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Maintaining an appropriate level of brain activity can help prevent dementia. Continue activities that involve mental effort, such as reading, cultural activities, playing musical instruments, gardening, exercising, listening to the radio, and watching TV. Maintain a hobby that you usually enjoy, and find fun activities that you can do even when you get older.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                            
                            Spacer().frame(height: 20)

                            VStack{
                                HStack{
                                    Image(systemName: "cross.case.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("The treatment of depression")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("If you have depression, treat it.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("It has been known in several studies that depression increases the incidence of dementia by about two to three times. The mechanism is not clearly known, but depression can lead to continuous high secretion of cortisol, a stress hormone, which can lead to damage to the hippocampus, which is responsible for memory, in the brain.\nAlso, in the case of depression in the elderly, it can be mistaken for pseudo-dementia due to poor cognitive functions such as memory. Therefore, if you have depression, you should not leave it unattended and actively treat it.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                            
                            Spacer().frame(height: 20)

                            VStack{
                                HStack{
                                    Image(systemName: "puzzlepiece.extension.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("Memory and cognitive function")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("If you think your memory has deteriorated, seek medical attention early.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("If memory and cognitive function are poor compared to the past, they are evaluated by experts at medical institutions. In addition to degenerative brain diseases, it is important for the evaluation and treatment of various brain diseases that can cause cognitive decline. Some dementia patients have reversible causes that, if detected and treated early, can expect improvement or cure of symptoms.\nIn the case of irreversible dementia caused by degenerative brain diseases, no treatment has been developed to change the course of dementia, but the use of cognitive improvement agents can alleviate the symptoms of dementia and delay the period leading to serious disability caused by dementia for a considerable period of time.\n In addition to poor memory, behavioral psychological symptoms such as depression, anxiety, insomnia, irritation, anger, suspicion, and wandering accompanying dementia can be effectively controlled with drugs. In addition, specialist treatment is needed to mediate psychological changes or conflicts in the family and to evaluate and plan for effective community-based treatment and care.")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        }

                    }.padding(20)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading, content: {
                                Button("Close"){
                                    dismiss()
                                }
                            })
                        }
                        .navigationTitle(Text("Information on the prevention of dementia"))
                }
            }
        }
    }
}

#Preview {
    DementiaPreventionView()
}
