//
//  XZCareConfigure.h
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-09-29.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#ifndef __XZCARECONFIGURE_H__
#define __XZCARECONFIGURE_H__

#ifndef DSIABLE_LEAVESTUDY_UI
#define DSIABLE_LEAVESTUDY_UI
#endif

#ifndef DSIABLE_PROFILEEXTENSION_UI
#define DSIABLE_PROFILEEXTENSION_UI
#endif

#ifndef DSIABLE_LOGIN_UI
#define DSIABLE_LOGIN_UI
#endif

#ifndef DSIABLE_SHOWCONSENTDOCUMENT_UI
#define DSIABLE_SHOWCONSENTDOCUMENT_UI
#endif

#ifndef APP_AS_SERVICECARE_TYPE
#define APP_AS_SERVICECARE_TYPE
#endif

#ifndef __USING_SINGLESHARING_OPTION__
#define __USING_SINGLESHARING_OPTION__
#endif

#ifndef __USING_NOSHARING_OPTION__
#define __USING_NOSHARING_OPTION__
#endif

#ifdef __NEED_ONLINE_REGISTER__
#unddef __NEED_ONLINE_REGISTER__
#endif

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#define _USE_APP_BUNDLE__

#ifdef _USE_APP_BUNDLE__
#undef _USE_APP_BUNDLE__
#endif


#ifdef SHOW_LICENSE_VIEW
#undef SHOW_LICENSE_VIEW
#endif

#ifndef __DASHBOARD_SETTING_UNEDITABLE__
#define __DASHBOARD_SETTING_UNEDITABLE__
#endif

#ifdef SHOW_CONSENT_PREVIEW
#undef SHOW_CONSENT_PREVIEW
#endif

#ifndef __NEED_CONFIRM_MODIFY_ACTIVITY_LOG__
#define __NEED_CONFIRM_MODIFY_ACTIVITY_LOG__
#endif

#ifdef __SHOW_REMINDER_SETTING_VIEW__
#undef __SHOW_REMINDER_SETTING_VIEW__
#endif


#ifndef __USE_MMOL_GLUCOSE_UNIT__
#define __USE_MMOL_GLUCOSE_UNIT__
#endif


//#ifndef __NEED_RECONSENT_PROCESS__
//#define __NEED_RECONSENT_PROCESS__
//#endif

#endif
