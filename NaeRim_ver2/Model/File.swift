import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class ReadViewModel : ObservableObject{
    var ref = Database.database().reference()
    
    var roop_for_frame : Int?
    
    func readValue(){
        
        ref.child("total").observeSingleEvent(of: .value){snapshot in
            guard let total_value = snapshot.value as? Int else {
                return
            }
            
            print("reavdvalue total \(total_value)")
            
            self.roop_for_frame = total_value
        }
        
 
        ref.child("empty").observeSingleEvent(of: .value){snapshot in
            guard let empty_value = snapshot.value as? Int else {
                return
            }
            
            print("reavdvalue empty \(empty_value)")
        }
        
        for i in 0 ..< (roop_for_frame ?? 0){
            
            ref.child("frame\(i)").observeSingleEvent(of: .value){snapshot in
                guard let frame_value = snapshot.value as? [String:Any] else {
                    return
                }
                
                print("reavdvalue frame \(frame_value)")
            }
            
        }
    }
}
