//
//  Define.h
//  PlayerComponent
//
//  Created by XYG on 14-10-20.
//  Copyright (c) 2014年 xyg. All rights reserved.
//

#ifndef PlayerComponent_Define_h
#define PlayerComponent_Define_h

/**
 * OK
 */
#define OK  1

/**
 * NO GOOD
 */
#define NG  0

/**
 * record data to dahua DAV format
 */
#define  RECORDTYPE_DAV  0

/**
 * record data to MP4 format
 */
#define  RECORDTYPE_MP4  1

/**
 * status of playing
 */
#define STATUS_PLAYING      0
/**
 * status of stoped
 */
#define STATUS_STOPED       1

/**
 * status of pause
 */
#define STATUS_PAUSE        2

/**
 * status of requesting stream
 */
#define STATUS_REQUESING    3

/**
 * status of requesting stream failed
 */
#define STATUS_FAILED       4



/**
 * result from call play
 */
#define RESULT_SOURCE_PLAY      0
#define RESULT_SOURCE_PLAY_DES  "PLAY"
/**
 * result from call stop
 */
#define RESULT_SOURCE_STOP      1
#define RESULT_SOURCE_STOP_DES  "STOP"
/**
 * result from call pause
 */
#define RESULT_SOURCE_PAUSE     2
#define RESULT_SOURCE_PAUSE_DES "PAUSE"
/**
 * result from call resume
 */
#define RESULT_SOURCE_RESUME        3
#define RESULT_SOURCE_RESUME_DES    "RESUME"
/**
 * result from call seek
 */
#define RESULT_SOURCE_SEEK      4
#define RESULT_SOURCE_SEEK_DES  "SEEK"


#define STRATEG_VAL_trateg

/**
 * integer value for true
 */
#define STRATEG_V_BOOL_TRUE			1

/**
 * integer value for false
 */
#define STRATEG_V_BOOL_FALSE		0

/**
 * strateg value : do play
 */
#define STRATEG_V_ACTION_PLAY                       100
/**
 * strateg value : do stop
 */
#define STRATEG_V_ACTION_STOP                       101
/**
 * strateg value : do pause
 */
#define STRATEG_V_ACTION_PAUSE                      102
/**
 * strateg value : do resume
 */
#define STRATEG_V_ACTION_RESUME                     103
/**
 * strateg value : do not display video
 */
#define STRATEG_V_ACTION_DISPLAY_NOT                104
/**
 * strateg value : display video
 */
#define STRATEG_V_ACTION_DISPLAY_YES                105
/**
 * strateg value : do pause and stop recording
 */
#define STRATEG_V_ACTION_PAUSE_AND_STOP_RECORDING	106


/**
 * strateg condition : when page changed, what to do on left page players
 */
#define STRATEG_C_PAGE_CHAGE_LEAF_PAGE  	 1000
/**
 * strateg condition : when page changed, what to do on enter page players
 */
#define STRATEG_C_PAGE_CHAGE_ENTER_PAGE  	 1001
/**
 * strateg condition : when page maximine, what to do on left players
 */
#define STRATEG_C_MAXIMINE_WINDOW  			 1002
/**
 * strateg condition : when page resume, what to do on enter players
 */
#define STRATEG_C_RESUME_WINDOW  			 1003
/**
 * strateg condition : when page splite change, what to do on left players
 */
#define STRATEG_C_SPLITE_LEAF_PLAYER		 1004
/**
 * strateg condition : when page splite change, what to do on enter players
 */
#define STRATEG_C_SPLITE_ENTER_PLAYER		 1005



/**
 * strateg sub-condition : default
 */
#define STRATEG_SUB_C_DEFAULT				 0
/**
 * strateg sub-condition : what to do on recording players
 */
#define STRATEG_SUB_C_PLAYER_IS_RECORDING	 1

#endif
