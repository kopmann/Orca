//--------------------------------------------------------
// ORADEIControlModel
// Created by A. Kopmann on Feb 8, 2019
// Copyright (c) 2017, University of North Carolina. All rights reserved.
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
#import "ORADEIControlModel.h"
#import "ORSafeQueue.h"
#import "NetSocket.h"
#import "ORDataTypeAssigner.h"
#import "ORDataPacket.h"

#pragma mark ***External Strings
NSString* ORADEIControlModelIsConnectedChanged           = @"ORADEIControlModelIsConnectedChanged";
NSString* ORADEIControlModelIpAddressChanged             = @"ORADEIControlModelIpAddressChanged";
NSString* ORADEIControlModelSetPointChanged              = @"ORADEIControlModelSetPointChanged";
NSString* ORADEIControlModelReadBackChanged              = @"ORADEIControlModelReadBackChanged";
NSString* ORADEIControlModelQueCountChanged              = @"ORADEIControlModelQueCountChanged";
NSString* ORADEIControlModelSetPointsChanged             = @"ORADEIControlModelSetPointsChanged";
NSString* ORADEIControlModelMeasuredValuesChanged        = @"ORADEIControlModelMeasuredValuesChanged";
NSString* ORADEIControlModelSetPointFileChanged          = @"ORADEIControlModelSetPointFileChanged";
NSString* ORADEIControlModelPostRegulationFileChanged    = @"ORADEIControlModelPostRegulationFileChanged";
NSString* ORADEIControlModelVerboseChanged               = @"ORADEIControlModelVerboseChanged";
NSString* ORADEIControlModelShowFormattedDatesChanged    = @"ORADEIControlModelShowFormattedDatesChanged";
NSString* ORADEIControlModelDesiredSetPointAdded         = @"ORADEIControlModelDesiredSetPointAdded";
NSString* ORADEIControlModelDesiredSetPointRemoved       = @"ORADEIControlModelDesiredSetPointRemoved";
NSString* ORADEIControlModelUpdatePostRegulationTable    = @"ORADEIControlModelUpdatePostRegulationTable";
NSString* ORADEIControlModelPollTimeChanged              = @"ORADEIControlModelPollTimeChanged";

NSString* ORADEIControlLock						        = @"ORADEIControlLock";


//new lists from 10/17/2017   -mah-
static NSString* setPointList[] = {
    @"Zeitstempel",    @"-",
    @"Zeitstempel",    @"-",
    @"SOLL_PXI_MODUL#WestModul0",    @"Rampe",
    @"SOLL_PXI_MODUL#WestModul1",    @"Rampe",
    @"SOLL_PXI_MODUL#WestModul2",    @"Rampe",
    @"", @""
};
    
/*
    @"SOLL_PXI_MODUL#EastModul0",    @"Rampe",
    @"SOLL_PXI_MODUL#EastModul1",    @"Rampe",
    @"SOLL_PXI_MODUL#EastModul2",    @"Rampe",
    @"SOLL_PXI_CHANNEL#WestCh0",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh0",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh0",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh1",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh1",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh1",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh2",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh2",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh2",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh3",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh3",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh3",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh4",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh4",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh4",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh5",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh5",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh5",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh6",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh6",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh6",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh7",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh7",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh7",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh8",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh8",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh8",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh9",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh9",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh9",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh10",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh10",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh10",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh11",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh11",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh11",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh12",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh12",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh12",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh13",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh13",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh13",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh14",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh14",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh14",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh15",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh15",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh15",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh16",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh16",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh16",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh17",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh17",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh17",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh18",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh18",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh18",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh19",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh19",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh19",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh20",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh20",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh20",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh21",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh21",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh21",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh22",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh22",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh22",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#WestCh23",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#WestCh23",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#WestCh23",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh0",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh0",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh0",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh1",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh1",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh1",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh2",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh2",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh2",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh3",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh3",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh3",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh4",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh4",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh4",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh5",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh5",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh5",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh6",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh6",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh6",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh7",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh7",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh7",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh8",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh8",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh8",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh9",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh9",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh9",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh10",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh10",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh10",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh11",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh11",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh11",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh12",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh12",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh12",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh13",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh13",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh13",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh14",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh14",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh14",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh15",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh15",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh15",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh16",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh16",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh16",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh17",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh17",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh17",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh18",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh18",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh18",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh19",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh19",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh19",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh20",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh20",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh20",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh21",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh21",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh21",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh22",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh22",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh22",    @"U_EXAKT",
    @"SOLL_PXI_CHANNEL#EastCh23",    @"U_SOLL",
    @"SOLL_PXI_CHANNEL#EastCh23",    @"I_MAX",
    @"SOLL_PXI_CHANNEL#EastCh23",    @"U_EXAKT",
    @"SOLL_EHV#mainSpecVesel",    @"U_Soll",
    @"SOLL_EHV#mainSpecVesel",    @"I_MAX",
    @"SOLL_EHV#mainSpecVesel",    @"Rampe",
    @"SOLL_EHV#mainSpecElektrode",    @"U_Soll",
    @"SOLL_EHV#mainSpecElektrode",    @"I_MAX",
    @"SOLL_EHV#mainSpecElektrode",    @"Rampe",
    @"SOLL_EHV#mainSpecCorrSouth",    @"U_Soll",
    @"SOLL_EHV#mainSpecCorrSouth",    @"I_MAX",
    @"SOLL_EHV#mainSpecCorrSouth",    @"Rampe",
    @"SOLL_EHV#mainSpecCorrWest",    @"U_Soll",
    @"SOLL_EHV#mainSpecCorrWest",    @"I_MAX",
    @"SOLL_EHV#mainSpecCorrWest",    @"Rampe",
    @"SOLL_EHV#mainSpecDipolWest",    @"U_Soll",
    @"SOLL_EHV#mainSpecDipolWest",    @"I_MAX",
    @"SOLL_EHV#mainSpecDipolWest",    @"Rampe",
    @"SOLL_EHV#mainSpecDipolEast",    @"U_Soll",
    @"SOLL_EHV#mainSpecDipolEast",    @"I_MAX",
    @"SOLL_EHV#mainSpecDipolEast",    @"Rampe",
    @"SOLL_EHV#IECommon",    @"U_Soll",
    @"SOLL_EHV#IECommon",    @"I_MAX",
    @"SOLL_EHV#IECommon",    @"Rampe",
    @"SOLL_EHV#preSpecVesel",    @"U_Soll",
    @"SOLL_EHV#preSpecVesel",    @"I_MAX",
    @"SOLL_EHV#preSpecVesel",    @"Rampe",
    @"SOLL_EHV#preSpecIE1",    @"U_Soll",
    @"SOLL_EHV#preSpecIE1",    @"I_MAX",
    @"SOLL_EHV#preSpecIE1",    @"Rampe",
    @"SOLL_EHV#preSpecIE2",    @"U_Soll",
    @"SOLL_EHV#preSpecIE2",    @"I_MAX",
    @"SOLL_EHV#preSpecIE2",    @"Rampe",
    @"SOLL_EHV#preSpecIE3",    @"U_Soll",
    @"SOLL_EHV#preSpecIE3",    @"I_MAX",
    @"SOLL_EHV#preSpecIE3",    @"Rampe",
    @"SOLL_EHV#preSpecIE4",    @"U_Soll",
    @"SOLL_EHV#preSpecIE4",    @"I_MAX",
    @"SOLL_EHV#preSpecIE4",    @"Rampe",
    @"SOLL_STATUS#Ost_Relais",    @"Bed",
    @"SOLL_STATUS#Ost_Relais",    @"Modus",
    @"SOLL_STATUS#Ost_Relais",    @"Time_On",
    @"SOLL_STATUS#Ost_Relais",    @"Time_Off",
    @"SOLL_STATUS#West_Relais",    @"Bed",
    @"SOLL_STATUS#West_Relais",    @"Modus",
    @"SOLL_STATUS#West_Relais",    @"Time_On",
    @"SOLL_STATUS#West_Relais",    @"Time_Off",
    @"SOLL_EHV#postReg",    @"U_Soll",
    @"SOLL_EHV#postRegInhibit",    @"Status",
    @"", @""
};

*/

