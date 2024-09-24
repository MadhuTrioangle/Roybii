import 'package:graphql/client.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';

class GraphQLWebservice {
  /// App Web services
  final baseUrl = constant.isdemo ? constant.demoUrl : constant.baseUrl;
  var header = {
    'authorization': "bearer ${constant.userToken.value}",
    'ip': constant.secretCode,
    'source': constant.deviceDetails?.source ?? "",
    'device': constant.deviceDetails?.device ?? "",
    'browser': constant.deviceDetails?.browser ?? "",
    'os': constant.deviceDetails?.os ?? "",
    'platform': constant.deviceDetails?.platform ?? "",
    'lang': constant.pref?.getString("defaultLanguage") ?? "en",
    'location': constant.location.value,
    "userPreferredCurrency": "USD"
  };

  updateLanguage(String lang) {
    header["lang"] = lang;
  }

  /// GraphQL Intitilize
  GraphQLClient startGraphQLClient() {
    var changedToken = {
      'authorization': "bearer ${constant.userToken.value}",
      'location': constant.location.value
    };
    header.addAll(changedToken);
    securedPrint(header);
    final Link appLink = HttpLink(baseUrl, defaultHeaders: header);
    return GraphQLClient(
        link: appLink,
        defaultPolicies: DefaultPolicies(
          watchMutation: Policies(
              fetch: FetchPolicy.cacheAndNetwork,
              cacheReread: CacheRereadPolicy.mergeOptimistic),
          watchQuery: Policies(
              fetch: FetchPolicy.cacheAndNetwork,
              cacheReread: CacheRereadPolicy.mergeOptimistic),
          query: Policies(
              fetch: FetchPolicy.cacheAndNetwork,
              cacheReread: CacheRereadPolicy.mergeOptimistic),
          mutate: Policies(
              fetch: FetchPolicy.cacheAndNetwork,
              cacheReread: CacheRereadPolicy.mergeOptimistic),
        ),
        cache: GraphQLCache(
          store: InMemoryStore(),
          partialDataPolicy: PartialDataCachePolicy.acceptForOptimisticData,
        ));
  }
}

GraphQLWebservice graphQLWebservice = GraphQLWebservice();
