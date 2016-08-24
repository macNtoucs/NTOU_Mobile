//
//  NTOUConstants.m
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUConstants.h"

// keys for NSUserDefaults dictionary go here (app preferences)
NSString * const NTOUModuleTabOrderKey = @"NTOUModuleTabOrder";
NSString * const NTOUActiveModuleKey = @"ActiveModule";
NSString * const NTOUNewsTwoFirstRunKey = @"NTOUNews2ClearedCachedArticles";
NSString * const NTOUEventsModuleInSortOrderKey = @"NTOUEventsModuleInSortOrder";
NSString * const EmergencyUnreadCountKey = @"UnreadEmergencyCount";
NSString * const ShuttleSubscriptionsKey = @"ActiveShuttleSubscriptions";
NSString * const StellarTermKey = @"StellarTerm";
NSString * const TwitterShareUsernameKey = @"TwitterShareUsername";
NSString * const NTOUDeviceIdKey = @"device_id";
NSString * const NTOUPassCodeKey = @"pass_key";
NSString * const DeviceTokenKey = @"DeviceToken";
NSString * const NTOUUnreadNotificationsKey = @"UnreadNotifications";
NSString * const PushNotificationSettingsKey = @"ModulesDisabledForPush";
NSString * const NTOUModulesSavedStateKey = @"NTOUModulesSavedState";
NSString * const CachedMapSearchQueryKey = @"CachedMapSearchQuerey";
NSString * const LibrariesLinksUpdatedKey = @"LibrariesLinksUpdated";
NSString * const LibrariesLinksKey = @"LibrariesLinks";

NSString * const NTOUInternalURLScheme = @"NTOUmobile";


// module tags
NSString * const CalendarTag   = @"calendar";
NSString * const EmergencyTag  = @"emergencyinfo";
NSString * const CampusMapTag  = @"map";
NSString * const NewsOfficeTag = @"newsoffice";
NSString * const DirectoryTag  = @"people";
NSString * const StellarTag    = @"stellar";
NSString * const InformationTag    = @"information";
NSString * const ShuttleTag    = @"shuttletrack";
NSString * const ToursTag      = @"tours";
NSString * const AnniversaryTag = @"NTOU150";
NSString * const MobileWebTag  = @"mobileweb";
NSString * const SettingsTag   = @"settings";
NSString * const AboutTag      = @"about";
NSString * const LinksTag      = @"links";
NSString * const QRReaderTag    = @"qrreader";
NSString * const FacilitiesTag    = @"facilities";
NSString * const LibrariesTag   = @"libraries";
NSString * const FreshmenTag   = @"freshmen";
NSString * const SipPhoneTag = @"sipphone";

// notification names
NSString * const EmergencyInfoDidLoadNotification = @"NTOUEmergencyInfoDidLoadNotification";
NSString * const EmergencyInfoDidFailToLoadNotification = @"NTOUEmergencyInfoDidFailToLoadNotification";
NSString * const EmergencyInfoDidChangeNotification = @"NTOUEmergencyInfoDidChangeNotification";
NSString * const EmergencyContactsDidLoadNotification = @"NTOUEmergencyContactsDidLoadNotification";

NSString * const ShuttleAlertRemoved = @"NTOUShuttleAlertRemovedNotification";

NSString * const UnreadBadgeValuesChangeNotification = @"UnreadBadgeValuesChangeNotification";

NSString * const MyStellarAlertNotification = @"MyStellarAlertNotification";

