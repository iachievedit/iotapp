import Foundation

func logmsg(message:String, functionName:String = __FUNCTION__,
         fileName:String = __FILE__, lineNumber:Int = __LINE__) {
  let now = NSDate()
  let formatter = NSDateFormatter()
  formatter.dateStyle = .ShortStyle
  formatter.timeStyle = .ShortStyle
  let timestamp = formatter.stringFromDate(now)
  print("\(timestamp) \(fileName):\(lineNumber) \(functionName): \(message)")
}