static NSString* measuredValueList[] = {
    @"Zeitstempel",    @"-",
    @"Zeitstempel",    @"-",
    @"IST_PXI_MODUL#WestModul0",    @"Temperatur Board",
    @"IST_PXI_MODUL#WestModul0",    @"24 Spannung",
    @"IST_PXI_MODUL#WestModul0",    @"5V Spannung",
    @"", @""
};

/*
    @"IST_PXI_MODUL#WestModul0",    @"Rampe",
    @"IST_PXI_MODUL#WestModul0",    @"Warnung",
    @"IST_PXI_MODUL#WestModul0",    @"Fehler",
    @"IST_PXI_MODUL#WestModul1",    @"Temperatur Board",
    @"IST_PXI_MODUL#WestModul1",    @"24 Spannung",
    @"IST_PXI_MODUL#WestModul1",    @"5V Spannung",
    @"IST_PXI_MODUL#WestModul1",    @"Rampe",
    @"IST_PXI_MODUL#WestModul1",    @"Warnung",
    @"IST_PXI_MODUL#WestModul1",    @"Fehler",
    @"IST_PXI_MODUL#WestModul2",    @"Temperatur Board",
    @"IST_PXI_MODUL#WestModul2",    @"24 Spannung",
    @"IST_PXI_MODUL#WestModul2",    @"5V Spannung",
    @"IST_PXI_MODUL#WestModul2",    @"Rampe",
    @"IST_PXI_MODUL#WestModul2",    @"Warnung",
    @"IST_PXI_MODUL#WestModul2",    @"Fehler",
    @"IST_PXI_MODUL#EastModul0",    @"Temperatur Board",
    @"IST_PXI_MODUL#EastModul0",    @"24 Spannung",
    @"IST_PXI_MODUL#EastModul0",    @"5V Spannung",
    @"IST_PXI_MODUL#EastModul0",    @"Rampe",
    @"IST_PXI_MODUL#EastModul0",    @"Warnung",
    @"IST_PXI_MODUL#EastModul0",    @"Fehler",
    @"IST_PXI_MODUL#EastModul1",    @"Temperatur Board",
    @"IST_PXI_MODUL#EastModul1",    @"24 Spannung",
    @"IST_PXI_MODUL#EastModul1",    @"5V Spannung",
    @"IST_PXI_MODUL#EastModul1",    @"Rampe",
    @"IST_PXI_MODUL#EastModul1",    @"Warnung",
    @"IST_PXI_MODUL#EastModul1",    @"Fehler",
    @"IST_PXI_MODUL#EastModul2",    @"Temperatur Board",
    @"IST_PXI_MODUL#EastModul2",    @"24 Spannung",
    @"IST_PXI_MODUL#EastModul2",    @"5V Spannung",
    @"IST_PXI_MODUL#EastModul2",    @"Rampe",
    @"IST_PXI_MODUL#EastModul2",    @"Warnung",
    @"IST_PXI_MODUL#EastModul2",    @"Fehler",
    @"IST_EHV#mainSpecVessel",    @"U_SOLL",
    @"IST_EHV#mainSpecVessel",    @"U_IST",
    @"IST_EHV#mainSpecVessel",    @"I_MAX",
    @"IST_EHV#mainSpecVessel",    @"I_IST",
    @"IST_EHV#mainSpecVessel",    @"Rampe",
    @"IST_EHV#mainSpecVessel",    @"I_Begrenzt",
    @"IST_EHV#mainSpecVessel",    @"Warnung",
    @"IST_EHV#mainSpecVessel",    @"Fehler",
    @"IST_EHV#mainSpecElektrode",    @"U_SOLL",
    @"IST_EHV#mainSpecElektrode",    @"U_IST",
    @"IST_EHV#mainSpecElektrode",    @"I_MAX",
    @"IST_EHV#mainSpecElektrode",    @"I_IST",
    @"IST_EHV#mainSpecElektrode",    @"Rampe",
    @"IST_EHV#mainSpecElektrode",    @"I_Begrenzt",
    @"IST_EHV#mainSpecElektrode",    @"Warnung",
    @"IST_EHV#mainSpecElektrode",    @"Fehler",
    @"IST_EHV#mainSpecCorrSouth",    @"U_SOLL",
    @"IST_EHV#mainSpecCorrSouth",    @"U_IST",
    @"IST_EHV#mainSpecCorrSouth",    @"I_MAX",
    @"IST_EHV#mainSpecCorrSouth",    @"I_IST",
    @"IST_EHV#mainSpecCorrSouth",    @"Rampe",
    @"IST_EHV#mainSpecCorrSouth",    @"I_Begrenzt",
    @"IST_EHV#mainSpecCorrSouth",    @"Warnung",
    @"IST_EHV#mainSpecCorrSouth",    @"Fehler",
    @"IST_EHV#mainSpecCorrNorth",    @"U_SOLL",
    @"IST_EHV#mainSpecCorrNorth",    @"U_IST",
    @"IST_EHV#mainSpecCorrNorth",    @"I_MAX",
    @"IST_EHV#mainSpecCorrNorth",    @"I_IST",
    @"IST_EHV#mainSpecCorrNorth",    @"Rampe",
    @"IST_EHV#mainSpecCorrNorth",    @"I_Begrenzt",
    @"IST_EHV#mainSpecCorrNorth",    @"Warnung",
    @"IST_EHV#mainSpecCorrNorth",    @"Fehler",
    @"IST_EHV#mainSpecDipolWest",    @"U_SOLL",
    @"IST_EHV#mainSpecDipolWest",    @"U_IST",
    @"IST_EHV#mainSpecDipolWest",    @"I_MAX",
    @"IST_EHV#mainSpecDipolWest",    @"I_IST",
    @"IST_EHV#mainSpecDipolWest",    @"Rampe",
    @"IST_EHV#mainSpecDipolWest",    @"I_Begrenzt",
    @"IST_EHV#mainSpecDipolWest",    @"Warnung",
    @"IST_EHV#mainSpecDipolWest",    @"Fehler",
    @"IST_EHV#mainSpecDipolEast",    @"U_SOLL",
    @"IST_EHV#mainSpecDipolEast",    @"U_IST",
    @"IST_EHV#mainSpecDipolEast",    @"I_MAX",
    @"IST_EHV#mainSpecDipolEast",    @"I_IST",
    @"IST_EHV#mainSpecDipolEast",    @"Rampe",
    @"IST_EHV#mainSpecDipolEast",    @"I_Begrenzt",
    @"IST_EHV#mainSpecDipolEast",    @"Warnung",
    @"IST_EHV#mainSpecDipolEast",    @"Fehler",
    @"IST_EHV#IECommon",    @"U_SOLL",
    @"IST_EHV#IECommon",    @"U_IST",
    @"IST_EHV#IECommon",    @"I_MAX",
    @"IST_EHV#IECommon",    @"I_IST",
    @"IST_EHV#IECommon",    @"Rampe",
    @"IST_EHV#IECommon",    @"I_Begrenzt",
    @"IST_EHV#IECommon",    @"Warnung",
    @"IST_EHV#IECommon",    @"Fehler",
    @"IST_EHV#preSpecVesel",    @"U_SOLL",
    @"IST_EHV#preSpecVesel",    @"U_IST",
    @"IST_EHV#preSpecVesel",    @"I_MAX",
    @"IST_EHV#preSpecVesel",    @"I_IST",
    @"IST_EHV#preSpecVesel",    @"Rampe",
    @"IST_EHV#preSpecVesel",    @"I_Begrenzt",
    @"IST_EHV#preSpecVesel",    @"Warnung",
    @"IST_EHV#preSpecVesel",    @"Fehler",
    @"IST_EHV#preSpecIE1",    @"U_SOLL",
    @"IST_EHV#preSpecIE1",    @"U_IST",
    @"IST_EHV#preSpecIE1",    @"I_MAX",
    @"IST_EHV#preSpecIE1",    @"I_IST",
    @"IST_EHV#preSpecIE1",    @"Rampe",
    @"IST_EHV#preSpecIE1",    @"I_Begrenzt",
    @"IST_EHV#preSpecIE1",    @"Warnung",
    @"IST_EHV#preSpecIE1",    @"Fehler",
    @"IST_EHV#preSpecIE2",    @"U_SOLL",
    @"IST_EHV#preSpecIE2",    @"U_IST",
    @"IST_EHV#preSpecIE2",    @"I_MAX",
    @"IST_EHV#preSpecIE2",    @"I_IST",
    @"IST_EHV#preSpecIE2",    @"Rampe",
    @"IST_EHV#preSpecIE2",    @"I_Begrenzt",
    @"IST_EHV#preSpecIE2",    @"Warnung",
    @"IST_EHV#preSpecIE2",    @"Fehler",
    @"IST_EHV#preSpecIE3",    @"U_SOLL",
    @"IST_EHV#preSpecIE3",    @"U_IST",
    @"IST_EHV#preSpecIE3",    @"I_MAX",
    @"IST_EHV#preSpecIE3",    @"I_IST",
    @"IST_EHV#preSpecIE3",    @"Rampe",
    @"IST_EHV#preSpecIE3",    @"I_Begrenzt",
    @"IST_EHV#preSpecIE3",    @"Warnung",
    @"IST_EHV#preSpecIE3",    @"Fehler",
    @"IST_EHV#preSpecIE4",    @"U_SOLL",
    @"IST_EHV#preSpecIE4",    @"U_IST",
    @"IST_EHV#preSpecIE4",    @"I_MAX",
    @"IST_EHV#preSpecIE4",    @"I_IST",
    @"IST_EHV#preSpecIE4",    @"Rampe",
    @"IST_EHV#preSpecIE4",    @"I_Begrenzt",
    @"IST_EHV#preSpecIE4",    @"Warnung",
    @"IST_EHV#preSpecIE4",    @"Fehler",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Temperatur_1",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Temperatur_2",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Luftfeuchte",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Spannung",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Warnung",
    @"IST_cFP_STATUS#cFP35KVStatus",    @"Fehler",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Temperatur_1",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Temperatur_2",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Luftfeuchte",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Spannung",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Warnung",
    @"IST_cFP_STATUS#cFP65KVStatus",    @"Fehler",
    @"IST_cRIO_STATUS#ExpPC_SollSet",    @"Zustand",
    @"IST_cRIO_STATUS#ZEUS_SollSet",    @"Zustand",
    @"IST_cRIO_STATUS#ORCA_SollSet",    @"Zustand",
    @"IST_cRIO_STATUS#416Status_OK",    @"Zustand",
    @"IST_cRIO_STATUS#416HV_Freigabe",    @"Zustand",
    @"IST_cRIO_STATUS#416HV_aktiv",    @"Zustand",
    @"IST_cRIO_STATUS#436Status_OK",    @"Zustand",
    @"IST_cRIO_STATUS#436HV_Freigabe",    @"Zustand",
    @"IST_cRIO_STATUS#436HV_aktiv",    @"Zustand",
    @"IST_cRIO_STATUS#436VAO_AUF",    @"Zustand",
    @"IST_cRIO_STATUS#436HV_gekoppelt",    @"Zustand",
    @"IST_HV_RELAIS#Ost_Relais",    @"Zustand",
    @"IST_HV_RELAIS#West_Relais",    @"Zustand",
    @"IST_PXI_VOLTAGE#WestCh0",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh0",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh0",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh1",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh1",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh1",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh2",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh2",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh2",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh3",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh3",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh3",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh4",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh4",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh4",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh5",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh5",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh5",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh6",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh6",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh6",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh7",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh7",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh7",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh8",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh8",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh8",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh9",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh9",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh9",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh10",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh10",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh10",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh11",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh11",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh11",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh12",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh12",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh12",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh13",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh13",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh13",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh14",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh14",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh14",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh15",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh15",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh15",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh16",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh16",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh16",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh17",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh17",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh17",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh18",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh18",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh18",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh19",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh19",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh19",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh20",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh20",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh20",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh21",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh21",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh21",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh22",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh22",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh22",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#WestCh23",    @"U_IST",
    @"IST_PXI_VOLTAGE#WestCh23",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#WestCh23",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh0",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh0",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh0",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh1",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh1",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh1",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh2",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh2",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh2",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh3",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh3",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh3",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh4",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh4",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh4",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh5",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh5",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh5",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh6",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh6",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh6",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh7",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh7",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh7",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh8",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh8",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh8",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh9",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh9",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh9",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh10",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh10",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh10",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh11",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh11",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh11",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh12",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh12",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh12",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh13",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh13",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh13",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh14",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh14",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh14",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh15",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh15",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh15",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh16",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh16",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh16",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh17",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh17",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh17",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh18",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh18",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh18",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh19",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh19",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh19",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh20",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh20",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh20",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh21",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh21",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh21",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh22",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh22",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh22",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#EastCh23",    @"U_IST",
    @"IST_PXI_VOLTAGE#EastCh23",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#EastCh23",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#35KV_U",    @"U_IST",
    @"IST_PXI_VOLTAGE#35KV_U",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#35KV_U",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#65KV_U",    @"U_IST",
    @"IST_PXI_VOLTAGE#65KV_U",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#65KV_U",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#KAL_U1",    @"U_IST",
    @"IST_PXI_VOLTAGE#KAL_U1",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#KAL_U1",    @"Messung lauft",
    @"IST_PXI_VOLTAGE#KAL_U2",    @"U_IST",
    @"IST_PXI_VOLTAGE#KAL_U2",    @"Zeitstempel",
    @"IST_PXI_VOLTAGE#KAL_U2",    @"Messung lauft",
    @"IST_PXI_CHANNEL#WestCh0",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh0",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh0",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh0",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh0",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh0",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh0",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh1",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh1",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh1",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh1",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh1",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh1",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh1",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh2",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh2",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh2",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh2",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh2",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh2",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh2",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh3",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh3",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh3",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh3",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh3",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh3",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh3",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh4",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh4",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh4",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh4",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh4",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh4",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh4",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh5",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh5",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh5",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh5",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh5",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh5",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh5",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh6",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh6",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh6",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh6",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh6",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh6",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh6",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh7",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh7",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh7",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh7",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh7",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh7",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh7",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh8",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh8",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh8",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh8",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh8",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh8",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh8",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh9",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh9",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh9",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh9",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh9",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh9",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh9",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh10",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh10",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh10",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh10",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh10",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh10",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh10",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh11",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh11",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh11",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh11",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh11",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh11",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh11",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh12",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh12",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh12",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh12",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh12",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh12",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh12",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh13",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh13",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh13",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh13",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh13",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh13",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh13",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh14",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh14",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh14",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh14",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh14",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh14",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh14",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh15",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh15",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh15",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh15",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh15",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh15",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh15",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh16",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh16",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh16",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh16",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh16",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh16",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh16",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh17",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh17",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh17",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh17",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh17",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh17",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh17",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh18",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh18",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh18",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh18",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh18",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh18",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh18",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh19",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh19",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh19",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh19",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh19",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh19",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh19",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh20",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh20",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh20",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh20",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh20",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh20",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh20",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh21",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh21",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh21",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh21",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh21",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh21",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh21",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh22",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh22",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh22",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh22",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh22",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh22",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh22",    @"Fehler",
    @"IST_PXI_CHANNEL#WestCh23",    @"U_Soll",
    @"IST_PXI_CHANNEL#WestCh23",    @"U_IST",
    @"IST_PXI_CHANNEL#WestCh23",    @"I_MAX",
    @"IST_PXI_CHANNEL#WestCh23",    @"I_IST",
    @"IST_PXI_CHANNEL#WestCh23",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#WestCh23",    @"Warnung",
    @"IST_PXI_CHANNEL#WestCh23",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh0",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh0",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh0",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh0",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh0",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh0",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh0",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh1",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh1",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh1",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh1",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh1",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh1",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh1",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh2",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh2",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh2",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh2",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh2",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh2",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh2",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh3",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh3",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh3",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh3",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh3",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh3",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh3",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh4",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh4",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh4",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh4",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh4",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh4",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh4",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh5",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh5",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh5",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh5",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh5",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh5",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh5",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh6",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh6",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh6",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh6",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh6",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh6",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh6",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh7",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh7",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh7",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh7",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh7",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh7",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh7",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh8",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh8",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh8",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh8",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh8",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh8",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh8",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh9",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh9",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh9",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh9",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh9",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh9",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh9",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh10",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh10",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh10",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh10",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh10",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh10",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh10",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh11",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh11",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh11",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh11",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh11",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh11",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh11",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh12",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh12",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh12",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh12",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh12",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh12",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh12",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh13",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh13",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh13",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh13",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh13",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh13",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh13",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh14",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh14",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh14",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh14",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh14",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh14",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh14",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh15",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh15",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh15",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh15",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh15",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh15",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh15",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh16",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh16",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh16",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh16",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh16",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh16",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh16",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh17",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh17",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh17",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh17",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh17",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh17",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh17",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh18",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh18",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh18",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh18",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh18",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh18",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh18",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh19",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh19",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh19",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh19",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh19",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh19",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh19",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh20",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh20",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh20",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh20",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh20",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh20",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh20",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh21",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh21",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh21",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh21",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh21",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh21",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh21",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh22",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh22",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh22",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh22",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh22",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh22",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh22",    @"Fehler",
    @"IST_PXI_CHANNEL#EastCh23",    @"U_Soll",
    @"IST_PXI_CHANNEL#EastCh23",    @"U_IST",
    @"IST_PXI_CHANNEL#EastCh23",    @"I_MAX",
    @"IST_PXI_CHANNEL#EastCh23",    @"I_IST",
    @"IST_PXI_CHANNEL#EastCh23",    @"I_BEGRENZT",
    @"IST_PXI_CHANNEL#EastCh23",    @"Warnung",
    @"IST_PXI_CHANNEL#EastCh23",    @"Fehler",
    @"IST_EHV#postReg",    @"U_IST",
    @"IST_EHV#postRegInhibit",    @"Inh_IST",
    @"IST_EHV#postRegStatus",    @"Status",
    @"", @""
};

*/

