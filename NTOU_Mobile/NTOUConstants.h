//
//  NTOUConstants.h
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NTOUNavigationParadigmTabBar,
    NTOUNavigationParadigmSpringboard
} NTOUNavigationParadigm;

// common URLs
// Deprecated due to NTOUMobileServerConfiguration functions
/*
 extern NSString * const NTOUMobileWebDomainString;
 extern NSString * const NTOUMobileWebAPIURLString;
 */

// keys for NSUserDefaults dictionary go here (app preferences)
extern NSString * const NTOUModuleTabOrderKey;
extern NSString * const NTOUActiveModuleKey;
extern NSString * const NTOUNewsTwoFirstRunKey;
extern NSString * const NTOUEventsModuleInSortOrderKey;
extern NSString * const EmergencyInfoKey;
extern NSString * const EmergencyLastUpdatedKey;
extern NSString * const EmergencyUnreadCountKey;
extern NSString * const ShuttleSubscriptionsKey;
extern NSString * const StellarTermKey;
extern NSString * const TwitterShareUsernameKey;
extern NSString * const NTOUDeviceIdKey;
extern NSString * const NTOUPassCodeKey;
extern NSString * const DeviceTokenKey;
extern NSString * const NTOUUnreadNotificationsKey;
extern NSString * const PushNotificationSettingsKey;
extern NSString * const NTOUModulesSavedStateKey;
extern NSString * const CachedMapSearchQueryKey;
extern NSString * const LibrariesLinksUpdatedKey;
extern NSString * const LibrariesLinksKey;

extern NSString * const NTOUInternalURLScheme;

// module tags
extern NSString * const CalendarTag;
extern NSString * const EmergencyTag;
extern NSString * const CampusMapTag;
extern NSString * const NewsOfficeTag;
extern NSString * const DirectoryTag;
extern NSString * const StellarTag;
extern NSString * const ShuttleTag;
extern NSString * const ToursTag;
extern NSString * const AnniversaryTag;
extern NSString * const MobileWebTag;
extern NSString * const SettingsTag;
extern NSString * const AboutTag;
extern NSString * const LinksTag;
extern NSString * const QRReaderTag;
extern NSString * const FacilitiesTag;
extern NSString * const LibrariesTag;

// notification names
extern NSString * const EmergencyInfoDidLoadNotification;
extern NSString * const EmergencyInfoDidFailToLoadNotification;
extern NSString * const EmergencyInfoDidChangeNotification;
extern NSString * const EmergencyContactsDidLoadNotification;

extern NSString * const ShuttleAlertRemoved;

extern NSString * const UnreadBadgeValuesChangeNotification;

extern NSString * const MyStellarAlertNotification;

// core data entity names
extern NSString * const NewsStoryEntityName;
extern NSString * const NewsCategoryEntityName;
extern NSString * const NewsImageEntityName;
extern NSString * const NewsImageRepEntityName;
extern NSString * const PersonDetailsEntityName;
extern NSString * const StellarCourseEntityName;
extern NSString * const StellarClassEntityName;
extern NSString * const StellarClassTimeEntityName;
extern NSString * const StellarStaffMemberEntityName;
extern NSString * const StellarAnnouncementEntityName;
extern NSString * const EmergencyInfoEntityName;
extern NSString * const EmergencyContactEntityName;
extern NSString * const ShuttleRouteEntityName;
extern NSString * const ShuttleStopEntityName;
extern NSString * const ShuttleRouteStopEntityName;
extern NSString * const CalendarEventEntityName;
extern NSString * const CalendarCategoryEntityName;
extern NSString * const CampusMapSearchEntityName;
extern NSString * const CampusTourEntityName;
extern NSString * const TourSiteOrRouteEntityName;
extern NSString * const CampusTourSideTripEntityName;
extern NSString * const TourStartLocationEntityName;
extern NSString * const QRReaderResultEntityName;

// resource names
extern NSString * const NTOUImageNameBackground;
extern NSString * const NTOUImageNameEmail;
extern NSString * const NTOUImageNameEmailHighlight;
extern NSString * const NTOUImageNameMap;
extern NSString * const NTOUImageNameMapHighlight;
extern NSString * const NTOUImageNamePeople;
extern NSString * const NTOUImageNamePeopleHighlight;
extern NSString * const NTOUImageNamePhone;
extern NSString * const NTOUImageNamePhoneHighlight;
extern NSString * const NTOUImageNameExternal;
extern NSString * const NTOUImageNameExternalHighlight;
extern NSString * const NTOUImageNameEmergency;
extern NSString * const NTOUImageNameEmergencyHighlight;
extern NSString * const NTOUImageNameSecure;
extern NSString * const NTOUImageNameSecureHighlight;
extern NSString * const NTOUImageNameCalendar;
extern NSString * const NTOUImageNameCalendarHighlight;

extern NSString * const NTOUImageNameScrollTabBackgroundOpaque;
extern NSString * const NTOUImageNameScrollTabBackgroundTranslucent;
extern NSString * const NTOUImageNameScrollTabLeftEndCap;
extern NSString * const NTOUImageNameScrollTabRightEndCap;
extern NSString * const NTOUImageNameScrollTabSelectedTab;

extern NSString * const NTOUImageNameLeftArrow;
extern NSString * const NTOUImageNameRightArrow;
extern NSString * const NTOUImageNameUpArrow;
extern NSString * const NTOUImageNameDownArrow;

extern NSString * const NTOUImageNameSearch;
extern NSString * const NTOUImageNameBookmark;

// action accessory types
typedef enum {
    NTOUAccessoryViewEmail,
    NTOUAccessoryViewMap,
    NTOUAccessoryViewPeople,
    NTOUAccessoryViewPhone,
    NTOUAccessoryViewExternal,
	NTOUAccessoryViewEmergency,
    NTOUAccessoryViewSecure,
    NTOUAccessoryViewCalendar
} NTOUAccessoryViewType;

// Info.plist additions
extern NSString * const NTOUBuildRevisionKey;
extern NSString * const NTOUBuildDescriptionKey;


// Touchstone* Identifier for keychain password
extern NSString * const MobileWebErrorDomain;
extern NSString * const MobileWebTouchstoneErrorDomain;

enum {
    MobileWebUnknownError = 0,
    MobileWebTouchstoneError,
    MobileWebInvalidLoginError
};

extern NSString * const MobileLoginKeychainIdentifier;


