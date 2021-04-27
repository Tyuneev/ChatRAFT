#ifndef KONAN_LIBCRAFT_H
#define KONAN_LIBCRAFT_H
#ifdef __cplusplus
extern "C" {
#endif
#ifdef __cplusplus
typedef bool            libcraft_KBoolean;
#else
typedef _Bool           libcraft_KBoolean;
#endif
typedef unsigned short     libcraft_KChar;
typedef signed char        libcraft_KByte;
typedef short              libcraft_KShort;
typedef int                libcraft_KInt;
typedef long long          libcraft_KLong;
typedef unsigned char      libcraft_KUByte;
typedef unsigned short     libcraft_KUShort;
typedef unsigned int       libcraft_KUInt;
typedef unsigned long long libcraft_KULong;
typedef float              libcraft_KFloat;
typedef double             libcraft_KDouble;
typedef float __attribute__ ((__vector_size__ (16))) libcraft_KVector128;
typedef void*              libcraft_KNativePtr;
struct libcraft_KType;
typedef struct libcraft_KType libcraft_KType;

typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Byte;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Short;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Int;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Long;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Float;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Double;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Char;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Boolean;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Unit;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Array;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_Args;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_Craft;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_CraftAppArgs;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_persistence_NodeKey;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_ByteArray;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlinx_serialization_SerializationConstructorMarker;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_Any;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_persistence_NodeKey_$serializer;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlinx_serialization_SerialDescriptor;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlinx_serialization_Decoder;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlinx_serialization_Encoder;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_persistence_NodeKey_Companion;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlinx_serialization_KSerializer;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_kotlin_text_StringBuilder;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_util_FloatLong;
typedef struct {
  libcraft_KNativePtr pinned;
} libcraft_kref_craft_util_FloatLong_FloatLongSerializer;


typedef struct {
  /* Service functions. */
  void (*DisposeStablePointer)(libcraft_KNativePtr ptr);
  void (*DisposeString)(const char* string);
  libcraft_KBoolean (*IsInstance)(libcraft_KNativePtr ref, const libcraft_KType* type);
  libcraft_kref_kotlin_Byte (*createNullableByte)(libcraft_KByte);
  libcraft_kref_kotlin_Short (*createNullableShort)(libcraft_KShort);
  libcraft_kref_kotlin_Int (*createNullableInt)(libcraft_KInt);
  libcraft_kref_kotlin_Long (*createNullableLong)(libcraft_KLong);
  libcraft_kref_kotlin_Float (*createNullableFloat)(libcraft_KFloat);
  libcraft_kref_kotlin_Double (*createNullableDouble)(libcraft_KDouble);
  libcraft_kref_kotlin_Char (*createNullableChar)(libcraft_KChar);
  libcraft_kref_kotlin_Boolean (*createNullableBoolean)(libcraft_KBoolean);
  libcraft_kref_kotlin_Unit (*createNullableUnit)(void);

  /* User functions. */
  struct {
    struct {
      struct {
        void (*main)(libcraft_kref_kotlin_Array args);
        struct {
          libcraft_KType* (*_type)(void);
          libcraft_kref_craft_Args (*Args)(const char* name, const char* path, libcraft_KInt privatePort, libcraft_KInt publicPort, const char* publicAddress, const char* internalAddress, libcraft_KBoolean isActive);
          const char* (*get_internalAddress)(libcraft_kref_craft_Args thiz);
          libcraft_KBoolean (*get_isActive)(libcraft_kref_craft_Args thiz);
          const char* (*get_name)(libcraft_kref_craft_Args thiz);
          const char* (*get_path)(libcraft_kref_craft_Args thiz);
          libcraft_KInt (*get_privatePort)(libcraft_kref_craft_Args thiz);
          const char* (*get_publicAddress)(libcraft_kref_craft_Args thiz);
          libcraft_KInt (*get_publicPort)(libcraft_kref_craft_Args thiz);
        } Args;
        struct {
          libcraft_KType* (*_type)(void);
          libcraft_kref_craft_Craft (*_instance)();
          libcraft_KInt (*run)(libcraft_kref_craft_Craft thiz, const char* name, const char* path, libcraft_KInt privatePort, libcraft_KInt publicPort, const char* publicAddress, const char* internalAddress, libcraft_KBoolean isActive);
        } Craft;
        struct {
          libcraft_KType* (*_type)(void);
          libcraft_kref_craft_CraftAppArgs (*_instance)();
          const char* (*get_InternalAddressName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_IsActiveName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_NameName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_PathToStorageName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_PrivatePortName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_PublicAddressName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_PublicPortName)(libcraft_kref_craft_CraftAppArgs thiz);
          const char* (*get_TestAppName)(libcraft_kref_craft_CraftAppArgs thiz);
        } CraftAppArgs;
        struct {
          struct {
          } control;
          struct {
          } entry;
          struct {
          } vote;
        } actions;
        struct {
          struct {
          } cluster;
        } core;
        struct {
        } error_handling;
        struct {
        } events;
        struct {
          struct {
            libcraft_KType* (*_type)(void);
            libcraft_kref_craft_persistence_NodeKey (*NodeKey)(libcraft_KInt seen1, libcraft_kref_kotlin_ByteArray data, libcraft_kref_kotlinx_serialization_SerializationConstructorMarker serializationConstructorMarker);
            libcraft_kref_craft_persistence_NodeKey (*NodeKey_)(libcraft_kref_kotlin_ByteArray data);
            libcraft_kref_kotlin_ByteArray (*get_data)(libcraft_kref_craft_persistence_NodeKey thiz);
            libcraft_KInt (*compareTo)(libcraft_kref_craft_persistence_NodeKey thiz, libcraft_kref_craft_persistence_NodeKey other);
            libcraft_kref_kotlin_ByteArray (*component1)(libcraft_kref_craft_persistence_NodeKey thiz);
            libcraft_kref_craft_persistence_NodeKey (*copy)(libcraft_kref_craft_persistence_NodeKey thiz, libcraft_kref_kotlin_ByteArray data);
            libcraft_KBoolean (*equals)(libcraft_kref_craft_persistence_NodeKey thiz, libcraft_kref_kotlin_Any other);
            libcraft_KInt (*hashCode)(libcraft_kref_craft_persistence_NodeKey thiz);
            const char* (*toString)(libcraft_kref_craft_persistence_NodeKey thiz);
            struct {
              libcraft_KType* (*_type)(void);
              libcraft_kref_craft_persistence_NodeKey_$serializer (*_instance)();
              libcraft_kref_kotlinx_serialization_SerialDescriptor (*get_descriptor)(libcraft_kref_craft_persistence_NodeKey_$serializer thiz);
              libcraft_kref_kotlin_Array (*childSerializers)(libcraft_kref_craft_persistence_NodeKey_$serializer thiz);
              libcraft_kref_craft_persistence_NodeKey (*deserialize)(libcraft_kref_craft_persistence_NodeKey_$serializer thiz, libcraft_kref_kotlinx_serialization_Decoder decoder);
              void (*serialize)(libcraft_kref_craft_persistence_NodeKey_$serializer thiz, libcraft_kref_kotlinx_serialization_Encoder encoder, libcraft_kref_craft_persistence_NodeKey value);
            } $serializer;
            struct {
              libcraft_KType* (*_type)(void);
              libcraft_kref_craft_persistence_NodeKey_Companion (*_instance)();
              libcraft_kref_kotlinx_serialization_KSerializer (*serializer)(libcraft_kref_craft_persistence_NodeKey_Companion thiz);
            } Companion;
          } NodeKey;
          struct {
          } mdbx;
          struct {
          } raft_log;
        } persistence;
        struct {
        } socket;
        struct {
          const char* (*get_HEX_CHARS)();
          libcraft_kref_kotlin_text_StringBuilder (*get_asHex)(libcraft_kref_kotlin_ByteArray thiz);
          libcraft_KLong (*epoch)();
          struct {
            libcraft_KType* (*_type)(void);
            libcraft_kref_craft_util_FloatLong (*FloatLong)(libcraft_KFloat float_, libcraft_KLong long_);
            libcraft_KFloat (*get_float)(libcraft_kref_craft_util_FloatLong thiz);
            libcraft_KLong (*get_long)(libcraft_kref_craft_util_FloatLong thiz);
            struct {
              libcraft_KType* (*_type)(void);
              libcraft_kref_craft_util_FloatLong_FloatLongSerializer (*_instance)();
              libcraft_kref_kotlinx_serialization_SerialDescriptor (*get_descriptor)(libcraft_kref_craft_util_FloatLong_FloatLongSerializer thiz);
              libcraft_kref_craft_util_FloatLong (*deserialize)(libcraft_kref_craft_util_FloatLong_FloatLongSerializer thiz, libcraft_kref_kotlinx_serialization_Decoder decoder);
              void (*serialize)(libcraft_kref_craft_util_FloatLong_FloatLongSerializer thiz, libcraft_kref_kotlinx_serialization_Encoder encoder, libcraft_kref_craft_util_FloatLong value);
              libcraft_kref_kotlinx_serialization_KSerializer (*serializer)(libcraft_kref_craft_util_FloatLong_FloatLongSerializer thiz);
            } FloatLongSerializer;
          } FloatLong;
        } util;
      } craft;
    } root;
  } kotlin;
} libcraft_ExportedSymbols;
extern libcraft_ExportedSymbols* libcraft_symbols(void);
#ifdef __cplusplus
}  /* extern "C" */
#endif
#endif  /* KONAN_LIBCRAFT_H */
