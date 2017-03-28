//
//  NOMGEOConfigration.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-21.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOConfigration.h"
#import "NOMCountryInfo.h"

#define GEOSPAN_QUERY_DEGREE    1.0

#define GEOSPAN_QUERY_LIMIT    6 //15 //30      //km
#define GEOEARTH_RADIUM		6371.0		//km

#define MAPVIEW_OBJECT_STEP_LIMIT    2 //30      //km


@implementation NOMGEOConfigration

+ (double) toRadian: (double) val
{
	return val * (M_PI / 180);
}

+(double)GetAnnotationIntervalLimitInMapView
{
    return MAPVIEW_OBJECT_STEP_LIMIT;
}

+(double)GetMaxQueryGEOSpanDegree
{
    return GEOSPAN_QUERY_DEGREE;
}

+(double)GetQueryGEOSpanLimit
{
    return GEOSPAN_QUERY_LIMIT;
}

+(double)GetAnnotationDistanceOnMapView:(double)dGEODistance viewWidth:(double)dUIWidth geoSpan:(double)dGEPSpan
{
    double dRet = 0;
    
    if(dUIWidth <= 0)
        return dRet;
    
    dRet = dUIWidth*dGEODistance/dGEPSpan;
    
    return dRet;
}

+(double)LongitudeDifferenceByDistance:(double)distKM alongLantitude:(double)lanCenter
{
    double angle = [NOMGEOConfigration toRadian:fabs(lanCenter)];
    double r = GEOEARTH_RADIUM*cos(angle);
    if(r == 0)
        return 0;
    
    double lonDist = 360.0*distKM/(2.0*M_PI*r);
    
    return lonDist;
}

+(double)LantitudeDifferenceByDistance:(double)distKM
{
    double lonDist = 360.0*distKM/(2.0*M_PI*GEOEARTH_RADIUM);
    
    return lonDist;
}