#define kNumToShip  38
static NSString* itemsToShip[kNumToShip*2] = {
    @"38",  @"436-EHV-0-1001-0001-U_set",
    @"39",  @"436-EHV-0-1001-0002-U_act",
    @"40",  @"436-EHV-0-1001-0003-I_max",
    @"41",  @"436-EHV-0-1001-0004-I_act",
    @"42",  @"436-EHV-0-1001-0005-U_ramp",
    @"43",  @"436-EHV-0-1001-0030-I_limited",
    @"44",  @"436-EHV-0-1001-0031-warning",
    @"45",  @"436-EHV-0-1001-0032-error",
    @"46",  @"436-EHV-0-1002-0001-U_set",
    @"47",  @"436-EHV-0-1002-0002-U_act",
    @"48",  @"436-EHV-0-1002-0003-I_max",
    @"49",  @"436-EHV-0-1002-0004-I_act",
    @"50",  @"436-EHV-0-1002-0005-U_ramp",
    @"51",  @"436-EHV-0-1002-0030-I_limited",
    @"52",  @"436-EHV-0-1002-0031-warning",
    @"53",  @"436-EHV-0-1002-0032-error",
    @"86",  @"436-EHV-0-1003-0001-U_set",
    @"87",  @"436-EHV-0-1003-0002-U_act",
    @"88",  @"436-EHV-0-1003-0003-I_max",
    @"89",  @"436-EHV-0-1003-0004-I_act",
    @"90",  @"436-EHV-0-1003-0005-U_ramp",
    @"91",  @"436-EHV-0-1003-0030-I_limited",
    @"92",  @"436-EHV-0-1003-0031-warning",
    @"93",  @"436-EHV-0-1003-0032-error",
    @"94",  @"416-EHV-0-1001-0001-U_set",
    @"95",  @"416-EHV-0-1001-0002-U_act",
    @"96",  @"416-EHV-0-1001-0003-I_max",
    @"97",  @"416-EHV-0-1001-0004-I_act",
    @"98",  @"416-EHV-0-1001-0005-U_ramp",
    @"99",  @"416-EHV-0-1001-0030-I_limited",
    @"100", @"416-EHV-0-1001-0031-warning",
    @"101", @"416-EHV-0-1001-0032-error",
    @"303", @"436-REU-0-0201-0001-U_act",
    @"304", @"436-REU-0-0201-0020-trigger_time",
    @"305", @"436-REU-0-0201-0030-meas_flag",
    @"306", @"436-REU-0-0301-0001-U_act",
    @"307", @"436-REU-0-0301-0020-trigger_time",
    @"308", @"436-REU-0-0301-0030-meas_flag",
};

