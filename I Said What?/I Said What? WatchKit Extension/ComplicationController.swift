import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let twelveHours = NSDate(timeIntervalSinceNow: -12 * 60 * 60)
        handler(twelveHours)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        let sixHours = NSDate(timeIntervalSinceNow: 6 * 60 * 60)
        handler(sixHours)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        let privateAcct = TwitterAccount.isPrivate()
        handler(privateAcct ? .HideOnLockScreen : .ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        let tweetDate = NSDate(timeIntervalSinceNow: -365 * 24 * 60 * 60)
        let timelineEntry = createTimelineEntryOnTweetDate(tweetDate,
            currentDate: NSDate(), tweetText: "An entertaining tweet")
        handler(timelineEntry)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication,
        beforeDate date: NSDate, limit: Int,
        withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        let entries = TwitterAccount.tweetsBeforeDate(date).map {
            (date: NSDate, text: String) -> CLKComplicationTimelineEntry in
            let tweetDate = date.dateByAddingTimeInterval(-365 * 24 * 60 * 60)
            return createTimelineEntryOnTweetDate(tweetDate, currentDate:
                date, tweetText: text)
        }
        handler(entries)
    }

    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }

    func createTimelineEntryOnTweetDate(tweetDate: NSDate, currentDate: NSDate,
        tweetText: String) -> CLKComplicationTimelineEntry {

        let units: NSCalendarUnit = [.Year, .Month, .Day]
        let dateProvider = CLKDateTextProvider(date: tweetDate, units: units)
        let textProvider = CLKSimpleTextProvider(text: tweetText)

        let image = UIImage(named: "Complication/Modular")!
        let imageProvider = CLKImageProvider(onePieceImage: image)

        let complication = CLKComplicationTemplateModularLargeStandardBody()
        complication.headerTextProvider = dateProvider
        complication.body1TextProvider = textProvider
        complication.headerImageProvider = imageProvider
        return CLKComplicationTimelineEntry(
            date: currentDate, complicationTemplate: complication)
    }
    
}