+(NSString*)GetCountry:(int)index
{
    NSString* szRet = @"";

    if(0 <= index && index < NOM_COUNTRY_NUMBER)
    {
        switch(index)
        {
            case 0:
                return NOM_COUNTRY_0;
            case 1:
                return NOM_COUNTRY_1;
            case 2:
                return NOM_COUNTRY_2;
            case 3:
                return NOM_COUNTRY_3;
            case 4:
                return NOM_COUNTRY_4;
            case 5:
                return NOM_COUNTRY_5;
            case 6:
                return NOM_COUNTRY_6;
            case 7:
                return NOM_COUNTRY_7;
            case 8:
                return NOM_COUNTRY_8;
            case 9:
                return NOM_COUNTRY_9;
            
            case 10:
                return NOM_COUNTRY_10;
            case 11:
                return NOM_COUNTRY_11;
            case 12:
                return NOM_COUNTRY_12;
            case 13:
                return NOM_COUNTRY_13;
            case 14:
                return NOM_COUNTRY_14;
            case 15:
                return NOM_COUNTRY_15;
            case 16:
                return NOM_COUNTRY_16;
            case 17:
                return NOM_COUNTRY_17;
            case 18:
                return NOM_COUNTRY_18;
            case 19:
                return NOM_COUNTRY_19;
            
            case 20:
                return NOM_COUNTRY_20;
            case 21:
                return NOM_COUNTRY_21;
            case 22:
                return NOM_COUNTRY_22;
            case 23:
                return NOM_COUNTRY_23;
            case 24:
                return NOM_COUNTRY_24;
            case 25:
                return NOM_COUNTRY_25;
            case 26:
                return NOM_COUNTRY_26;
            case 27:
                return NOM_COUNTRY_27;
            case 28:
                return NOM_COUNTRY_28;
            case 29:
                return NOM_COUNTRY_29;
            
            case 30:
                return NOM_COUNTRY_30;
            case 31:
                return NOM_COUNTRY_31;
            case 32:
                return NOM_COUNTRY_32;
            case 33:
                return NOM_COUNTRY_33;
            case 34:
                return NOM_COUNTRY_34;
            case 35:
                return NOM_COUNTRY_35;
            case 36:
                return NOM_COUNTRY_36;
            case 37:
                return NOM_COUNTRY_37;
            case 38:
                return NOM_COUNTRY_38;
            case 39:
                return NOM_COUNTRY_39;
            
            case 40:
                return NOM_COUNTRY_40;
            case 41:
                return NOM_COUNTRY_41;
            case 42:
                return NOM_COUNTRY_42;
            case 43:
                return NOM_COUNTRY_43;
            case 44:
                return NOM_COUNTRY_44;
            case 45:
                return NOM_COUNTRY_45;
            case 46:
                return NOM_COUNTRY_46;
            case 47:
                return NOM_COUNTRY_47;
            case 48:
                return NOM_COUNTRY_48;
            case 49:
                return NOM_COUNTRY_49;
            
            case 50:
                return NOM_COUNTRY_50;
            case 51:
                return NOM_COUNTRY_51;
            case 52:
                return NOM_COUNTRY_52;
            case 53:
                return NOM_COUNTRY_53;
            case 54:
                return NOM_COUNTRY_54;
            case 55:
                return NOM_COUNTRY_55;
            case 56:
                return NOM_COUNTRY_56;
            case 57:
                return NOM_COUNTRY_57;
            case 58:
                return NOM_COUNTRY_58;
            case 59:
                return NOM_COUNTRY_59;
      
            case 60:
                return NOM_COUNTRY_60;
            case 61:
                return NOM_COUNTRY_61;
            case 62:
                return NOM_COUNTRY_62;
            case 63:
                return NOM_COUNTRY_63;
            case 64:
                return NOM_COUNTRY_64;
            case 65:
                return NOM_COUNTRY_65;
            case 66:
                return NOM_COUNTRY_66;
            case 67:
                return NOM_COUNTRY_67;
            case 68:
                return NOM_COUNTRY_68;
            case 69:
                return NOM_COUNTRY_69;
                
            case 70:
                return NOM_COUNTRY_70;
            case 71:
                return NOM_COUNTRY_71;
            case 72:
                return NOM_COUNTRY_72;
            case 73:
                return NOM_COUNTRY_73;
            case 74:
                return NOM_COUNTRY_74;
            case 75:
                return NOM_COUNTRY_75;
            case 76:
                return NOM_COUNTRY_76;
            case 77:
                return NOM_COUNTRY_77;
            case 78:
                return NOM_COUNTRY_78;
            case 79:
                return NOM_COUNTRY_79;
                
            case 80:
                return NOM_COUNTRY_80;
            case 81:
                return NOM_COUNTRY_81;
            case 82:
                return NOM_COUNTRY_82;
            case 83:
                return NOM_COUNTRY_83;
            case 84:
                return NOM_COUNTRY_84;
            case 85:
                return NOM_COUNTRY_85;
            case 86:
                return NOM_COUNTRY_86;
            case 87:
                return NOM_COUNTRY_87;
            case 88:
                return NOM_COUNTRY_88;
            case 89:
                return NOM_COUNTRY_89;
 
            case 90:
                return NOM_COUNTRY_90;
            case 91:
                return NOM_COUNTRY_91;
            case 92:
                return NOM_COUNTRY_92;
            case 93:
                return NOM_COUNTRY_93;
            case 94:
                return NOM_COUNTRY_94;
            case 95:
                return NOM_COUNTRY_95;
            case 96:
                return NOM_COUNTRY_96;
            case 97:
                return NOM_COUNTRY_97;
            case 98:
                return NOM_COUNTRY_98;
            case 99:
                return NOM_COUNTRY_99;
//???????????????????????????????????????????????????????????????????????
//???????????????????????????????????????????????????????????????????????
//???????????????????????????????????????????????????????????????????????
            case 100:
                return NOM_COUNTRY_100;
            case 101:
                return NOM_COUNTRY_101;
            case 102:
                return NOM_COUNTRY_102;
            case 103:
                return NOM_COUNTRY_103;
            case 104:
                return NOM_COUNTRY_104;
            case 105:
                return NOM_COUNTRY_105;
            case 106:
                return NOM_COUNTRY_106;
            case 107:
                return NOM_COUNTRY_107;
            case 108:
                return NOM_COUNTRY_108;
            case 109:
                return NOM_COUNTRY_109;
                
            case 110:
                return NOM_COUNTRY_110;
            case 111:
                return NOM_COUNTRY_111;
            case 112:
                return NOM_COUNTRY_112;
            case 113:
                return NOM_COUNTRY_113;
            case 114:
                return NOM_COUNTRY_114;
            case 115:
                return NOM_COUNTRY_115;
            case 116:
                return NOM_COUNTRY_116;
            case 117:
                return NOM_COUNTRY_117;
            case 118:
                return NOM_COUNTRY_118;
            case 119:
                return NOM_COUNTRY_119;
                
            case 120:
                return NOM_COUNTRY_120;
            case 121:
                return NOM_COUNTRY_121;
            case 122:
                return NOM_COUNTRY_122;
            case 123:
                return NOM_COUNTRY_123;
            case 124:
                return NOM_COUNTRY_124;
            case 125:
                return NOM_COUNTRY_125;
            case 126:
                return NOM_COUNTRY_126;
            case 127:
                return NOM_COUNTRY_127;
            case 128:
                return NOM_COUNTRY_128;
            case 129:
                return NOM_COUNTRY_129;
                
            case 130:
                return NOM_COUNTRY_130;
            case 131:
                return NOM_COUNTRY_131;
            case 132:
                return NOM_COUNTRY_132;
            case 133:
                return NOM_COUNTRY_133;
            case 134:
                return NOM_COUNTRY_134;
            case 135:
                return NOM_COUNTRY_135;
            case 136:
                return NOM_COUNTRY_136;
            case 137:
                return NOM_COUNTRY_137;
            case 138:
                return NOM_COUNTRY_138;
            case 139:
                return NOM_COUNTRY_139;
                
            case 140:
                return NOM_COUNTRY_140;
            case 141:
                return NOM_COUNTRY_141;
            case 142:
                return NOM_COUNTRY_142;
            case 143:
                return NOM_COUNTRY_143;
            case 144:
                return NOM_COUNTRY_144;
            case 145:
                return NOM_COUNTRY_145;
            case 146:
                return NOM_COUNTRY_146;
            case 147:
                return NOM_COUNTRY_147;
            case 148:
                return NOM_COUNTRY_148;
            case 149:
                return NOM_COUNTRY_149;
                
            case 150:
                return NOM_COUNTRY_150;
            case 151:
                return NOM_COUNTRY_151;
            case 152:
                return NOM_COUNTRY_152;
            case 153:
                return NOM_COUNTRY_153;
            case 154:
                return NOM_COUNTRY_154;
            case 155:
                return NOM_COUNTRY_155;
            case 156:
                return NOM_COUNTRY_156;
            case 157:
                return NOM_COUNTRY_157;
            case 158:
                return NOM_COUNTRY_158;
            case 159:
                return NOM_COUNTRY_159;
                
            case 160:
                return NOM_COUNTRY_160;
            case 161:
                return NOM_COUNTRY_161;
            case 162:
                return NOM_COUNTRY_162;
            case 163:
                return NOM_COUNTRY_163;
            case 164:
                return NOM_COUNTRY_164;
            case 165:
                return NOM_COUNTRY_165;
            case 166:
                return NOM_COUNTRY_166;
            case 167:
                return NOM_COUNTRY_167;
            case 168:
                return NOM_COUNTRY_168;
            case 169:
                return NOM_COUNTRY_169;
                
            case 170:
                return NOM_COUNTRY_170;
            case 171:
                return NOM_COUNTRY_171;
            case 172:
                return NOM_COUNTRY_172;
            case 173:
                return NOM_COUNTRY_173;
            case 174:
                return NOM_COUNTRY_174;
            case 175:
                return NOM_COUNTRY_175;
            case 176:
                return NOM_COUNTRY_176;
            case 177:
                return NOM_COUNTRY_177;
            case 178:
                return NOM_COUNTRY_178;
            case 179:
                return NOM_COUNTRY_179;
                
            case 180:
                return NOM_COUNTRY_180;
            case 181:
                return NOM_COUNTRY_181;
            case 182:
                return NOM_COUNTRY_182;
            case 183:
                return NOM_COUNTRY_183;
            case 184:
                return NOM_COUNTRY_184;
            case 185:
                return NOM_COUNTRY_185;
            case 186:
                return NOM_COUNTRY_186;
            case 187:
                return NOM_COUNTRY_187;
            case 188:
                return NOM_COUNTRY_188;
            case 189:
                return NOM_COUNTRY_189;
                
            case 190:
                return NOM_COUNTRY_190;
            case 191:
                return NOM_COUNTRY_191;
            case 192:
                return NOM_COUNTRY_192;
            case 193:
                return NOM_COUNTRY_193;
            case 194:
                return NOM_COUNTRY_194;
            case 195:
                return NOM_COUNTRY_195;
            case 196:
                return NOM_COUNTRY_196;
            case 197:
                return NOM_COUNTRY_197;
            case 198:
                return NOM_COUNTRY_198;
            case 199:
                return NOM_COUNTRY_199;
//?????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????
            case 200:
                return NOM_COUNTRY_200;
            case 201:
                return NOM_COUNTRY_201;
            case 202:
                return NOM_COUNTRY_202;
            case 203:
                return NOM_COUNTRY_203;
            case 204:
                return NOM_COUNTRY_204;
            case 205:
                return NOM_COUNTRY_205;
            case 206:
                return NOM_COUNTRY_206;
            case 207:
                return NOM_COUNTRY_207;
            case 208:
                return NOM_COUNTRY_208;
            case 209:
                return NOM_COUNTRY_209;
                
            case 210:
                return NOM_COUNTRY_210;
            case 211:
                return NOM_COUNTRY_211;
            case 212:
                return NOM_COUNTRY_212;
            case 213:
                return NOM_COUNTRY_213;
            case 214:
                return NOM_COUNTRY_214;
            case 215:
                return NOM_COUNTRY_215;
            case 216:
                return NOM_COUNTRY_216;
            case 217:
                return NOM_COUNTRY_217;
            case 218:
                return NOM_COUNTRY_218;
            case 219:
                return NOM_COUNTRY_219;
                
            case 220:
                return NOM_COUNTRY_220;
            case 221:
                return NOM_COUNTRY_221;
            case 222:
                return NOM_COUNTRY_222;
            case 223:
                return NOM_COUNTRY_223;
            case 224:
                return NOM_COUNTRY_224;
            case 225:
                return NOM_COUNTRY_225;
            case 226:
                return NOM_COUNTRY_226;
            case 227:
                return NOM_COUNTRY_227;
            case 228:
                return NOM_COUNTRY_228;
            case 229:
                return NOM_COUNTRY_229;
                
            case 230:
                return NOM_COUNTRY_230;
            case 231:
                return NOM_COUNTRY_231;
            case 232:
                return NOM_COUNTRY_232;
            case 233:
                return NOM_COUNTRY_233;
            case 234:
                return NOM_COUNTRY_234;
            case 235:
                return NOM_COUNTRY_235;
            case 236:
                return NOM_COUNTRY_236;
            case 237:
                return NOM_COUNTRY_237;
            case 238:
                return NOM_COUNTRY_238;
        }
    }
    
    return szRet;
}