@interface ORADEIControlModel (private)
- (void) timeout;
- (void) processNextCommandFromQueue;
- (void) pollMeasuredValues;
@end

#define kADEIControlValue -999
#define kADEIControlPort 12340

@implementation ORADEIControlModel

- (void) dealloc
{
    [setPointFile release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [buffer release];
	[cmdQueue release];
	[lastRequest release];
    [setPoints release];
    [postRegulationArray release];
    [measuredValues release];
    if([self isConnected]){
        [socket close];
        [socket setDelegate:nil];
        [socket release];
    }
    [shipValueDictionary release];
    [ipAddress release];
	
	[super dealloc];
}
- (void) wakeUp
{
    if(pollTime){
        [self performSelector:@selector(pollMeasuredValues) withObject:nil afterDelay:2];
    }
    [super wakeUp];
}

- (void) sleep
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super sleep];
}
- (void) setUpImage
{
	[self setImage:[NSImage imageNamed:@"ADEIControl.png"]];
}

- (void) makeMainController
{
	[self linkToController:@"ORADEIControlController"];
}

#pragma mark ***Accessors
- (void) setSetPoint: (int)aIndex withValue: (double)value
{
    NSNumber* oldValue = [[setPoints objectAtIndex:aIndex] objectForKey:@"setPoint"];
    [[[self undoManager] prepareWithInvocationTarget:self] setSetPoint:aIndex withValue:[oldValue floatValue]];
    [[setPoints objectAtIndex:aIndex] setObject:[NSString stringWithFormat:@"%.6f",value] forKey:@"setPoint"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointChanged object:self];
}

