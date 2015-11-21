import Foundation

struct TwitterAccount {
    static internal func isPrivate() -> Bool {
        return true
    }

    static func tweetsBeforeDate(date: NSDate) -> [(date: NSDate, text: String)] {
        var tweets: [(date: NSDate, text: String)] = []
        for i in 1...5 {
            let interval = arc4random_uniform(UInt32(i * 10))
            let timelineDate = date.dateByAddingTimeInterval(-1 * Double(interval) * 60)
            let tweetText = "My tweet at \(timelineDate)"
            tweets.append((timelineDate, tweetText))
        }
        return tweets
    }
}