+(NSString*)GetCountryKey:(int)index
{
    NSString* szRet = @"";
    
    if(0 <= index && index < NOM_COUNTRY_NUMBER)
    {
        switch(index)
        {
            case 0:
                return NOM_COUNTRY_KEY_0;
            case 1:
                return NOM_COUNTRY_KEY_1;
            case 2:
                return NOM_COUNTRY_KEY_2;
            case 3:
                return NOM_COUNTRY_KEY_3;
            case 4:
                return NOM_COUNTRY_KEY_4;
            case 5:
                return NOM_COUNTRY_KEY_5;
            case 6:
                return NOM_COUNTRY_KEY_6;
            case 7:
                return NOM_COUNTRY_KEY_7;
            case 8:
                return NOM_COUNTRY_KEY_8;
            case 9:
                return NOM_COUNTRY_KEY_9;
                
            case 10:
                return NOM_COUNTRY_KEY_10;
            case 11:
                return NOM_COUNTRY_KEY_11;
            case 12:
                return NOM_COUNTRY_KEY_12;
            case 13:
                return NOM_COUNTRY_KEY_13;
            case 14:
                return NOM_COUNTRY_KEY_14;
            case 15:
                return NOM_COUNTRY_KEY_15;
            case 16:
                return NOM_COUNTRY_KEY_16;
            case 17:
                return NOM_COUNTRY_KEY_17;
            case 18:
                return NOM_COUNTRY_KEY_18;
            case 19:
                return NOM_COUNTRY_KEY_19;
                
            case 20:
                return NOM_COUNTRY_KEY_20;
            case 21:
                return NOM_COUNTRY_KEY_21;
            case 22:
                return NOM_COUNTRY_KEY_22;
            case 23:
                return NOM_COUNTRY_KEY_23;
            case 24:
                return NOM_COUNTRY_KEY_24;
            case 25:
                return NOM_COUNTRY_KEY_25;
            case 26:
                return NOM_COUNTRY_KEY_26;
            case 27:
                return NOM_COUNTRY_KEY_27;
            case 28:
                return NOM_COUNTRY_KEY_28;
            case 29:
                return NOM_COUNTRY_KEY_29;
                
            case 30:
                return NOM_COUNTRY_KEY_30;
            case 31:
                return NOM_COUNTRY_KEY_31;
            case 32:
                return NOM_COUNTRY_KEY_32;
            case 33:
                return NOM_COUNTRY_KEY_33;
            case 34:
                return NOM_COUNTRY_KEY_34;
            case 35:
                return NOM_COUNTRY_KEY_35;
            case 36:
                return NOM_COUNTRY_KEY_36;
            case 37:
                return NOM_COUNTRY_KEY_37;
            case 38:
                return NOM_COUNTRY_KEY_38;
            case 39:
                return NOM_COUNTRY_KEY_39;
                
            case 40:
                return NOM_COUNTRY_KEY_40;
            case 41:
                return NOM_COUNTRY_KEY_41;
            case 42:
                return NOM_COUNTRY_KEY_42;
            case 43:
                return NOM_COUNTRY_KEY_43;
            case 44:
                return NOM_COUNTRY_KEY_44;
            case 45:
                return NOM_COUNTRY_KEY_45;
            case 46:
                return NOM_COUNTRY_KEY_46;
            case 47:
                return NOM_COUNTRY_KEY_47;
            case 48:
                return NOM_COUNTRY_KEY_48;
            case 49:
                return NOM_COUNTRY_KEY_49;
                
            case 50:
                return NOM_COUNTRY_KEY_50;
            case 51:
                return NOM_COUNTRY_KEY_51;
            case 52:
                return NOM_COUNTRY_KEY_52;
            case 53:
                return NOM_COUNTRY_KEY_53;
            case 54:
                return NOM_COUNTRY_KEY_54;
            case 55:
                return NOM_COUNTRY_KEY_55;
            case 56:
                return NOM_COUNTRY_KEY_56;
            case 57:
                return NOM_COUNTRY_KEY_57;
            case 58:
                return NOM_COUNTRY_KEY_58;
            case 59:
                return NOM_COUNTRY_KEY_59;
                
            case 60:
                return NOM_COUNTRY_KEY_60;
            case 61:
                return NOM_COUNTRY_KEY_61;
            case 62:
                return NOM_COUNTRY_KEY_62;
            case 63:
                return NOM_COUNTRY_KEY_63;
            case 64:
                return NOM_COUNTRY_KEY_64;
            case 65:
                return NOM_COUNTRY_KEY_65;
            case 66:
                return NOM_COUNTRY_KEY_66;
            case 67:
                return NOM_COUNTRY_KEY_67;
            case 68:
                return NOM_COUNTRY_KEY_68;
            case 69:
                return NOM_COUNTRY_KEY_69;
                
            case 70:
                return NOM_COUNTRY_KEY_70;
            case 71:
                return NOM_COUNTRY_KEY_71;
            case 72:
                return NOM_COUNTRY_KEY_72;
            case 73:
                return NOM_COUNTRY_KEY_73;
            case 74:
                return NOM_COUNTRY_KEY_74;
            case 75:
                return NOM_COUNTRY_KEY_75;
            case 76:
                return NOM_COUNTRY_KEY_76;
            case 77:
                return NOM_COUNTRY_KEY_77;
            case 78:
                return NOM_COUNTRY_KEY_78;
            case 79:
                return NOM_COUNTRY_KEY_79;
                
            case 80:
                return NOM_COUNTRY_KEY_80;
            case 81:
                return NOM_COUNTRY_KEY_81;
            case 82:
                return NOM_COUNTRY_KEY_82;
            case 83:
                return NOM_COUNTRY_KEY_83;
            case 84:
                return NOM_COUNTRY_KEY_84;
            case 85:
                return NOM_COUNTRY_KEY_85;
            case 86:
                return NOM_COUNTRY_KEY_86;
            case 87:
                return NOM_COUNTRY_KEY_87;
            case 88:
                return NOM_COUNTRY_KEY_88;
            case 89:
                return NOM_COUNTRY_KEY_89;
                
            case 90:
                return NOM_COUNTRY_KEY_90;
            case 91:
                return NOM_COUNTRY_KEY_91;
            case 92:
                return NOM_COUNTRY_KEY_92;
            case 93:
                return NOM_COUNTRY_KEY_93;
            case 94:
                return NOM_COUNTRY_KEY_94;
            case 95:
                return NOM_COUNTRY_KEY_95;
            case 96:
                return NOM_COUNTRY_KEY_96;
            case 97:
                return NOM_COUNTRY_KEY_97;
            case 98:
                return NOM_COUNTRY_KEY_98;
            case 99:
                return NOM_COUNTRY_KEY_99;
//???????????????????????????????????????????????????????????????????????
//???????????????????????????????????????????????????????????????????????
//???????????????????????????????????????????????????????????????????????
            case 100:
                return NOM_COUNTRY_KEY_100;
            case 101:
                return NOM_COUNTRY_KEY_101;
            case 102:
                return NOM_COUNTRY_KEY_102;
            case 103:
                return NOM_COUNTRY_KEY_103;
            case 104:
                return NOM_COUNTRY_KEY_104;
            case 105:
                return NOM_COUNTRY_KEY_105;
            case 106:
                return NOM_COUNTRY_KEY_106;
            case 107:
                return NOM_COUNTRY_KEY_107;
            case 108:
                return NOM_COUNTRY_KEY_108;
            case 109:
                return NOM_COUNTRY_KEY_109;
                
            case 110:
                return NOM_COUNTRY_KEY_110;
            case 111:
                return NOM_COUNTRY_KEY_111;
            case 112:
                return NOM_COUNTRY_KEY_112;
            case 113:
                return NOM_COUNTRY_KEY_113;
            case 114:
                return NOM_COUNTRY_KEY_114;
            case 115:
                return NOM_COUNTRY_KEY_115;
            case 116:
                return NOM_COUNTRY_KEY_116;
            case 117:
                return NOM_COUNTRY_KEY_117;
            case 118:
                return NOM_COUNTRY_KEY_118;
            case 119:
                return NOM_COUNTRY_KEY_119;
                
            case 120:
                return NOM_COUNTRY_KEY_120;
            case 121:
                return NOM_COUNTRY_KEY_121;
            case 122:
                return NOM_COUNTRY_KEY_122;
            case 123:
                return NOM_COUNTRY_KEY_123;
            case 124:
                return NOM_COUNTRY_KEY_124;
            case 125:
                return NOM_COUNTRY_KEY_125;
            case 126:
                return NOM_COUNTRY_KEY_126;
            case 127:
                return NOM_COUNTRY_KEY_127;
            case 128:
                return NOM_COUNTRY_KEY_128;
            case 129:
                return NOM_COUNTRY_KEY_129;
                
            case 130:
                return NOM_COUNTRY_KEY_130;
            case 131:
                return NOM_COUNTRY_KEY_131;
            case 132:
                return NOM_COUNTRY_KEY_132;
            case 133:
                return NOM_COUNTRY_KEY_133;
            case 134:
                return NOM_COUNTRY_KEY_134;
            case 135:
                return NOM_COUNTRY_KEY_135;
            case 136:
                return NOM_COUNTRY_KEY_136;
            case 137:
                return NOM_COUNTRY_KEY_137;
            case 138:
                return NOM_COUNTRY_KEY_138;
            case 139:
                return NOM_COUNTRY_KEY_139;
                
            case 140:
                return NOM_COUNTRY_KEY_140;
            case 141:
                return NOM_COUNTRY_KEY_141;
            case 142:
                return NOM_COUNTRY_KEY_142;
            case 143:
                return NOM_COUNTRY_KEY_143;
            case 144:
                return NOM_COUNTRY_KEY_144;
            case 145:
                return NOM_COUNTRY_KEY_145;
            case 146:
                return NOM_COUNTRY_KEY_146;
            case 147:
                return NOM_COUNTRY_KEY_147;
            case 148:
                return NOM_COUNTRY_KEY_148;
            case 149:
                return NOM_COUNTRY_KEY_149;
                
            case 150:
                return NOM_COUNTRY_KEY_150;
            case 151:
                return NOM_COUNTRY_KEY_151;
            case 152:
                return NOM_COUNTRY_KEY_152;
            case 153:
                return NOM_COUNTRY_KEY_153;
            case 154:
                return NOM_COUNTRY_KEY_154;
            case 155:
                return NOM_COUNTRY_KEY_155;
            case 156:
                return NOM_COUNTRY_KEY_156;
            case 157:
                return NOM_COUNTRY_KEY_157;
            case 158:
                return NOM_COUNTRY_KEY_158;
            case 159:
                return NOM_COUNTRY_KEY_159;
                
            case 160:
                return NOM_COUNTRY_KEY_160;
            case 161:
                return NOM_COUNTRY_KEY_161;
            case 162:
                return NOM_COUNTRY_KEY_162;
            case 163:
                return NOM_COUNTRY_KEY_163;
            case 164:
                return NOM_COUNTRY_KEY_164;
            case 165:
                return NOM_COUNTRY_KEY_165;
            case 166:
                return NOM_COUNTRY_KEY_166;
            case 167:
                return NOM_COUNTRY_KEY_167;
            case 168:
                return NOM_COUNTRY_KEY_168;
            case 169:
                return NOM_COUNTRY_KEY_169;
                
            case 170:
                return NOM_COUNTRY_KEY_170;
            case 171:
                return NOM_COUNTRY_KEY_171;
            case 172:
                return NOM_COUNTRY_KEY_172;
            case 173:
                return NOM_COUNTRY_KEY_173;
            case 174:
                return NOM_COUNTRY_KEY_174;
            case 175:
                return NOM_COUNTRY_KEY_175;
            case 176:
                return NOM_COUNTRY_KEY_176;
            case 177:
                return NOM_COUNTRY_KEY_177;
            case 178:
                return NOM_COUNTRY_KEY_178;
            case 179:
                return NOM_COUNTRY_KEY_179;
                
            case 180:
                return NOM_COUNTRY_KEY_180;
            case 181:
                return NOM_COUNTRY_KEY_181;
            case 182:
                return NOM_COUNTRY_KEY_182;
            case 183:
                return NOM_COUNTRY_KEY_183;
            case 184:
                return NOM_COUNTRY_KEY_184;
            case 185:
                return NOM_COUNTRY_KEY_185;
            case 186:
                return NOM_COUNTRY_KEY_186;
            case 187:
                return NOM_COUNTRY_KEY_187;
            case 188:
                return NOM_COUNTRY_KEY_188;
            case 189:
                return NOM_COUNTRY_KEY_189;
                
            case 190:
                return NOM_COUNTRY_KEY_190;
            case 191:
                return NOM_COUNTRY_KEY_191;
            case 192:
                return NOM_COUNTRY_KEY_192;
            case 193:
                return NOM_COUNTRY_KEY_193;
            case 194:
                return NOM_COUNTRY_KEY_194;
            case 195:
                return NOM_COUNTRY_KEY_195;
            case 196:
                return NOM_COUNTRY_KEY_196;
            case 197:
                return NOM_COUNTRY_KEY_197;
            case 198:
                return NOM_COUNTRY_KEY_198;
            case 199:
                return NOM_COUNTRY_KEY_199;
//?????????????????????????????????????????????????????????
//?????????????????????????????????????????????????????????
            case 200:
                return NOM_COUNTRY_KEY_200;
            case 201:
                return NOM_COUNTRY_KEY_201;
            case 202:
                return NOM_COUNTRY_KEY_202;
            case 203:
                return NOM_COUNTRY_KEY_203;
            case 204:
                return NOM_COUNTRY_KEY_204;
            case 205:
                return NOM_COUNTRY_KEY_205;
            case 206:
                return NOM_COUNTRY_KEY_206;
            case 207:
                return NOM_COUNTRY_KEY_207;
            case 208:
                return NOM_COUNTRY_KEY_208;
            case 209:
                return NOM_COUNTRY_KEY_209;
                
            case 210:
                return NOM_COUNTRY_KEY_210;
            case 211:
                return NOM_COUNTRY_KEY_211;
            case 212:
                return NOM_COUNTRY_KEY_212;
            case 213:
                return NOM_COUNTRY_KEY_213;
            case 214:
                return NOM_COUNTRY_KEY_214;
            case 215:
                return NOM_COUNTRY_KEY_215;
            case 216:
                return NOM_COUNTRY_KEY_216;
            case 217:
                return NOM_COUNTRY_KEY_217;
            case 218:
                return NOM_COUNTRY_KEY_218;
            case 219:
                return NOM_COUNTRY_KEY_219;
                
            case 220:
                return NOM_COUNTRY_KEY_220;
            case 221:
                return NOM_COUNTRY_KEY_221;
            case 222:
                return NOM_COUNTRY_KEY_222;
            case 223:
                return NOM_COUNTRY_KEY_223;
            case 224:
                return NOM_COUNTRY_KEY_224;
            case 225:
                return NOM_COUNTRY_KEY_225;
            case 226:
                return NOM_COUNTRY_KEY_226;
            case 227:
                return NOM_COUNTRY_KEY_227;
            case 228:
                return NOM_COUNTRY_KEY_228;
            case 229:
                return NOM_COUNTRY_KEY_229;
                
            case 230:
                return NOM_COUNTRY_KEY_230;
            case 231:
                return NOM_COUNTRY_KEY_231;
            case 232:
                return NOM_COUNTRY_KEY_232;
            case 233:
                return NOM_COUNTRY_KEY_233;
            case 234:
                return NOM_COUNTRY_KEY_234;
            case 235:
                return NOM_COUNTRY_KEY_235;
            case 236:
                return NOM_COUNTRY_KEY_236;
            case 237:
                return NOM_COUNTRY_KEY_237;
            case 238:
                return NOM_COUNTRY_KEY_238;
        }
    }
    return szRet;
}

