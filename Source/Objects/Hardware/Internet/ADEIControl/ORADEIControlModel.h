//--------------------------------------------------------
// ORADEIControlModel
// Created by A. Kopmann on Feb 8, 2019
// Copyright (c) 2019, University of North Carolina. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of
//North Carolina sponsored in part by the United States
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020.
//The University has certain rights in the program pursuant to
//the contract and the program should not be copied or distributed
//outside your organization.  The DOE and the University of
//North Carolina reserve all rights in the program. Neither the authors,
//University of North Carolina, or U.S. Government make any warranty,
//express or implied, or assume any liability or responsibility
//for the use of this software.
//-------------------------------------------------------------

#pragma mark ***Imported Files
#import "ORAdcProcessing.h"

@class ORTimeRate;
@class ORSafeQueue;
@class NetSocket;

#define kVesselVoltageSetPt            @"kVesselVoltageSetPt"
#define kPostRegulationScaleFactor     @"kPostRegulationScaleFactor"
#define kPowerSupplyOffset             @"kPowerSupplyOffset"

#define kADEIControlRecordSize 9

@interface ORADEIControlModel : OrcaObject <ORAdcProcessing>
{
    @private
        int                 sensorGroup;
        NSString*           sensorGroupName;
        NSString*           ipAddress;
        BOOL                isConnected;
        NetSocket*          socket;
        BOOL                wasConnected;
  
		NSString*			lastRequest;
		ORSafeQueue*		cmdQueue;
		NSMutableString*    buffer;

		NSString*			setPointFile;
        NSMutableArray*     measuredValues;
        NSMutableArray*     setPoints;
        NSMutableArray*     postRegulationArray;
        NSString*           postRegulationFile;
        NSMutableDictionary* shipValueDictionary;

        BOOL                expertPCControlOnly;
        BOOL                zeusHasControl;
        BOOL                orcaHasControl;
        BOOL                verbose;
        NSMutableString*    stringBuffer;
        BOOL                showFormattedDates;
        int                 pollTime;
        uint32_t            dataId;
    
        NSString *          cmdReadSetpoints;
        NSString *          cmdWriteSetpoints;
        NSString *          cmdReadActualValues;
        int                 spOffset;
    
        NSString **         setPointList;
        NSString **         measuredValueList;
        int                 kNumToShip;
        NSString **         itemsToShip;

        int                 localControlIndex;
        int                 zeusControlIndex;
        int                 orcaControlIndex;
}

#pragma mark ***Initialization
- (void) dealloc;
- (NSString*) commonScriptMethods;

#pragma mark ***Accessors
- (int) sensorGroup;
- (void) setSensorGroup:(int)group;
- (NSString*) sensorGroupName;
- (int)  pollTime;
- (void) setPollTime:(int)aPollTime;
- (id) setPointItem:(int)i forKey:(NSString*)aKey;
- (id) measuredValueItem:(int)i forKey:(NSString*)aKey;
- (void) setSetPoint: (int)aIndex withValue: (double)value;
- (void) setSetPointReadback: (int)aIndex withValue: (double)value;
- (id) setPointAtIndex:(int)i;
- (id) setPointReadBackAtIndex:(int)i;
- (id) measuredValueAtIndex:(int)i;
- (void) setMeasuredValue: (int)aIndex withValue: (double)value;

- (int) getIndexOfSetPoint:(NSString *) aUID;
- (int) getIndexOfMeasuredValue:(NSString *) aUID;
- (void) setSetPointWithUID: (NSString *)aUID withValue: (double)value;
- (void) setSetPointReadbackWithUID: (NSString *)aUID withValue: (double)value;
- (id) setPointWithUID:(NSString *)aUID;
- (id) setPointReadBackWithUID:(NSString *)aUID;
- (id) measuredValueWithUID:(NSString *)aUID;

- (NetSocket*) socket;
- (void) setSocket:(NetSocket*)aSocket;
- (NSString*) ipAddress;
- (void) setIpAddress:(NSString*)aIpAddress;
- (BOOL) isConnected;
- (void) setIsConnected:(BOOL)aFlag;
- (void) writeCmdString:(NSString*)aCommand;
- (void) parseString:(NSString*)theString;
- (void) connect;
- (void) setVerbose:(BOOL)aState;
- (BOOL) verbose;
- (void) setShowFormattedDates:(BOOL)aState;
- (BOOL) showFormattedDates;
- (void) shipRecords;
- (void) checkShipValueDictionary;

- (NSString*) title;

