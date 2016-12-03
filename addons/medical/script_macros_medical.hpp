
#define ALL_BODY_PARTS ["head", "body", "leftarm", "rightarm", "leftleg", "rightleg"]

// scale received pain to 0-2 level to select type of scream
// below 0.25: 0, from 0.25 to 0.5: 1, more than 0.5: 2
#define PAIN_TO_SCREAM(pain) (floor (4 * pain) min 2)

// scale received pain to 0-2 level to select type of scream
// below 0.33: 0, from 0.34 to 0.66: 1, more than 0.67: 2
#define PAIN_TO_MOAN(pain) (floor (3 * pain) min 2)

#define GET_NUMBER(config,default) (if (isNumber (config)) then {getNumber (config)} else {default})
#define GET_STRING(config,default) (if (isText (config)) then {getText (config)} else {default})
#define GET_ARRAY(config,default) (if (isArray (config)) then {getArray (config)} else {default})

// --- blood
// 0.077 l/kg * 80kg = 6.16l
#define DEFAULT_BLOOD_VOLUME 6.0 // in liters

#define BLOOD_VOLUME_CLASS_1_HEMORRHAGE 6.000 // lost less than 15% blood, Class I Hemorrhage
#define BLOOD_VOLUME_CLASS_2_HEMORRHAGE 5.100 // lost more than 15% blood, Class II Hemorrhage
#define BLOOD_VOLUME_CLASS_3_HEMORRHAGE 4.200 // lost more than 30% blood, Class III Hemorrhage
#define BLOOD_VOLUME_CLASS_4_HEMORRHAGE 3.600 // lost more than 40% blood, Class IV Hemorrhage

// IV Change per second calculation:
// 250ml should take 60 seconds to fill. 250ml/60s = 4.166ml/s.
#define IV_CHANGE_PER_SECOND ([1000, 4.166] select GVAR(advancedIVBags)) // in milliliters per second

// Minimum amount of damage required for penetrating wounds (also minDamage for velocity wounds)
#define PENETRATION_THRESHOLD 0.35

// To be replaced by a proper blood pressure calculation
#define BLOOD_LOSS_KNOCK_OUT_THRESHOLD 0.5 // 50% of cardiac output

// --- unconsciousness
#define DEFAULT_KNOCK_OUT_DELAY (15 + random 30)

// --- pain
#define PAIN_UNCONSCIOUS 0.9

// duration in seconds to stay knocked out due to pain
#define PAIN_KNOCK_OUT_DURATION (5 + random 10)