static NSString*  g_CurrentCountryCode = nil;

+(void)SetCurrentCountryCode:(NSString*)ISOCountryCode
{
    if(g_CurrentCountryCode != nil)
    {
        g_CurrentCountryCode = nil;
    }

    if(ISOCountryCode != nil)
    {
        g_CurrentCountryCode = ISOCountryCode;
    }
    else
    {
        g_CurrentCountryCode = nil;
    }
}

+(NSString*)GetCurrentCountryCode
{
    return g_CurrentCountryCode;
}


static NSString*  g_CurrentCity = nil;
+(void)SetCurrentCity:(NSString*)city
{
    if(city != nil)
    {
        if(g_CurrentCity != nil)
        {
            g_CurrentCity = nil;
        }
        g_CurrentCity = city;
    }
}

+(NSString*)GetCurrentCity
{
    return g_CurrentCity;
}

static NSString*  g_CurrentCounty = nil;
+(void)SetCurrentCounty:(NSString*)county
{
    if(county != nil)
    {
        if(g_CurrentCounty != nil)
        {
            g_CurrentCounty = nil;
        }
    
        g_CurrentCounty = county;
    }
}

+(NSString*)GetCurrentCounty
{
    return g_CurrentCounty;
}

static NSString*  g_CurrentState = nil;
+(void)SetCurrentState:(NSString*)state
{
    if(state != nil)
    {
        if(g_CurrentState != nil)
        {
            g_CurrentState = nil;
        }
    
        g_CurrentState = state;
    }
}
+(NSString*)GetCurrentState
{
    return g_CurrentState;
}