- (void) setSetPointReadback: (int)aIndex withValue: (double)value
{
    [[setPoints objectAtIndex:aIndex] setObject:[NSString stringWithFormat:@"%.6f",value] forKey:@"readBack"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointChanged object:self];
}

- (void) setMeasuredValue: (int)aIndex withValue: (double)value
{
    [[measuredValues objectAtIndex:aIndex] setObject:[NSString stringWithFormat:@"%lf",value] forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointChanged object:self];
    
}

- (void) createSetPointArray
{
    if(setPoints)[setPoints release];
    setPoints = [[NSMutableArray array] retain];
    int index = 0;
    for(;;) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:setPointList[index++]   forKey:@"item"];
        [dict setObject:setPointList[index++]   forKey:@"data"];
        [dict setObject:@"0"   forKey:@"setPoint"];
        [dict setObject:@"?" forKey:@"readBack"];
        [setPoints addObject:dict];
        if([setPointList[index] isEqualToString:@""])break;
    }
}


- (NSInteger) numSetPoints
{
    return [setPoints count];
}
- (void) createMeasuredValueArray
{
    if(measuredValues)[measuredValues release];
    measuredValues = [[NSMutableArray array] retain];
    int index = 0;
    for(;;) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:measuredValueList[index++]   forKey:@"item"];
        [dict setObject:measuredValueList[index++]   forKey:@"data"];
        [dict setObject:@"?" forKey:@"value"];
        [measuredValues addObject:dict];
        if([measuredValueList[index] isEqualToString:@""])break;
    }
}

- (NSString*) measuredValueName:(NSUInteger)anIndex
{
    [self checkShipValueDictionary];
    NSString* aKey = [NSString stringWithFormat:@"%d",(int)anIndex];
    NSString* aName = [shipValueDictionary objectForKey:aKey];
    if(aName){
        return aName;
    }
    else if(anIndex < [measuredValues count]){
        NSString* part1 = [[measuredValues objectAtIndex:anIndex] objectForKey:@"item"];
        NSString* part2 = [[measuredValues objectAtIndex:anIndex] objectForKey:@"data"];
        return [part1 stringByAppendingFormat:@" %@",part2];
    }
    return [NSString stringWithFormat:@"Index %d",(int)anIndex];
}

- (NSUInteger) numMeasuredValues
{
    return [measuredValues count];
}

- (void) setSetPoints:(NSMutableArray*)anArray
{
    [anArray retain];
    [setPoints release];
    setPoints = anArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointsChanged object:self];
}

- (void) setMeasuredValues:(NSMutableArray*)anArray
{
    [anArray retain];
    [measuredValues release];
    measuredValues = anArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointsChanged object:self];
}
- (id) setPointAtIndex:(int)i
{
    if(i<[setPoints count]){
        return [[setPoints objectAtIndex:i] objectForKey:@"setPoint"];
    }
    else return nil;
}
- (id) setPointReadBackAtIndex:(int)i
{
    if(i<[setPoints count]){
        return [[setPoints objectAtIndex:i] objectForKey:@"readBack"];
    }
    else return nil;
}
- (id) setPointItem:(int)i forKey:(NSString*)aKey
{
    if(i<[setPoints count]){
        return [[setPoints objectAtIndex:i] objectForKey:aKey];
    }
    else return nil;
}

- (id) measuredValueItem:(int)i forKey:(NSString*)aKey
{
    if(i<[measuredValues count]){
        return [[measuredValues objectAtIndex:i] objectForKey:aKey];
    }
    else return nil;
}

- (id) measuredValueAtIndex:(int)i
{
    if(i<[measuredValues count]){
        return [[measuredValues objectAtIndex:i] objectForKey:@"value"];
    }
    else return nil;
}

- (NSString*) title
{
    return [NSString stringWithFormat:@"%@ (%@)",[self fullID],[self ipAddress]];
}

- (BOOL) wasConnected
{
    return wasConnected;
}

- (void) setWasConnected:(BOOL)aState
{
    wasConnected = aState;
}

- (NetSocket*) socket
{
	return socket;
}
- (void) setSocket:(NetSocket*)aSocket
{
	if(aSocket != socket)[socket close];
	[aSocket retain];
	[socket release];
	socket = aSocket;
    [socket setDelegate:self];
}

- (void) setIsConnected:(BOOL)aFlag
{
    isConnected = aFlag;
    [self setWasConnected:isConnected];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelIsConnectedChanged object:self];
}

- (void) connect
{
	if(!isConnected && [ipAddress length]){
        NSLog(@"%@: trying to connect\n",[self fullID]);
		[self setSocket:[NetSocket netsocketConnectedToHost:ipAddress port:kADEIControlPort]];
        [self setIsConnected:[socket isConnected]];
	}
	else {
        NSLog(@"%@: trying to disconnect\n",[self fullID]);
		[self setSocket:nil];
        [self setIsConnected:[socket isConnected]];
	}
}

- (BOOL) isConnected
{
    return isConnected;
}

- (NSString*) ipAddress
{
    return ipAddress;
}

- (void) setIpAddress:(NSString*)aIpAddress
{
	if(!aIpAddress)aIpAddress = @"";
    [[[self undoManager] prepareWithInvocationTarget:self] setIpAddress:ipAddress];
    
    [ipAddress autorelease];
    ipAddress = [aIpAddress copy];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelIpAddressChanged object:self];
}

- (void) netsocketConnected:(NetSocket*)inNetSocket
{
    if(inNetSocket == socket){
        [self setIsConnected:YES];
        NSLog(@"%@: Connected\n",[self fullID]);
        
        [cmdQueue removeAllObjects];
        [self setLastRequest:nil];
    }
}

- (BOOL) expertPCControlOnly    {return expertPCControlOnly;}
- (BOOL) zeusHasControl         {return zeusHasControl;}
- (BOOL) orcaHasControl         {return orcaHasControl;}

- (void) netsocket:(NetSocket*)inNetSocket dataAvailable:(NSUInteger)inAmount
{
    if(inNetSocket == socket){
		NSString* theString = [[[[NSString alloc] initWithData:[inNetSocket readData] encoding:NSASCIIStringEncoding] autorelease] uppercaseString];
        
        if(verbose){
            NSLog(@"ADEIControl received data:\n");
            NSLog(@"%@\n",theString);
        }

        if(!stringBuffer) stringBuffer = [[NSMutableString stringWithString:theString] retain];
        else [stringBuffer appendString:theString];
        if([stringBuffer rangeOfString:@":done\n" options:NSCaseInsensitiveSearch].location != NSNotFound){
            if(verbose){
                NSLog(@"ADEIControl got end of string delimiter and will now parse the incoming string.\n");
            }
            [stringBuffer replaceOccurrencesOfString:@"+"         withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,1)];//remove leading '+' if there
            [stringBuffer replaceOccurrencesOfString:@"readssps"  withString:@"get gain " options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];
            [stringBuffer replaceOccurrencesOfString:@"readsmvs"  withString:@"get temperatures " options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];
            [stringBuffer replaceOccurrencesOfString:@"writessps" withString:@"set gain " options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];
            [stringBuffer replaceOccurrencesOfString:@"s:done"    withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];
            [stringBuffer replaceOccurrencesOfString:@":done"     withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];       
            [stringBuffer replaceOccurrencesOfString:@"\n"     withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[stringBuffer length])];
            [self parseString:stringBuffer];
            [stringBuffer release];
            stringBuffer = nil;
        }
    }
}

