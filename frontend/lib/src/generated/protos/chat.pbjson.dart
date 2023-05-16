///
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use responseDescriptor instead')
const Response$json = const {
  '1': 'Response',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `Response`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDescriptor = $convert.base64Decode('CghSZXNwb25zZRIWCgZzdGF0dXMYASABKAVSBnN0YXR1cxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = const {
  '1': 'JoinRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode('CgtKb2luUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1l');
@$core.Deprecated('Use joinResponseDescriptor instead')
const JoinResponse$json = const {
  '1': 'JoinResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 1, '5': 11, '6': '.chat.Response', '10': 'response'},
  ],
};

/// Descriptor for `JoinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinResponseDescriptor = $convert.base64Decode('CgxKb2luUmVzcG9uc2USKgoIcmVzcG9uc2UYASABKAsyDi5jaGF0LlJlc3BvbnNlUghyZXNwb25zZQ==');
@$core.Deprecated('Use getUserDescriptor instead')
const GetUser$json = const {
  '1': 'GetUser',
  '2': const [
    const {'1': 'nothing', '3': 1, '4': 1, '5': 5, '10': 'nothing'},
  ],
};

/// Descriptor for `GetUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserDescriptor = $convert.base64Decode('CgdHZXRVc2VyEhgKB25vdGhpbmcYASABKAVSB25vdGhpbmc=');
@$core.Deprecated('Use sendUserDescriptor instead')
const SendUser$json = const {
  '1': 'SendUser',
  '2': const [
    const {'1': 'user', '3': 1, '4': 3, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `SendUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendUserDescriptor = $convert.base64Decode('CghTZW5kVXNlchISCgR1c2VyGAEgAygJUgR1c2Vy');
@$core.Deprecated('Use sendRequestDescriptor instead')
const SendRequest$json = const {
  '1': 'SendRequest',
  '2': const [
    const {'1': 'from', '3': 1, '4': 1, '5': 9, '10': 'from'},
    const {'1': 'to', '3': 2, '4': 1, '5': 9, '10': 'to'},
    const {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendRequestDescriptor = $convert.base64Decode('CgtTZW5kUmVxdWVzdBISCgRmcm9tGAEgASgJUgRmcm9tEg4KAnRvGAIgASgJUgJ0bxIYCgdtZXNzYWdlGAMgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use resultDescriptor instead')
const Result$json = const {
  '1': 'Result',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'from', '3': 2, '4': 1, '5': 9, '10': 'from'},
    const {'1': 'to', '3': 3, '4': 1, '5': 9, '10': 'to'},
    const {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'time', '3': 5, '4': 1, '5': 9, '10': 'time'},
  ],
};

/// Descriptor for `Result`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultDescriptor = $convert.base64Decode('CgZSZXN1bHQSDgoCaWQYASABKAVSAmlkEhIKBGZyb20YAiABKAlSBGZyb20SDgoCdG8YAyABKAlSAnRvEhgKB21lc3NhZ2UYBCABKAlSB21lc3NhZ2USEgoEdGltZRgFIAEoCVIEdGltZQ==');
@$core.Deprecated('Use sendResponseDescriptor instead')
const SendResponse$json = const {
  '1': 'SendResponse',
  '2': const [
    const {'1': 'response', '3': 1, '4': 1, '5': 11, '6': '.chat.Response', '10': 'response'},
    const {'1': 'result', '3': 2, '4': 1, '5': 11, '6': '.chat.Result', '10': 'result'},
  ],
};

/// Descriptor for `SendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendResponseDescriptor = $convert.base64Decode('CgxTZW5kUmVzcG9uc2USKgoIcmVzcG9uc2UYASABKAsyDi5jaGF0LlJlc3BvbnNlUghyZXNwb25zZRIkCgZyZXN1bHQYAiABKAsyDC5jaGF0LlJlc3VsdFIGcmVzdWx0');
@$core.Deprecated('Use getMessagesDescriptor instead')
const GetMessages$json = const {
  '1': 'GetMessages',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 9, '10': 'user'},
  ],
};

/// Descriptor for `GetMessages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMessagesDescriptor = $convert.base64Decode('CgtHZXRNZXNzYWdlcxISCgR1c2VyGAEgASgJUgR1c2Vy');
@$core.Deprecated('Use sendMessagesDescriptor instead')
const SendMessages$json = const {
  '1': 'SendMessages',
  '2': const [
    const {'1': 'response', '3': 1, '4': 1, '5': 11, '6': '.chat.Response', '10': 'response'},
    const {'1': 'message', '3': 2, '4': 3, '5': 11, '6': '.chat.Result', '10': 'message'},
  ],
};

/// Descriptor for `SendMessages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessagesDescriptor = $convert.base64Decode('CgxTZW5kTWVzc2FnZXMSKgoIcmVzcG9uc2UYASABKAsyDi5jaGF0LlJlc3BvbnNlUghyZXNwb25zZRImCgdtZXNzYWdlGAIgAygLMgwuY2hhdC5SZXN1bHRSB21lc3NhZ2U=');
