//  Orca
//  ORFlashCamCrateModel.h
//
//  Created by Tom Caldwell on Monday Jan 1, 2020
//  Copyright (c) 2020 University of North Carolina. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of
//North Carolina Department of Physics and Astrophysics
//sponsored in part by the United States
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020.
//The University has certain rights in the program pursuant to
//the contract and the program should not be copied or distributed
//outside your organization.  The DOE and the University of
//North Carolina reserve all rights in the program. Neither the authors,
//University of North Carolina, or U.S. Government make any warranty,
//express or implied, or assume any liability or responsibility
//for the use of this software.
//-------------------------------------------------------------

#import "ORFlashCamCrate.h"

@interface ORFlashCamCrateModel : ORFlashCamCrate {
}

#pragma mark •••Initialization
- (void) setUpImage;
- (void) makeMainController;

@end

@interface ORFlashCamCrateModel (OROrderedObjHolding)
- (int) maxNumberOfObjects;
@end