- (void) netsocketDisconnected:(NetSocket*)inNetSocket
{
    if(inNetSocket == socket){
        [self setIsConnected:NO];
        NSLog(@"%@: Disconnected\n",[self fullID]);
		[socket autorelease];
		socket = nil;
        [cmdQueue removeAllObjects];
        [self setLastRequest:nil];
    }
}

- (void) flushQueue
{
    [cmdQueue removeAllObjects];
    [self setLastRequest:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelQueCountChanged object: self];
}

- (void) parseString:(NSString*)aLine
{
    NSLog(@"Line received: %s", aLine);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    
    aLine = [aLine trimSpacesFromEnds];
    aLine = [aLine lowercaseString];
    if([aLine hasPrefix:@"set gain"]) {
        aLine = [aLine substringFromIndex:8];
        NSArray* theParts = [aLine componentsSeparatedByString:@","];
        int i;
        for(i=0;i<[theParts count];i++){
            if(i<[setPoints count]){
                float aValue = [[theParts objectAtIndex:i] floatValue];
                [self setSetPoint:i withValue:aValue];
            }
        }
        [self setLastRequest:nil];
    }
    else if([aLine hasPrefix:@"get gain"]) {
        aLine = [aLine substringFromIndex:7];
        NSArray* theParts = [aLine componentsSeparatedByString:@","];
        int i=0;
        for(i=0;i<[theParts count];i++){
            if(i<[setPoints count]){
                float readBack = [[theParts objectAtIndex:i]floatValue];
                [self setSetPointReadback:i withValue:readBack];
                
                float setValue  =    [[[setPoints objectAtIndex:i] objectForKey:@"setPoint"] floatValue];
                float diff = fabsf(setValue-readBack);
                if((i>=2) && (diff > 0.00001)){
                    NSLog(@"ADEIControl WARNING: index %i: setPoint-readBack > 0.00001 (abs(%f-%f) = %f)\n",i,setValue,readBack,diff);
                }
            }
        }
        [self setLastRequest:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointsChanged object: self];
    }
    
    else if([aLine hasPrefix:@"get temperatures"]) {
        aLine = [aLine substringFromIndex:7];
        NSArray* theParts = [aLine componentsSeparatedByString:@","];
        int i;
        for(i=0;i<[theParts count];i++){
            if(i<[measuredValues count]){
                [self setMeasuredValue:i withValue:[[theParts objectAtIndex:i]doubleValue]];
            }
        }
        [self shipRecords];
        [self setLastRequest:nil];
        
        expertPCControlOnly = [[[measuredValues objectAtIndex:146] objectForKey:@"value"] boolValue];
        zeusHasControl      = [[[measuredValues objectAtIndex:147] objectForKey:@"value"] boolValue];
        orcaHasControl      = [[[measuredValues objectAtIndex:148] objectForKey:@"value"] boolValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelMeasuredValuesChanged object: self];
    }
    [self processNextCommandFromQueue];
}
#pragma mark ***Data Records
- (uint32_t) dataId { return dataId; }
- (void) setDataId: (uint32_t) DataId
{
    dataId = DataId;
}
- (void) setDataIds:(id)assigner
{
    dataId   = [assigner assignDataIds:kLongForm];
}

- (void) syncDataIdsWith:(id)anOtherDevice
{
    [self setDataId:[anOtherDevice dataId]];
}

- (void) appendDataDescription:(ORDataPacket*)aDataPacket userInfo:(NSDictionary*)userInfo
{
    //----------------------------------------------------------------------------------------
    // first add our description to the data description
    [aDataPacket addDataDescriptionItem:[self dataRecordDescription] forKey:@"ADEIControl"];
}

- (NSDictionary*) dataRecordDescription
{
    NSMutableDictionary* dataDictionary = [NSMutableDictionary dictionary];
    NSDictionary* aDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ORADEIControlDecoderForAdc",@"decoder",
                                 [NSNumber numberWithLong:dataId],   @"dataId",
                                 [NSNumber numberWithBool:NO],       @"variable",
                                 [NSNumber numberWithLong:kADEIControlRecordSize],       @"length",
                                 nil];
    [dataDictionary setObject:aDictionary forKey:@"Temperatures"];
    
    return dataDictionary;
}

- (void) checkShipValueDictionary
{
    if(!shipValueDictionary){
        shipValueDictionary = [[NSMutableDictionary dictionary] retain];
        int i;
        int index=0;
        for(i=0;i<kNumToShip;i++){
            NSString* itemIndex = itemsToShip[index++];
            NSString* itemName  = itemsToShip[index++];
            NSString* aName = [NSString stringWithFormat:@"(%@) %@",itemIndex,itemName];
            [shipValueDictionary setObject:aName forKey:itemIndex];
        }
    }
}

- (void) shipRecords
{
    [self checkShipValueDictionary];

    time_t    ut_Time;
    time(&ut_Time);
    time_t  timeMeasured = ut_Time;

    for(NSString* aKey in shipValueDictionary){
        int j = [aKey intValue];
        if(j<[measuredValues count]){
            if([[ORGlobal sharedGlobal] runInProgress]){
                uint32_t record[kADEIControlRecordSize];
                record[0] = dataId | kADEIControlRecordSize;
                record[1] = ([self uniqueIdNumber] & 0x0000fffff);
                record[2] = (uint32_t)timeMeasured;
                record[3] = j;

                union {
                    double asDouble;
                    uint32_t asLong[2];
                } theData;
                NSString* s = [[measuredValues objectAtIndex:j]objectForKey:@"value"];
                double aValue = [s doubleValue];
                theData.asDouble = aValue;
                record[4] = theData.asLong[0];
                record[5] = theData.asLong[1];
                record[6] = 0; //spares
                record[7] = 0;
                record[8] = 0;

                [[NSNotificationCenter defaultCenter] postNotificationName:ORQueueRecordForShippingNotification
                                                                    object:[NSData dataWithBytes:record length:sizeof(int32_t)*kADEIControlRecordSize]];
            }
        }
    }
}

- (NSString*) setPointFile
{
    if(setPointFile==nil)return @"";
    else return setPointFile;
}

- (void) setSetPointFile:(NSString*)aPath
{
    [setPointFile autorelease];
    setPointFile = [aPath copy];
}

- (NSUInteger) queCount
{
	return [cmdQueue count];
}

- (BOOL) isBusy
{
    return [self queCount]!=0 || lastRequest!=nil;
}

- (NSString*) lastRequest
{
	return lastRequest;
}

- (void) setLastRequest:(NSString*)aRequest
{
	[aRequest retain];
	[lastRequest release];
	lastRequest = aRequest;    
}

- (NSString*) commonScriptMethods
{
    NSArray* selectorArray = [NSArray arrayWithObjects:
                              @"isBusy",
                              @"writeSetpoints",
                              @"readBackSetpoints",
                              @"readMeasuredValues",
                              @"readSetPointsFile:(NSString*)",
                              @"setSetPoint:(int) withValue:(float)",
                              @"setPointAtIndex:(int)",
                              @"setPointReadBackAtIndex:(int)",
                              @"measuredValueAtIndex:(int)",
                              @"pushReadBacksToSetPoints",
                              nil];
    
    return [selectorArray componentsJoinedByString:@"\n"];
}

- (void) setVerbose:(BOOL)aState
{
    [[[self undoManager] prepareWithInvocationTarget:self] setVerbose:verbose];
    verbose = aState;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelVerboseChanged object:self];
}

