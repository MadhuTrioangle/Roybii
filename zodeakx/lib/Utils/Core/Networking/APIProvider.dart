import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:graphql/client.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/ApiException.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/GraphQLWebservice.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';

ApiProvider apiProvider = ApiProvider();

class ApiProvider {
  /// Handling response Types
  dynamic _response(Map<String, dynamic> response) {
    switch (response['status_code']) {
      case 200:
        var responseJson = response;
        return responseJson;
      case 400:
        var responseJson = response;
        return responseJson;
      case 401:
        var responseJson = response;
        return responseJson;
      case 10001:
        var responseJson = response;
        return responseJson;
      //throw BadRequestException(response.toString());
      case 403:
        throw UnauthorisedException(response.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response}');
    }
  }

  /// Query without params
  Future<dynamic> QueryWithoutParams(String query) async {
    var checkConnection = await Connectivity().checkConnectivity();
    QueryOptions options = QueryOptions(
      document: gql(query),
      // only return result from network
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      // ignore cache data if any
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
    );

    if (checkConnection != ConnectivityResult.none) {
      try {
        final QueryResult graphQLQueryResult =
            await graphQLWebservice.startGraphQLClient().query(options);
        securedPrint((graphQLQueryResult.hasException)
            ? graphQLQueryResult.exception
            : graphQLQueryResult.data);
        if (graphQLQueryResult.hasException) {
          var errorStatus = {
            'status_code': 10001,
            'status_message': 'Server Error'
          };
          var validResponse = _response(errorStatus);
          securedPrint(GraphQLError);
          return validResponse;
          // return graphQLQueryResult.exception?.graphqlErrors;
        } else {
          var validResponse = _response(
              graphQLQueryResult.data?[graphQLQueryResult.data?.keys.last]);
          return validResponse;
        }
      } on GraphQLError {
        var errorStatus = {
          'status_code': 10001,
          'status_message': 'Server Error'
        };
        var validResponse = _response(errorStatus);
        securedPrint(GraphQLError);
        return validResponse;
      }
    } else {
      return false;
    }
  }

  /// Query with params
  Future<dynamic> QueryWithParams(
      String query, Map<String, dynamic> params) async {
    var checkConnection = await Connectivity().checkConnectivity();
    QueryOptions options = QueryOptions(
        document: gql(query),
        // only return result from network
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        // ignore cache data if any
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        variables: params);
    securedPrint(params);
    if (checkConnection != ConnectivityResult.none) {
      try {
        final QueryResult graphQLQueryResult =
            await graphQLWebservice.startGraphQLClient().query(options);
        securedPrint((graphQLQueryResult.hasException)
            ? graphQLQueryResult.exception
            : graphQLQueryResult.data);
        if (graphQLQueryResult.hasException) {
          var errorStatus = {
            'status_code': 10001,
            'status_message': 'Server Error'
          };
          var validResponse = _response(errorStatus);
          securedPrint(GraphQLError);
          return validResponse;
          // return graphQLQueryResult.exception?.graphqlErrors;
        } else {
          var validResponse = _response(
              graphQLQueryResult.data?[graphQLQueryResult.data?.keys.last]);
          return validResponse;
        }
      } on GraphQLError {
        var errorStatus = {
          'status_code': 10001,
          'status_message': 'Server Error'
        };
        var validResponse = _response(errorStatus);
        securedPrint(GraphQLError);
        return validResponse;
      }
    } else {
      return false;
    }
  }

  /// Mutation without Params
  Future<dynamic> MutationWithoutParams(String mutation) async {
    var checkConnection = await Connectivity().checkConnectivity();
    MutationOptions options = MutationOptions(
      document: gql(mutation),
      // only return result from network
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      // ignore cache data if any
      cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
    );
    if (checkConnection != ConnectivityResult.none) {
      try {
        final QueryResult graphQLQueryResult =
            await graphQLWebservice.startGraphQLClient().mutate(options);
        securedPrint((graphQLQueryResult.hasException)
            ? graphQLQueryResult.exception
            : graphQLQueryResult.data);
        if (graphQLQueryResult.hasException) {
          var errorStatus = {
            'status_code': 10001,
            'status_message': 'Server Error'
          };
          var validResponse = _response(errorStatus);
          securedPrint(GraphQLError);
          return validResponse;
          //return graphQLQueryResult.exception?.graphqlErrors;
        } else {
          var validResponse = _response(
              graphQLQueryResult.data?[graphQLQueryResult.data?.keys.last]);
          return validResponse;
        }
      } on GraphQLError {
        var errorStatus = {
          'status_code': 10001,
          'status_message': 'Server Error'
        };
        var validResponse = _response(errorStatus);
        securedPrint(GraphQLError);
        return validResponse;
      }
    } else {
      return false;
    }
  }

  /// Mutation With Params
  Future<dynamic> MutationWithParams(
      String mutation, Map<String, dynamic> params) async {
    var checkConnection = await Connectivity().checkConnectivity();
    securedPrint(params);
    MutationOptions options = MutationOptions(
        document: gql(mutation),
        // only return result from network
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        // ignore cache data if any
        cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
        variables: params);
    if (checkConnection != ConnectivityResult.none) {
      try {
        final QueryResult graphQLQueryResult =
            await graphQLWebservice.startGraphQLClient().mutate(options);
        securedPrint((graphQLQueryResult.hasException)
            ? graphQLQueryResult.exception
            : graphQLQueryResult.data);
        if (graphQLQueryResult.hasException) {
          var errorStatus = {
            'status_code': 10001,
            'status_message': 'Server Error'
          };
          var validResponse = _response(errorStatus);
          securedPrint(GraphQLError);
          return validResponse;
          // return graphQLQueryResult.exception?.graphqlErrors;
        } else {
          var validResponse = _response(
              graphQLQueryResult.data?[graphQLQueryResult.data?.keys.last]);
          return validResponse;
        }
      } on GraphQLError {
        var errorStatus = {
          'status_code': 10001,
          'status_message': 'Server Error'
        };
        var validResponse = _response(errorStatus);
        securedPrint(GraphQLError);
        return validResponse;
      }
    } else {
      return false;
    }
  }
}