static NSString*  g_CurrentCountry = nil;
+(void)SetCurrentCountry:(NSString*)country
{
    if(country != nil)
    {
        if(g_CurrentCountry != nil)
        {
            g_CurrentCountry = nil;
        }
        g_CurrentCountry = country;
    }
}

+(NSString*)GetCurrentCountry
{
    return g_CurrentCountry;
}

static NSString*  g_CurrentStreet = nil;
+(void)SetCurrentStreet:(NSString*)street
{
    if(street != nil)
    {
        if(g_CurrentStreet != nil)
        {
            g_CurrentStreet = nil;
        }
        g_CurrentStreet = street;
    }
}

+(NSString*)GetCurrentStreet
{
    return g_CurrentStreet;
}

static NSString*  g_CurrentZipCode = nil;
+(void)SetCurrentZipCode:(NSString*)zipcode
{
    if(zipcode != nil)
    {
        if(g_CurrentZipCode != nil)
        {
            g_CurrentZipCode = nil;
        }
        g_CurrentZipCode = zipcode;
    }
}

+(NSString*)GetCurrentZipCode
{
    return g_CurrentZipCode;
}


static NSString*  g_CurrentStreetNumber = nil;
+(void)SetCurrentStreetNumber:(NSString*)streetNumber
{
    if(streetNumber != nil)
    {
        if(g_CurrentStreetNumber != nil)
        {
            g_CurrentStreetNumber = nil;
        }
        g_CurrentStreetNumber = streetNumber;
    }
}

