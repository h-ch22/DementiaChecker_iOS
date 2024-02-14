//
//  DementiaPreventionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/14/24.
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
                                    
                                    Text("건강검진")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("정기적인 건강검진을 받습니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("고혈압, 당뇨, 고지혈증, 비만 등은 뇌혈관질환의 주요 위험 인자들입니다. 이러한 병들은 혈관벽을 두껍게 하고, 혈관의 내부를 좁게 하여 뇌로 가는 혈류량을 감소시켜 혈관성 치매와 알츠하이머 치매의 위험성을 증가시킵니다.\n뇌혈관질환의 위험인자들은 아스피린 등의 혈소판 응집 억제제나 항응고제, 혈류순환개선제 등을 투여하여 효과적으로 관리할 수 있습니다. 따라서 정기적인 건강검진으로 뇌혈관질환의 위험인자를 조기에 발견하고 적절한 의학적 치료를 하여 악화되지 않도록 합니다.")
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
                                    
                                    Text("식습관")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("과도한 음주와 흡연은 피하고, 균형 잡힌 영양을 섭취합니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("과도하거나 습관적인 음주는 뇌세포를 파괴하여 알코올성 치매를 일으킬 수 있습니다. 흡연을 하면 담배의 성분 중 니코틴이 뇌혈관을 수축시켜 뇌세포를 손상시킬 수 있습니다.\n또한, 비만을 피하는 식생활을 유지합니다. 일부 연구에서 비타민 C, E, 항산화제, 불포화지방산이 치매 위험성을 낮춘다고 보고되었으나, 이는 결과가 일관적이지 않아 아직 확립된 내용은 아닙니다.")
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
                                    
                                    Text("활동")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("적절한 운동과 대인관계, 사회활동을 유지합니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("중년기 이후의 성인에서 규칙적인 운동이 알츠하이머 치매의 위험성을 낮춘다는 것이 여러 연구를 통해 알려져 있습니다. 걷기와 같은 낮은 강도의 운동만으로도 인지기능저하와 치매의 위험을 낮출 수 있습니다. 또한 운동은 고혈압, 당뇨, 고지혈증, 비만 등의 뇌혈관 질환 위험인자들에 대해서도 보호효과를 가집니다.\n나아가, 혼자 고립되어 지내는 것보다 적당한 대인관계와 사회활동을 유지하는 것이 인지기능을 유지하고 치매를 예방하는 데에 도움이 됩니다. 가족과 대화를 나누고, 모임에 나가 사회활동을 지속하는 것이 좋습니다.")
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
                                    
                                    Text("두뇌 사용")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("활발하게 두뇌를 사용합니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("적절한 수준의 두뇌 활동을 유지하는 것이 치매 예방에 도움이 됩니다. 독서, 문화활동, 악기 연주, 정원 가꾸기, 운동, 라디오 청취, TV 시청 등 정신적인 노력이 동반되는 활동을 지속합니다. 평소 즐겨 하던 취미 생활을 지속적으로 유지하고, 나이가 들어서도 할 수 있는 즐거운 활동을 찾으십시오.")
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
                                    
                                    Text("우울증 치료")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("우울증을 치료합니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("우울증이 있을 경우 치매 발병률이 약 2~3배 높아진다는 것이 여러 연구에서 알려져 있습니다. 기전은 명확히 알려져 있지 않으나, 우울증이 있을 경우 스트레스 호르몬인 코티졸의 분비가 지속적으로 높아져 뇌에서 기억을 담당하는 해마 부위의 손상을 초래할 가능성이 있습니다.\n또한, 노인 우울증의 경우 기억력 등의 인지기능이 떨어지면서 가성 치매로 오인되기도 합니다. 따라서, 우울증이 있는 경우 방치하지 말고 적극적으로 치료해야 합니다.")
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
                                    
                                    Text("기억력, 인지기능")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 20)

                                HStack{
                                    Text("기억력이 떨어지면 조기에 진료를 받습니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("과거에 비해 기억력 및 인지기능이 떨어진다면 의료기관에서 전문가의 평가를 받습니다. 퇴행성 뇌질환 이외에도 인지기능 저하를 일으킬 수 있는 다양한 뇌질환의 가능성에 대한 평가와 치료를 위하여 중요합니다. 치매의 일부는 조기에 발견하여 치료하면 증상의 호전이나 완치를 기대할 수 있는 가역적인 원인을 가지고 있습니다.\n퇴행성 뇌질환에 의한 비가역적 치매의 경우, 현재까지 치매의 질병 경과를 바꿀 수 있는 치료법은 개발되어 있지 않지만, 인지기능개선제를 사용하면 치매의 증상을 완화시키고, 치매로 인한 심각한 장애에 이르는 기간을 상당 기간 늦추어 줄 수 있습니다.\n기억력 저하 뿐 아니라 치매에 동반되는 우울, 불안, 불면, 짜증, 분노, 의심, 배회 등의 행동심리증상의 경우 약물로 효과적인 조절이 가능합니다. 또한 치매와 수반된 가족 내의 심리적 변화나 갈등에 대한 중재, 효과적인 지역사회기반의 치료 및 돌봄을 위한 평가와 계획 수립을 위한 전문가의 진료가 필요합니다.")
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
                                Button("닫기"){
                                    dismiss()
                                }
                            })
                        }
                        .navigationTitle(Text("치매 예방과 관련된 내용"))
                }
            }
        }
    }
}

#Preview {
    DementiaPreventionView()
}
