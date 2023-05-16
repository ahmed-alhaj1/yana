///
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'chat.pb.dart' as $0;
export 'chat.pb.dart';

class ChatClient extends $grpc.Client {
  static final _$join = $grpc.ClientMethod<$0.JoinRequest, $0.JoinResponse>(
      '/chat.Chat/Join',
      ($0.JoinRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.JoinResponse.fromBuffer(value));
  static final _$users = $grpc.ClientMethod<$0.GetUser, $0.SendUser>(
      '/chat.Chat/Users',
      ($0.GetUser value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SendUser.fromBuffer(value));
  static final _$message = $grpc.ClientMethod<$0.GetMessages, $0.SendMessages>(
      '/chat.Chat/Message',
      ($0.GetMessages value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SendMessages.fromBuffer(value));
  static final _$send = $grpc.ClientMethod<$0.SendRequest, $0.SendResponse>(
      '/chat.Chat/Send',
      ($0.SendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SendResponse.fromBuffer(value));

  ChatClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.JoinResponse> join($0.JoinRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$join, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendUser> users($0.GetUser request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$users, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendMessages> message($0.GetMessages request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$message, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendResponse> send($0.SendRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$send, request, options: options);
  }
}

abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.Chat';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.JoinRequest, $0.JoinResponse>(
        'Join',
        join_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRequest.fromBuffer(value),
        ($0.JoinResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUser, $0.SendUser>(
        'Users',
        users_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUser.fromBuffer(value),
        ($0.SendUser value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMessages, $0.SendMessages>(
        'Message',
        message_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMessages.fromBuffer(value),
        ($0.SendMessages value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendRequest, $0.SendResponse>(
        'Send',
        send_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendRequest.fromBuffer(value),
        ($0.SendResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.JoinResponse> join_Pre(
      $grpc.ServiceCall call, $async.Future<$0.JoinRequest> request) async {
    return join(call, await request);
  }

  $async.Future<$0.SendUser> users_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetUser> request) async {
    return users(call, await request);
  }

  $async.Future<$0.SendMessages> message_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetMessages> request) async {
    return message(call, await request);
  }

  $async.Future<$0.SendResponse> send_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SendRequest> request) async {
    return send(call, await request);
  }

  $async.Future<$0.JoinResponse> join(
      $grpc.ServiceCall call, $0.JoinRequest request);
  $async.Future<$0.SendUser> users($grpc.ServiceCall call, $0.GetUser request);
  $async.Future<$0.SendMessages> message(
      $grpc.ServiceCall call, $0.GetMessages request);
  $async.Future<$0.SendResponse> send(
      $grpc.ServiceCall call, $0.SendRequest request);
}