- (NSString*) setPointFile;
- (void) setSetPointFile:(NSString*)aPath;
- (NSString*) lastRequest;
- (void) setLastRequest:(NSString*)aRequest;
- (NSUInteger) queCount;
- (BOOL) isBusy;
- (void) flushQueue;
- (void) createSetPointArray;
- (NSInteger) numSetPoints;
- (void) createMeasuredValueArray;
- (NSUInteger) numMeasuredValues;
- (BOOL) expertPCControlOnly ;
- (BOOL) zeusHasControl;
- (BOOL) orcaHasControl;

- (NSString*) postRegulationFile;
- (void) setPostRegulationFile:(NSString*)aPath;
- (void) addPostRegulationPoint;
- (void) removePostRegulationPointAtIndex:(int)anIndex;
- (void) removeAllPostRegulationPoints;
- (void) setPostRegulationArray:(NSMutableArray*)anArray;
- (uint32_t) numPostRegulationPoints;
- (id) postRegulationPointAtIndex:(int)anIndex;
- (NSString*)measuredValueName:(NSUInteger)anIndex;

#pragma mark ***Commands
- (void) writeSetpoints;
- (void) readBackSetpoints;
- (void) readMeasuredValues;

- (id)   initWithCoder:(NSCoder*)decoder;
- (void) encodeWithCoder:(NSCoder*)encoder;
- (void) readPostRegulationFile:(NSString*) aPath;
- (void) savePostRegulationFile:(NSString*) aPath;
- (void) readSetPointsFile:(NSString*) aPath;
- (void) saveSetPointsFile:(NSString*) aPath;
- (void) pushReadBacksToSetPoints;

#pragma mark •••Scripting Convenience Methods
- (double) vesselVoltageSetPoint:(int)anIndex;
- (double) postRegulationScaleFactor:(int)anIndex;
- (double) powerSupplyOffset:(int)anIndex;
- (void)   setPostRegulationScaleFactor:(int)anIndex withValue:(double)aValue;
- (void)   setPowerSupplyOffset:(int)anIndex withValue:(double)aValue;
- (void)   setVesselVoltageSetPoint:(int)anIndex withValue:(double)aValue;

- (uint32_t) dataId;
- (void) setDataId: (uint32_t) DataId;
- (void) setDataIds:(id)assigner;
- (void) syncDataIdsWith:(id)anotherLakeShore210;
- (void) appendDataDescription:(ORDataPacket*)aDataPacket userInfo:(NSDictionary*)userInfo;
- (NSDictionary*) dataRecordDescription;

#pragma mark •••Adc or Bit Processing Protocol
- (void)processIsStarting;
- (void)processIsStopping;
- (void) startProcessCycle;
- (void) endProcessCycle;
- (BOOL) processValue:(int)channel;
- (NSString*) processingTitle;
- (double) convertedValue:(int)channel;
- (double) maxValueForChan:(int)channel;
- (double) minValueForChan:(int)channel;
- (void) getAlarmRangeLow:(double*)theLowLimit high:(double*)theHighLimit  channel:(int)channel;
@end

@interface NSObject (ORHistModel)
- (void) removeFrom:(NSMutableArray*)anArray;
@end

extern NSString* ORADEIControlLock;
extern NSString* ORADEIControlModelSetPointChanged;
extern NSString* ORADEIControlModelQueCountChanged;
extern NSString* ORADEIControlModelReadBackChanged;
extern NSString* ORADEIControlModelSensorGroupChanged;
extern NSString* ORADEIControlModelIsConnectedChanged;
extern NSString* ORADEIControlModelIpAddressChanged;
extern NSString* ORADEIControlModelSetPointsChanged;
extern NSString* ORADEIControlModelMeasuredValuesChanged;
extern NSString* ORADEIControlModelSetPointFileChanged;
extern NSString* ORADEIControlModelVerboseChanged;
extern NSString* ORADEIControlModelShowFormattedDatesChanged;
extern NSString* ORADEIControlModelPostRegulationFileChanged;
extern NSString* ORADEIControlModelPostRegulationPointAdded;
extern NSString* ORADEIControlModelPostRegulationPointRemoved;
extern NSString* ORADEIControlModelUpdatePostRegulationTable;
extern NSString* ORADEIControlModelPollTimeChanged;


@interface ScriptingParameter : NSObject
{
    NSMutableDictionary* data;
}
+ (id) postRegulationPoint;
- (void) setValue:(id)anObject forKey:(id)aKey;
- (id) objectForKey:(id)aKey;
- (id)   initWithCoder:(NSCoder*)decoder;
- (void) encodeWithCoder:(NSCoder*)encoder;


@property   (retain) NSMutableDictionary* data;
@end