+(NSString*)GetCurrentStreetNumber
{
    return g_CurrentStreetNumber;
}

+(BOOL)iAdAvailability
{
    if(g_CurrentCountryCode == nil)
        return NO;
    
    if([g_CurrentCountryCode isEqualToString:@"AU"] == YES || [g_CurrentCountryCode isEqualToString:@"AUS"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"036"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:AU"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"CA"] == YES || [g_CurrentCountryCode isEqualToString:@"CAN"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"124"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:CA"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"FR"] == YES || [g_CurrentCountryCode isEqualToString:@"FRA"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"250"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:FR"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"DE"] == YES || [g_CurrentCountryCode isEqualToString:@"DEU"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"276"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:DE"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"IT"] == YES || [g_CurrentCountryCode isEqualToString:@"ITA"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"380"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:IT"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"JP"] == YES || [g_CurrentCountryCode isEqualToString:@"JPN"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"392"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:JP"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"MX"] == YES || [g_CurrentCountryCode isEqualToString:@"MEX"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"484"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:MX"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"NZ"] == YES || [g_CurrentCountryCode isEqualToString:@"NZL"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"554"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:NZ"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"ES"] == YES || [g_CurrentCountryCode isEqualToString:@"ESP"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"724"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:ES"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"GB"] == YES || [g_CurrentCountryCode isEqualToString:@"GBR"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"826"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:GB"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"US"] == YES || [g_CurrentCountryCode isEqualToString:@"USA"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"840"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:US"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"TW"] == YES || [g_CurrentCountryCode isEqualToString:@"TWN"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"158"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:TW"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"HK"] == YES || [g_CurrentCountryCode isEqualToString:@"HKG"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"344"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:HK"] == YES)
    {
        return YES;
    }
    if([g_CurrentCountryCode isEqualToString:@"IE"] == YES || [g_CurrentCountryCode isEqualToString:@"IRL"] == YES ||
       [g_CurrentCountryCode isEqualToString:@"372"] == YES || [g_CurrentCountryCode isEqualToString:@"ISO 3166-2:IE"] == YES)
    {
        return YES;
    }
    
    return NO;
}

+(BOOL)IsChinaCountryCode:(NSString*)ISOCountryCode
{
    BOOL bRet = NO;
    
    if(ISOCountryCode != nil && 0 < ISOCountryCode.length)
    {
        if([ISOCountryCode isEqualToString:@"CN"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"cn"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"cN"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"Cn"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"中国"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"中华人民共和国"] == YES)
        {
            bRet = YES;
        }
    }
    
    return bRet;
}

+(BOOL)IsUSCountryCode:(NSString*)ISOCountryCode
{
    BOOL bRet = NO;
    
    if(ISOCountryCode != nil && 0 < ISOCountryCode.length)
    {
        if([ISOCountryCode isEqualToString:@"US"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"us"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"uS"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"Us"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"840"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"ISO 3166-2:US"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"usa"] == YES)
        {
            bRet = YES;
        }
        else if([ISOCountryCode isEqualToString:@"USA"] == YES)
        {
            bRet = YES;
        }
    }
    
    return bRet;
}

+(BOOL)IsCurrentCountryUS
{
    return [NOMGEOConfigration IsUSCountryCode:g_CurrentCountryCode];
}


+(BOOL)IsSameCountryCode:(NSString*)szCode1 with:(NSString*)szCode2
{
    BOOL bRet = NO;
    if(szCode1 == nil || szCode1.length == 0)
        return bRet;
 
    if(szCode2 == nil || szCode2.length == 0)
        return bRet;
    
    NSString* szNewCode1 = [szCode1 lowercaseString];
    NSString* szNewCode2 = [szCode2 lowercaseString];
    
    if(szNewCode1 == nil || szNewCode1.length == 0)
        return bRet;
    
    if(szNewCode2 == nil || szNewCode2.length == 0)
        return bRet;
    
    if([szNewCode1 isEqualToString:szNewCode2] == YES)
        bRet = YES;
    
    return bRet;
}

static NSString*  g_CurrentReadingCity = nil;
static NSString*  g_CurrentReadingCommunity = nil;

+(void)SetCachedCurrentReadingLocationData:(NSString*)city with:(NSString*)community
{
    g_CurrentReadingCity = city;
    g_CurrentReadingCommunity = community;
}

+(NSString*)GetCachedCurrentReadingLocationCity
{
    return g_CurrentReadingCity;
}

+(NSString*)GetCachedCurrentReadingLocationCommunity
{
    return g_CurrentReadingCommunity;
}

#define NOM_TRAFFIC_ALERT_ZONE_RADIUS_DEFAULT           1000.0
static double g_AlertZoneRadius = NOM_TRAFFIC_ALERT_ZONE_RADIUS_DEFAULT;

+(double)GetTrafficAlertParameter
{
    return g_AlertZoneRadius;
}

+(void)SetTrafficAlertParameter:(double)distance
{
    g_AlertZoneRadius = distance;
}


static double  g_SouthLatitude = 0;
static double  g_NorthLatitude = 0;
static double  g_WestLongitude = 0;
static double  g_NorthLongitude = 0;

+(void)SetCurrentMapRegion:(double)southLat northLat:(double)northLat westLong:(double)westLong eastLong:(double)northLong
{
    g_SouthLatitude = southLat;
    g_NorthLatitude = northLat;
    g_WestLongitude = westLong;
    g_NorthLongitude = northLong;
}

+(void)GetCurrentMapRegion:(double*)southLat northLat:(double*)northLat westLong:(double*)westLong eastLong:(double*)northLong
{
    *southLat = g_SouthLatitude;
    *northLat = g_NorthLatitude;
    *westLong = g_WestLongitude;
    *northLong = g_NorthLongitude;
}

static double g_MapZoom = 1.0;
+(void)SetMapZoomFactor:(double)dZoom
{
    g_MapZoom = dZoom;
}

+(double)GetMapZoomFactor
{
    return g_MapZoom;
}


static id<NOMQueryAnnotationDataDelegate> g_QADelegate = nil;
+(void)RegisterNOMQueryAnnotationDataDelegate:(id<NOMQueryAnnotationDataDelegate>)delegate
{
    g_QADelegate = delegate;
}

+(id<NOMQueryAnnotationDataDelegate>)GetNOMQueryAnnotationDataDelegate
{
    return g_QADelegate;
}


@end