// core data entity names
NSString * const NewsStoryEntityName = @"NewsStory";
NSString * const NewsCategoryEntityName = @"NewsCategory";
NSString * const NewsImageEntityName = @"NewsImage";
NSString * const NewsImageRepEntityName = @"NewsImageRep";
NSString * const PersonDetailsEntityName = @"PersonDetails";
NSString * const StellarCourseEntityName = @"StellarCourse";
NSString * const StellarClassEntityName = @"StellarClass";
NSString * const StellarClassTimeEntityName = @"StellarClassTime";
NSString * const StellarStaffMemberEntityName = @"StellarStaffMember";
NSString * const StellarAnnouncementEntityName = @"StellarAnnouncement";
NSString * const EmergencyInfoEntityName = @"EmergencyInfo";
NSString * const EmergencyContactEntityName = @"EmergencyContact";
NSString * const ShuttleRouteEntityName = @"ShuttleRouteCache";
NSString * const ShuttleStopEntityName = @"ShuttleStopLocation";
NSString * const ShuttleRouteStopEntityName = @"ShuttleRouteStop";
NSString * const CalendarEventEntityName = @"NTOUCalendarEvent";
NSString * const CalendarCategoryEntityName = @"EventCategory";
NSString * const CampusMapSearchEntityName = @"MapSearch";
NSString * const CampusTourEntityName = @"CampusTour";
NSString * const TourSiteOrRouteEntityName = @"TourSiteOrRoute";
NSString * const CampusTourSideTripEntityName = @"CampusTourSideTrip";
NSString * const TourStartLocationEntityName = @"TourStartLocation";
NSString * const QRReaderResultEntityName = @"QRReaderResult";

// resource names

NSString * const NTOUImageNameBackground      = @"global/body-background.png";

NSString * const NTOUImageNameEmail           = @"global/action-email.png";
NSString * const NTOUImageNameEmailHighlight  = @"global/action-email-highlight.png";
NSString * const NTOUImageNameMap             = @"global/action-map.png";
NSString * const NTOUImageNameMapHighlight    = @"global/action-map-highlight.png";
NSString * const NTOUImageNamePeople          = @"global/action-people.png";
NSString * const NTOUImageNamePeopleHighlight = @"global/action-people-highlight.png";
NSString * const NTOUImageNamePhone           = @"global/action-phone.png";
NSString * const NTOUImageNamePhoneHighlight  = @"global/action-phone-highlight.png";
NSString * const NTOUImageNameExternal           = @"global/action-external.png";
NSString * const NTOUImageNameExternalHighlight  = @"global/action-external-highlight.png";
NSString * const NTOUImageNameEmergency          = @"global/action-emergency.png";
NSString * const NTOUImageNameEmergencyHighlight = @"global/action-emergency-highlight.png";
NSString * const NTOUImageNameSecure           = @"global/action-secure.png";
NSString * const NTOUImageNameSecureHighlight  = @"global/action-secure-highlight.png";
NSString * const NTOUImageNameCalendar       = @"global/action-calendar";
NSString * const NTOUImageNameCalendarHighlight  = @"global/action-calendar-highlight";

NSString * const NTOUImageNameScrollTabBackgroundOpaque = @"global/scrolltabs-background-opaque.png";
NSString * const NTOUImageNameScrollTabBackgroundTranslucent = @"global/scrolltabs-background-transparent.png";
NSString * const NTOUImageNameScrollTabLeftEndCap = @"global/scrolltabs-leftarrow.png";
NSString * const NTOUImageNameScrollTabRightEndCap = @"global/scrolltabs-rightarrow.png";
NSString * const NTOUImageNameScrollTabSelectedTab = @"global/scrolltabs-selected.png";

NSString * const NTOUImageNameLeftArrow = @"global/arrow-white-left.png";
NSString * const NTOUImageNameRightArrow = @"global/arrow-white-right.png";
NSString * const NTOUImageNameUpArrow = @"global/arrow-white-up.png";
NSString * const NTOUImageNameDownArrow = @"global/arrow-white-down.png";

NSString * const NTOUImageNameSearch = @"global/search.png";
NSString * const NTOUImageNameBookmark = @"global/bookmark.png";

// Info.plist additions

NSString * const NTOUBuildRevisionKey = @"NTOUBuildRevision";
NSString * const NTOUBuildDescriptionKey = @"NTOUBuildDescription";


/* Touchstone/Shibboleth-related errors */
NSString * const MobileWebErrorDomain = @"edu.NTOU.mobile.WebRequestError";
NSString * const MobileWebTouchstoneErrorDomain = @"edu.NTOU.mobile.TouchstoneError";

NSString* const MobileLoginKeychainIdentifier = @"edu.NTOU.mobile.MobileWebLogin";

//API Url
NSString * const NTOUUrlSipPhone = @"http://140.121.197.122/";