- (BOOL) showFormattedDates
{
    return showFormattedDates;
}
- (void) setShowFormattedDates:(BOOL)aState
{
    [[[self undoManager] prepareWithInvocationTarget:self] setShowFormattedDates:showFormattedDates];
    showFormattedDates = aState;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelShowFormattedDatesChanged object:self];
}

- (BOOL) verbose
{
    return verbose;
}

- (void) pushReadBacksToSetPoints
{
    int i;
    for(i=0;i<[setPoints count];i++){
        float theReadBack = [[self setPointReadBackAtIndex:i] floatValue];
        [self setSetPoint:i withValue:theReadBack];
    }
}
- (int) pollTime
{
    return pollTime;
}

- (void) setPollTime:(int)aPollTime
{
    [[[self undoManager] prepareWithInvocationTarget:self] setPollTime:pollTime];
    pollTime = aPollTime;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelPollTimeChanged object:self];
    
    if(pollTime){
        [self performSelector:@selector(pollMeasuredValues) withObject:nil afterDelay:.2];
    }
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pollMeasuredValues) object:nil];
    }
}

#pragma mark ***Archival
- (id) initWithCoder:(NSCoder*)decoder
{
	self = [super initWithCoder:decoder];

	[[self undoManager] disableUndoRegistration];
    
	[self setWasConnected:      [decoder decodeBoolForKey:	 @"wasConnected"]];
    [self setIpAddress:         [decoder decodeObjectForKey: @"ORADEIControlModelIpAddress"]];
    [self setSetPointFile:      [decoder decodeObjectForKey: @"setPointFile"]];
    [self setSetPoints:         [decoder decodeObjectForKey: @"setPoints"]];
    [self setVerbose:           [decoder decodeBoolForKey:   @"verbose"]];
    [self setShowFormattedDates:[decoder decodeBoolForKey:   @"showFormattedDates"]];
    [self setPostRegulationFile:[decoder decodeObjectForKey: @"postRegulationFile"]];
    [self setPostRegulationArray:[decoder decodeObjectForKey:@"postRegulationArray"]];
    [self setPollTime:          [decoder decodeIntForKey:@"pollTime"]];
    if(!setPoints)[self createSetPointArray];
    
    [self createMeasuredValueArray];
    
    if(wasConnected)[self connect];
    
	[[self undoManager] enableUndoRegistration];

	return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:setPointFile        forKey:@"setPointFile"];
    [encoder encodeBool:  wasConnected        forKey:@"wasConnected"];
    [encoder encodeBool:  verbose             forKey:@"verbose"];
    [encoder encodeObject:ipAddress           forKey:@"ORADEIControlModelIpAddress"];
    [encoder encodeObject:setPoints           forKey:@"setPoints"];
    [encoder encodeBool:showFormattedDates    forKey:@"showFormattedDates"];
    [encoder encodeObject:postRegulationFile  forKey: @"postRegulationFile"];
    [encoder encodeObject:postRegulationArray forKey: @"postRegulationArray"];
    [encoder encodeInteger:pollTime               forKey: @"pollTime"];
}

#pragma mark *** Commands
- (void) writeSetpoints
{
    if([self isConnected]){
        NSMutableString* cmd = [NSMutableString stringWithString:@"set gain"];
        [cmd appendString:@":"];
        int i;
        int maxIndex = (int)[setPoints count];
        for(i=0;i<maxIndex;i++){
            float valueToWrite = [[[setPoints objectAtIndex:i] objectForKey:@"setPoint"] floatValue];
            [cmd appendFormat:@"%f",valueToWrite];
            if(i != maxIndex-1)[cmd appendString:@","];
        }
        [self writeCmdString:cmd];
    }
}

- (void) readBackSetpoints
{
    if([self isConnected]){
        [self writeCmdString:@"get gain"];
    }
}

- (void) readMeasuredValues
{
    if([self isConnected]){
        [self writeCmdString:@"get temperatures"];
        NSLog(@"Request IST values\n");
    }
}

- (void) writeCmdString:(NSString*)aCommand
{
	if(!cmdQueue)cmdQueue = [[ORSafeQueue alloc] init];
    aCommand = [aCommand removeNLandCRs]; //no LF or CR as per KIT request
    if(verbose)NSLog(@"ADEIControl enqueued cmd: %@\n",aCommand);
	[cmdQueue enqueue:aCommand];
	[[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelQueCountChanged object: self];
	[self processNextCommandFromQueue];
}

- (void) readSetPointsFile:(NSString*) aPath
{
    [setPoints release];
    setPoints = [[NSMutableArray array] retain];
    
	[self setSetPointFile:aPath];
    NSMutableArray* anArray = [[NSArray arrayWithContentsOfFile:aPath]mutableCopy];
    [self setSetPoints: anArray];
    [anArray release];
	[[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelSetPointFileChanged object:self];
}

- (void) saveSetPointsFile:(NSString*) aPath
{
	NSString* fullFileName = [aPath stringByExpandingTildeInPath];
	NSString* s = [NSString stringWithFormat:@"%@",setPoints];
	[s writeToFile:fullFileName atomically:NO encoding:NSASCIIStringEncoding error:nil];
}

- (void) setPostRegulationArray:(NSMutableArray*)anArray
{
    [anArray retain];
    [postRegulationArray release];
    postRegulationArray = anArray;
}

- (void) readPostRegulationFile:(NSString*) aPath
{
    [self setPostRegulationFile:aPath];
    [postRegulationArray release];
    postRegulationArray = [[NSMutableArray array] retain];
    NSString* s = [NSString stringWithContentsOfFile:[aPath stringByExpandingTildeInPath]  encoding:NSASCIIStringEncoding error:nil];
    NSArray* lines = [s componentsSeparatedByString:@"\n"];
    for(NSString* aLine in lines){
        NSArray* parts = [aLine componentsSeparatedByString:@","];
        NSString* vess      = @"";
        NSString* post      = @"";
        NSString* offset    = @"";
        if([parts count]>=1)vess    = [parts objectAtIndex:0];
        if([parts count]>=2)post    = [parts objectAtIndex:1];
        if([parts count]>=3)offset  = [parts objectAtIndex:2];

        [postRegulationArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:vess,kVesselVoltageSetPt,post, kPostRegulationScaleFactor,offset, kPowerSupplyOffset,nil]];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}

- (void) savePostRegulationFile:(NSString*) aPath
{
    NSString* fullFileName = [aPath stringByExpandingTildeInPath];
    NSString* s = @"";
    for(NSDictionary* anEntry in postRegulationArray){
        s = [s stringByAppendingFormat:@"%f,%f,%f\n",[[anEntry objectForKey:kVesselVoltageSetPt]doubleValue],[[anEntry objectForKey:kPostRegulationScaleFactor]doubleValue],[[anEntry objectForKey:kPowerSupplyOffset]doubleValue]];
    }
    [s writeToFile:fullFileName atomically:YES encoding:NSASCIIStringEncoding error:nil];
    [self setPostRegulationFile:fullFileName];
}

- (NSString*) postRegulationFile
{
    if(!postRegulationFile)return @"";
    else return postRegulationFile;
}

- (void) setPostRegulationFile:(NSString*)aPath
{
    [[[self undoManager] prepareWithInvocationTarget:self] setPostRegulationFile:postRegulationFile];
    [aPath retain];
    [postRegulationFile release];
    postRegulationFile = aPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelPostRegulationFileChanged object:self];
}

- (void) addDesiredSetPoint
{
    if(!postRegulationArray)postRegulationArray = [[NSMutableArray array] retain];
    [postRegulationArray addObject:[DesiredSetPoint desiredSetPoint]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelDesiredSetPointAdded object:self];
}

- (void) removeAllDesiredSetPoints
{
    [postRegulationArray release];
    postRegulationArray = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}

- (void) removeDesiredSetPointAtIndex:(int) anIndex
{
    if(anIndex < [postRegulationArray count]){
        [postRegulationArray removeObjectAtIndex:anIndex];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:anIndex] forKey:@"Index"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelDesiredSetPointRemoved object:self userInfo:userInfo];
    }
}

