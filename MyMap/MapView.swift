//
//  MapView.swift
//  MyMap
//
//  Created by 中原麻央 on 2022/12/14.
//

import SwiftUI
import MapKit

//マップの種類を示す列拳型
enum MapType {
    
    case standard         //標準
    
    case satellitie       //衛生写真
    
    case hybrid           //衛生写真＋交通機関ラベル
}

struct MapView: UIViewRepresentable {
    //検索キーワード
    let searchkey: String
    
    //マップ種類
    let mapType: MapType
    
    //表示する　View　を作成するときに実行
    func makeUIView(context: Context) -> MKMapView {
        //MKmapViewのインスタンスを生成
        MKMapView()
    }
    
    //表示した　View が更新されるたびに実行
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //入力された文字をデバックエリアに表示
        print("検索キーワード: \(searchkey)")
        
        //マップの種類の設定
        switch mapType {
            
        case .standard:
            uiView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle:  .flat)
        case .satellitie:
            uiView.preferredConfiguration = MKHybridMapConfiguration()
            
        case .hybrid:
            uiView.preferredConfiguration = MKHybridMapConfiguration()
        }
        
        //CLGeocoderインスタンスを作成
        let geocoder = CLGeocoder()
        
        //入力された文字から位置情報を取得
        geocoder.geocodeAddressString(
            searchkey,
            completionHandler: { (placemarks,error) in
                //リクエストの結果が存在し、1件目の情報から位置情報を取り出す
                if let placemarks,
                   let firstPlacemark = placemarks.first,
                   let location = firstPlacemark.location{
                    
                    //位置情報から緯度経度をtagetCoordinateに取り出す
                    let tagetCoordinate = location.coordinate
                    
                    //緯度経度をデバックエリアに表示
                    print("(緯度経度：\(tagetCoordinate))")
                    
                    //MKPointAnnotationインスタンスを生成し、ピンを作る
                    let pin = MKPointAnnotation()
                    
                    //ピンを置く場所に緯度経度を設定
                    pin.coordinate = tagetCoordinate
                    
                    //ピンのタイトルを設定
                    pin.title = searchkey
                    
                    //ピンを地図に置く
                    uiView.addAnnotation(pin)
                    
                    //緯度経度を中心に半径500mの範囲を表示
                    uiView.region = MKCoordinateRegion(
                        center: tagetCoordinate,
                        latitudinalMeters: 500.0,
                        longitudinalMeters: 500.0)
                    
                }
                
                
            })
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView(searchkey: "羽田空港", mapType: .standard)
        }
    }
}
