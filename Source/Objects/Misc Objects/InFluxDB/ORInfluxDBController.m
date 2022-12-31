//
//  ORInFluxDBController.m
//  Orca
//
// Created by Mark Howe on 12/7/2022.
//  Copyright 2006 CENPA, University of Washington. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of 
//Washington at the Center for Experimental Nuclear Physics and 
//Astrophysics (CENPA) sponsored in part by the United States 
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020. 
//The University has certain rights in the program pursuant to 
//the contract and the program should not be copied or distributed 
//outside your organization.  The DOE and the University of 
//Washington reserve all rights in the program. Neither the authors,
//University of Washington, or U.S. Government make any warranty, 
//express or implied, or assume any liability or responsibility 
//for the use of this software.
//-------------------------------------------------------------

#import "ORInFluxDBController.h"
#import "ORInFluxDBModel.h"
#import "ORInFluxDBCmd.h"

@implementation ORInFluxDBController

#pragma mark •••Initialization
-(id)init
{
    self = [super initWithWindowNibName:@"InFlux"];
    return self;
}

- (void) dealloc
{
 	[super dealloc];
}

-(void) awakeFromNib
{
	[super awakeFromNib];
}


#pragma mark •••Registration
- (void) registerNotificationObservers
{
    NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    
    [super registerNotificationObservers];
    
    [notifyCenter addObserver : self
                     selector : @selector(hostNameChanged:)
                         name : ORInFluxDBHostNameChanged
                       object : model];
    
    [notifyCenter addObserver : self
                     selector : @selector(portChanged:)
                         name : ORInFluxDBPortNumberChanged
                       object : model];
    
    [notifyCenter addObserver : self
                     selector : @selector(authTokenChanged:)
                         name : ORInFluxDBAuthTokenChanged
                       object : model];
    
    [notifyCenter addObserver : self
                     selector : @selector(orgChanged:)
                         name : ORInFluxDBOrgChanged
                       object : model];
 
    [notifyCenter addObserver : self
                     selector : @selector(bucketNameChanged:)
                         name : ORInFluxDBBucketNameChanged
                       object : model];
    
    [notifyCenter addObserver : self
                     selector : @selector(inFluxDBLockChanged:)
                         name : ORInFluxDBLock
                       object : nil];
	
    [notifyCenter addObserver : self
                     selector : @selector(inFluxDBLockChanged:)
                         name : ORRunStatusChangedNotification
                       object : nil];

    [notifyCenter addObserver : self
                     selector : @selector(rateChanged:)
                         name : ORInFluxDBRateChanged
                       object : model];
    
    [notifyCenter addObserver : self
                     selector : @selector(stealthModeChanged:)
                         name : ORInFluxDBStealthModeChanged
                        object: model];
    
    [notifyCenter addObserver : self
                     selector : @selector(bucketArrayChanged:)
                         name : ORInFluxDBBucketArrayChanged
                        object: model];
}

- (void) updateWindow
{
    [super updateWindow];
    [self hostNameChanged:nil];
    [self portChanged:nil];
    [self authTokenChanged:nil];
    [self orgChanged:nil];
    [self bucketNameChanged:nil];
    [self inFluxDBLockChanged:nil];
    [self rateChanged:nil];
    [self stealthModeChanged:nil];
    [self bucketNameChanged:nil];
    [self bucketArrayChanged:nil];

}
- (void) stealthModeChanged:(NSNotification*)aNote
{
    [stealthModeButton setIntValue: [model stealthMode]];
    [dbStatusField setStringValue:![model stealthMode]?@"":@"Disabled"];
}

- (void) bucketArrayChanged:(NSNotification*)aNote
{
    [bucketTableView setNeedsDisplay:YES];
}

- (void) rateChanged:(NSNotification*)aNote
{
    [rateField setStringValue:[NSString stringWithFormat:@"%ld/s",[model messageRate]]];
}

- (void) hostNameChanged:(NSNotification*)aNote
{
	[hostNameField setStringValue:[model hostName]];
}

- (void) portChanged:(NSNotification*)aNote
{
    [portField setIntegerValue:[model portNumber]];
}

- (void) orgChanged:(NSNotification*)aNote
{
    [orgField setStringValue:[model org]];
}

- (void) bucketNameChanged:(NSNotification*)aNote
{
    [bucketNameField setStringValue:[model bucketName]];
}

- (void) authTokenChanged:(NSNotification*)aNote
{
    [authTokenField setStringValue:[model authToken]];
}

- (void) inFluxDBLockChanged:(NSNotification*)aNote
{
    BOOL locked = [gSecurity isLocked:ORInFluxDBLock];
    [InFluxDBLockButton   setState: locked];
    [hostNameField        setEnabled:!locked];
    [portField            setEnabled:!locked];
    [authTokenField       setEnabled:!locked];
    [orgField             setEnabled:!locked];
    [bucketNameField      setEnabled:!locked];
    [stealthModeButton    setEnabled:!locked];
}

- (void) checkGlobalSecurity
{
    BOOL secure = [gSecurity globalSecurityEnabled];
    [gSecurity setLock:ORInFluxDBLock to:secure];
    [InFluxDBLockButton setEnabled: secure];
}


#pragma mark •••Actions
- (IBAction) stealthModeAction:(id)sender
{
    if(![model stealthMode]){
        NSString* s = [NSString stringWithFormat:@"Really disable the database?\n"];
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:s];
        [alert setInformativeText:@"There will be NO values automatically put in to the database if you activate this option."];
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Yes, Disable Database"];
        [alert setAlertStyle:NSAlertStyleWarning];
        
        [alert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse result){
            if(result == NSAlertSecondButtonReturn){
                [model setStealthMode:YES];
            }
            else [model setStealthMode:NO];

        }];
    }
    else [model setStealthMode:NO];
}

- (IBAction) InFluxDBLockAction:(id)sender
{
    [gSecurity tryToSetLock:ORInFluxDBLock to:[sender intValue] forWindow:[self window]];
}

- (IBAction) hostNameAction:(id)sender
{
	[model setHostName:[sender stringValue]];
}

- (IBAction) authTokenAction:(id)sender
{
    [model setAuthToken:[sender stringValue]];
}

- (IBAction) orgAction:(id)sender
{
    [model setOrg:[sender stringValue]];
}

- (IBAction) bucketNameAction:(id)sender
{
    [model setBucketName:[sender stringValue]];
}

- (IBAction) listBucketsAction:(id)sender
{
    [model executeDBCmd:kInFluxDBListBuckets];
}

- (IBAction) listOrgsAction:(id)sender;
{
    [model executeDBCmd:kInFluxDBListOrgs];
}

- (IBAction) deleteBucketsAction:(id)sender
{
    [model executeDBCmd:kInFluxDBDeleteBucket];
}

- (IBAction) createBucketsAction:(id)sender
{
    [model executeDBCmd:kInFluxDBCreateBuckets];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [[model bucketArray] count];
}

- (id) tableView:(NSTableView*) aTableView objectValueForTableColumn:(NSTableColumn *) aTableColumn row:(NSInteger) rowIndex
{
    NSArray* anArray = [model bucketArray];
    if(anArray){
        return [[anArray objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
    }
    return @"";
}
@end