- (uint32_t) numDesiredSetPoints { return (uint32_t)[postRegulationArray count]; }
- (id) desiredSetPointAtIndex:(int)anIndex
{
    if(anIndex>=0 && anIndex<[postRegulationArray count])return [postRegulationArray objectAtIndex:anIndex];
    else return nil;
}
//script convenience methods
- (double) vesselVoltageSetPoint:(int)anIndex
{
    if(anIndex<[postRegulationArray count]){
        NSDictionary* anEntry = [postRegulationArray objectAtIndex:anIndex];
        return [[anEntry objectForKey:kVesselVoltageSetPt] doubleValue];
    }
    return 0;
}

- (double) postRegulationScaleFactor:(int)anIndex
{
    if(anIndex<[postRegulationArray count]){
        NSDictionary* anEntry = [postRegulationArray objectAtIndex:anIndex];
        return [[anEntry objectForKey:kPostRegulationScaleFactor] doubleValue];
    }
    return 0;
}

- (double) powerSupplyOffset:(int)anIndex
{
    if(anIndex<[postRegulationArray count]){
        NSDictionary* anEntry = [postRegulationArray objectAtIndex:anIndex];
        return [[anEntry objectForKey:kPowerSupplyOffset] doubleValue];
    }
    return 0;
}
- (void) setPostRegulationScaleFactor:(int)anIndex withValue:(double)aValue
{
    NSMutableDictionary* anEntry = nil;
    if(anIndex<[postRegulationArray count]){
        anEntry = [postRegulationArray objectAtIndex:anIndex];
    }
    else {
        anEntry = [NSMutableDictionary dictionary];
        [postRegulationArray addObject:anEntry];

    }
    [anEntry setObject:[NSNumber numberWithDouble:aValue] forKey:kPostRegulationScaleFactor];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}

- (void) setPowerSupplyOffset:(int)anIndex withValue:(double)aValue
{
    NSMutableDictionary* anEntry = nil;
    if(anIndex<[postRegulationArray count]){
        anEntry = [postRegulationArray objectAtIndex:anIndex];
    }
    else {
        anEntry = [NSMutableDictionary dictionary];
        [postRegulationArray addObject:anEntry];
        
    }
    [anEntry setObject:[NSNumber numberWithDouble:aValue] forKey:kPowerSupplyOffset];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}

- (void) setVesselVoltageSetPoint:(int)anIndex withValue:(double)aValue
{
    NSMutableDictionary* anEntry = nil;
    if(anIndex<[postRegulationArray count]){
        anEntry = [postRegulationArray objectAtIndex:anIndex];
    }
    else {
        anEntry = [NSMutableDictionary dictionary];
        [postRegulationArray addObject:anEntry];
    }
    [anEntry setObject:[NSNumber numberWithDouble:aValue] forKey:kVesselVoltageSetPt];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}


#pragma mark •••Adc or Bit Processing Protocol
- (void) processIsStarting
{
    //called when processing is started. nothing to do for now.
    //called at the HW polling rate in the process dialog.
    //For now we just use the local polling
}

- (void)processIsStopping
{
    //called when processing is stopping. nothing to do for now.
}

- (void) startProcessCycle
{
    //called at the HW polling rate in the process dialog.
    //ignore for now.
}

- (void) endProcessCycle
{
}

- (NSString*) processingTitle
{
    NSString* s =  [[self fullID] substringFromIndex:2];
    s = [s stringByReplacingOccurrencesOfString:@"Model" withString:@""];
    return s;
}

- (void) setProcessOutput:(int)channel value:(int)value
{
    //nothing to do
}

- (BOOL) processValue:(int)channel
{
    return [self convertedValue:channel]!=0;
}

//!convertedValue: and valueForChan: are the same.
- (double) convertedValue:(int)channel
{
    return [[self measuredValueAtIndex:channel] doubleValue];
}

- (double) maxValueForChan:(int)channel
{
    return 1000; // return something if channel number out of range
}

- (double) lowAlarm:(int)channel
{
    return 0;
}

- (double) highAlarm:(int)channel
{
    return 0;
}

- (double) minValueForChan:(int)channel
{
    return 0; // return something if channel number out of range
}

//alarm limits for the processing framework.
- (void) getAlarmRangeLow:(double*)theLowLimit high:(double*)theHighLimit  channel:(int)channel
{
    *theLowLimit  =  0 ;
    *theHighLimit = 0 ;
}
@end


@implementation ORADEIControlModel (private)
- (void) timeout
{
	@synchronized (self){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
		NSLogError(@"command timeout",@"ADEIControl",nil);
		[self setLastRequest:nil];
        [stringBuffer release];
        stringBuffer = nil;
		[cmdQueue removeAllObjects]; //if we timeout we just flush the queue
		[[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelQueCountChanged object: self];
	}
}

- (void) processNextCommandFromQueue
{
    if(lastRequest)return;
	if([cmdQueue count] > 0){
		NSString* cmd = [cmdQueue dequeue];
		[[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelQueCountChanged object: self];
        [self setLastRequest:cmd];
        [socket writeString:cmd encoding:NSASCIIStringEncoding];
        if(verbose)NSLog(@"ADEIControl sent cmd: %@\n",cmd);
        [self performSelector:@selector(timeout) withObject:nil afterDelay:10];//<----timeout !!!!!!!!!!!!!!!!!!!!
	}
}

- (void) pollMeasuredValues
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pollMeasuredValues) object:nil];
    [self readMeasuredValues];
    if(pollTime)[self performSelector:@selector(pollMeasuredValues) withObject:nil afterDelay:pollTime];
}
@end

//------------------------------------------------------------------------

@implementation DesiredSetPoint
@synthesize data;

+ (id) desiredSetPoint
{
    DesiredSetPoint* aPoint = [[DesiredSetPoint alloc] init];
    return [aPoint autorelease];
}

- (id) init
{
    self = [super init];
    NSMutableDictionary* data        = [NSMutableDictionary dictionary];
    [data setObject:@"" forKey:kVesselVoltageSetPt];
    [data setObject:@"" forKey:kPostRegulationScaleFactor];
    [data setObject:@"" forKey:kPowerSupplyOffset];
    self.data = data;
    return self;
}

- (void) dealloc
{
    self.data = nil;
    [super dealloc];
}


- (id) copyWithZone:(NSZone *)zone
{
    DesiredSetPoint* copy = [[DesiredSetPoint alloc] init];
    copy.data = [[data copyWithZone:zone] autorelease];
    return copy;
}

- (void) setValue:(id)anObject forKey:(id)aKey
{
    if(!anObject)anObject = @"";
    [[[[ORGlobal sharedGlobal] undoManager] prepareWithInvocationTarget:self] setValue:[data objectForKey:aKey] forKey:aKey];
    
    [data setObject:anObject forKey:aKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORADEIControlModelUpdatePostRegulationTable object:self];
}

- (id) objectForKey:(id)aKey
{
    id obj =  [data objectForKey:aKey];
    if(!obj)return @"-";
    else return obj;
}


- (id) initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    self.data    = [decoder decodeObjectForKey:@"data"];
    return self;
}
- (void) encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:data  forKey:@"data"];
}


@end

